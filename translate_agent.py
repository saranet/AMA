#!/usr/bin/env python3
"""
Flutter Arabic Translation Agent
----------------------------------
Scans all Dart files for hardcoded strings, translates them to Arabic
using Claude API, generates .arb files, and refactors widgets to use
AppLocalizations.

Usage:
    python translate_agent.py --project /path/to/your/flutter/project
    python translate_agent.py --project . --dry-run       # preview only
    python translate_agent.py --project . --arb-only      # skip dart refactor
"""

import os
import re
import json
import time
import argparse
import anthropic
from pathlib import Path


# ── CONFIG ────────────────────────────────────────────────────────────────────

EXCLUDED_DIRS = {
    ".dart_tool", ".idea", ".gradle", "build", "ios/Pods",
    "android/.gradle", "test", ".git", "__pycache__"
}

# Patterns to skip (asset paths, package names, routes, regex, etc.)
SKIP_PATTERNS = [
    r'^assets/',
    r'^packages/',
    r'^\/',
    r'^\.',
    r'^http',
    r'^[A-Z_]{2,}$',          # CONSTANTS
    r'^\d+$',                  # pure numbers
    r'^[a-z][a-zA-Z]*\.',      # method calls like "auth.login"
    r'^[a-z_]+$',              # single snake_case words (keys / ids)
    r'[{}]',                   # template strings
]

# Minimum length to bother translating
MIN_STRING_LENGTH = 3

CLAUDE_MODEL = "claude-opus-4-6"
BATCH_SIZE = 40   # strings per API call


# ── EXTRACTION ────────────────────────────────────────────────────────────────

def should_skip(s: str) -> bool:
    s = s.strip()
    if len(s) < MIN_STRING_LENGTH:
        return True
    for pattern in SKIP_PATTERNS:
        if re.search(pattern, s):
            return True
    return False


def extract_strings_from_file(filepath: str) -> list[dict]:
    """
    Returns list of {string, line, col, context} found in a dart file.
    Captures strings inside Text(...), hint/label text, AppBar titles, etc.
    """
    results = []
    # Match Text("...") or Text('...')  – also labelText, hintText, title
    patterns = [
        r'''Text\(\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''labelText\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''hintText\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''helperText\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''errorText\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''counterText\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''title\s*:\s*Text\(\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''tooltip\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''semanticsLabel\s*:\s*["']([^"'\\]+(?:\\.[^"'\\]*)*)["']''',
        r'''SnackBar\s*\(\s*content\s*:\s*Text\(\s*["']([^"'\\]+)["']''',
        r'''AlertDialog[^;]*?title\s*:\s*Text\(\s*["']([^"'\\]+)["']''',
    ]

    try:
        content = Path(filepath).read_text(encoding="utf-8")
        lines = content.splitlines()

        seen = set()
        for pattern in patterns:
            for m in re.finditer(pattern, content):
                s = m.group(1).strip()
                if should_skip(s) or s in seen:
                    continue
                seen.add(s)
                # find line number
                line_no = content[:m.start()].count('\n') + 1
                results.append({
                    "string": s,
                    "file": filepath,
                    "line": line_no,
                    "pattern": pattern,
                })
    except (UnicodeDecodeError, FileNotFoundError):
        pass

    return results


def scan_project(project_path: str) -> list[dict]:
    print(f"\n🔍  Scanning Dart files in: {project_path}")
    all_strings = []
    total_files = 0

    for root, dirs, files in os.walk(project_path):
        # prune excluded dirs in-place
        dirs[:] = [
            d for d in dirs
            if not any(excl in os.path.join(root, d) for excl in EXCLUDED_DIRS)
        ]
        for filename in files:
            if not filename.endswith(".dart"):
                continue
            filepath = os.path.join(root, filename)
            found = extract_strings_from_file(filepath)
            if found:
                total_files += 1
                all_strings.extend(found)

    # deduplicate by string value, keep first occurrence
    seen = {}
    deduped = []
    for item in all_strings:
        if item["string"] not in seen:
            seen[item["string"]] = True
            deduped.append(item)

    print(f"   Found {len(deduped)} unique strings across {total_files} files")
    return deduped


# ── TRANSLATION ───────────────────────────────────────────────────────────────

def string_to_arb_key(s: str) -> str:
    """Convert 'Or login with fingerprint' → 'orLoginWithFingerprint'"""
    # lowercase, remove special chars, split into words
    cleaned = re.sub(r"[^a-zA-Z0-9\s]", "", s)
    words = cleaned.strip().split()
    if not words:
        return "text_" + str(abs(hash(s)))[:6]
    key = words[0].lower() + "".join(w.capitalize() for w in words[1:])
    return key[:50]  # ARB keys have a practical length limit


def translate_batch(client: anthropic.Anthropic, strings: list[str]) -> dict:
    """
    Sends a batch of strings to Claude and returns {english: arabic} map.
    """
    numbered = "\n".join(f"{i+1}. {s}" for i, s in enumerate(strings))

    prompt = f"""You are a professional Arabic translator specializing in mobile app UI.
Translate each English UI string below into Modern Standard Arabic (MSA), suitable for a mobile app.

Rules:
- Keep translations natural and concise (UI space is limited)
- Preserve any placeholder patterns like {{name}} or %s exactly
- Use proper Arabic punctuation
- Do NOT transliterate — use actual Arabic script
- Respond ONLY with a JSON object mapping each number to its Arabic translation
  Example: {{"1": "أو تسجيل الدخول ببصمة الإصبع", "2": "..."}}

Strings to translate:
{numbered}

Respond with ONLY the JSON object, no extra text."""

    response = client.messages.create(
        model=CLAUDE_MODEL,
        max_tokens=2000,
        messages=[{"role": "user", "content": prompt}]
    )

    raw = response.content[0].text.strip()
    # strip markdown fences if present
    raw = re.sub(r"^```json\s*|^```\s*|\s*```$", "", raw, flags=re.MULTILINE).strip()

    try:
        numbered_translations = json.loads(raw)
        return {
            strings[int(k) - 1]: v
            for k, v in numbered_translations.items()
            if k.isdigit() and 0 < int(k) <= len(strings)
        }
    except (json.JSONDecodeError, KeyError, ValueError) as e:
        print(f"   ⚠️  JSON parse error in batch: {e}")
        return {}


def translate_all_strings(strings: list[dict], dry_run: bool = False) -> dict:
    """
    Returns {english_string: arabic_translation}
    """
    if dry_run:
        print("\n🌐  DRY RUN — skipping Claude API calls")
        return {item["string"]: f"[AR] {item['string']}" for item in strings}

    client = anthropic.Anthropic()   # reads ANTHROPIC_API_KEY from env
    string_list = [item["string"] for item in strings]
    translations = {}

    batches = [string_list[i:i+BATCH_SIZE] for i in range(0, len(string_list), BATCH_SIZE)]
    print(f"\n🌐  Translating {len(string_list)} strings in {len(batches)} batches...")

    for idx, batch in enumerate(batches):
        print(f"   Batch {idx+1}/{len(batches)} ({len(batch)} strings)...", end=" ", flush=True)
        result = translate_batch(client, batch)
        translations.update(result)
        print(f"✓ ({len(result)} translated)")
        if idx < len(batches) - 1:
            time.sleep(0.5)   # gentle rate limiting

    failed = len(string_list) - len(translations)
    if failed:
        print(f"   ⚠️  {failed} strings could not be translated (will be skipped)")

    return translations


# ── ARB GENERATION ────────────────────────────────────────────────────────────

def build_arb_data(strings: list[dict], translations: dict, lang: str) -> dict:
    arb = {"@@locale": lang}
    used_keys = {}

    for item in strings:
        s = item["string"]
        if lang == "ar" and s not in translations:
            continue

        key = string_to_arb_key(s)
        # ensure unique keys
        if key in used_keys:
            key = key + "_" + str(used_keys.get(key, 1))
        used_keys[key] = used_keys.get(key, 0) + 1

        # store key on the item for dart refactoring later
        item["arb_key"] = key

        arb[key] = s if lang == "en" else translations[s]
        arb[f"@{key}"] = {"description": f"From: {Path(item['file']).name}:{item['line']}"}

    return arb


def write_arb_files(project_path: str, en_arb: dict, ar_arb: dict):
    l10n_dir = Path(project_path) / "lib" / "l10n"
    l10n_dir.mkdir(parents=True, exist_ok=True)

    en_path = l10n_dir / "app_en.arb"
    ar_path = l10n_dir / "app_ar.arb"

    en_path.write_text(json.dumps(en_arb, ensure_ascii=False, indent=2), encoding="utf-8")
    ar_path.write_text(json.dumps(ar_arb, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"\n✅  Written: {en_path}")
    print(f"✅  Written: {ar_path}")


# ── DART REFACTORING ──────────────────────────────────────────────────────────

def refactor_dart_file(filepath: str, string_to_key: dict) -> tuple[str, int]:
    """
    Replaces hardcoded strings with AppLocalizations calls.
    Returns (new_content, number_of_replacements).
    """
    content = Path(filepath).read_text(encoding="utf-8")
    original = content
    count = 0

    # Sort by length descending to avoid partial replacements
    for string, key in sorted(string_to_key.items(), key=lambda x: -len(x[0])):
        localization_call = f"AppLocalizations.of(context)!.{key}"

        # Replace inside Text("...") and Text('...')
        for quote in ('"', "'"):
            old = f"{quote}{string}{quote}"
            if old in content:
                content = content.replace(old, localization_call)
                count += 1

    if content != original:
        # Add import if not already present
        import_line = "import 'package:flutter_gen/gen_l10n/app_localizations.dart';\n"
        if "app_localizations.dart" not in content:
            # insert after last import
            last_import = list(re.finditer(r"^import .+;\n", content, re.MULTILINE))
            if last_import:
                pos = last_import[-1].end()
                content = content[:pos] + import_line + content[pos:]
            else:
                content = import_line + content

        Path(filepath).write_text(content, encoding="utf-8")

    return content, count


def refactor_all_dart_files(strings: list[dict], project_path: str):
    # Build file → {string: key} map
    file_map: dict[str, dict] = {}
    for item in strings:
        if "arb_key" not in item:
            continue
        file_map.setdefault(item["file"], {})[item["string"]] = item["arb_key"]

    print(f"\n🔧  Refactoring {len(file_map)} Dart files...")
    total_replacements = 0

    for filepath, string_to_key in file_map.items():
        _, count = refactor_dart_file(filepath, string_to_key)
        if count:
            rel = Path(filepath).relative_to(project_path)
            print(f"   {rel}  ({count} strings replaced)")
            total_replacements += count

    print(f"\n✅  Total replacements: {total_replacements}")


# ── L10N CONFIG ───────────────────────────────────────────────────────────────

L10N_YAML = """\
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
"""

PUBSPEC_SNIPPET = """\
# ── Add this to your pubspec.yaml under flutter: ──────────────────────────────
flutter:
  generate: true          # enables code generation for l10n
  # ... your existing flutter config ...
"""

MAIN_DART_SNIPPET = """\
// ── Update your MaterialApp / CupertinoApp in main.dart ──────────────────────
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),
  ],
  // ... rest of your config
);
"""


def write_l10n_yaml(project_path: str):
    path = Path(project_path) / "l10n.yaml"
    if not path.exists():
        path.write_text(L10N_YAML, encoding="utf-8")
        print(f"✅  Created: {path}")
    else:
        print(f"ℹ️   l10n.yaml already exists — skipped")


def print_manual_steps():
    print("\n" + "─" * 60)
    print("📋  MANUAL STEPS REMAINING")
    print("─" * 60)
    print("\n1️⃣   pubspec.yaml — enable code generation:")
    print(PUBSPEC_SNIPPET)
    print("2️⃣   Run code generation:")
    print("     flutter gen-l10n")
    print("\n3️⃣   Update MaterialApp in main.dart:")
    print(MAIN_DART_SNIPPET)
    print("4️⃣   For RTL support, add to MaterialApp:")
    print("     locale: Locale('ar'),   // or use device locale")
    print("\n─" * 60)


# ── MAIN ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Flutter Arabic Translation Agent")
    parser.add_argument("--project", required=True, help="Path to Flutter project root")
    parser.add_argument("--dry-run", action="store_true", help="Preview without API calls or file writes")
    parser.add_argument("--arb-only", action="store_true", help="Generate ARB files only, skip Dart refactoring")
    args = parser.parse_args()

    project_path = os.path.abspath(args.project)

    if not os.path.isdir(project_path):
        print(f"❌  Project path not found: {project_path}")
        return

    print("=" * 60)
    print("  Flutter Arabic Translation Agent")
    print("=" * 60)

    # 1. Scan
    strings = scan_project(project_path)
    if not strings:
        print("❌  No translatable strings found.")
        return

    # 2. Translate
    translations = translate_all_strings(strings, dry_run=args.dry_run)

    # 3. Build ARB
    en_arb = build_arb_data(strings, translations, "en")
    ar_arb = build_arb_data(strings, translations, "ar")

    print(f"\n📦  ARB entries: {len(en_arb) - 1} English / {len(ar_arb) - 1} Arabic")

    if args.dry_run:
        print("\n🔍  Sample translations:")
        for item in strings[:5]:
            ar = translations.get(item["string"], "—")
            print(f'   "{item["string"]}"  →  "{ar}"')
        print("\nDry run complete. No files written.")
        return

    # 4. Write ARB files
    write_arb_files(project_path, en_arb, ar_arb)

    # 5. Write l10n.yaml
    write_l10n_yaml(project_path)

    # 6. Refactor Dart files
    if not args.arb_only:
        refactor_all_dart_files(strings, project_path)

    # 7. Print remaining manual steps
    print_manual_steps()

    print("\n🎉  Done! Run 'flutter gen-l10n' to generate the localization classes.\n")


if __name__ == "__main__":
    main()
