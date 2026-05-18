import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Holds the server's UTC offset fetched at startup.
/// Default fallback is UTC+3 (Asia/Riyadh) until the server responds.
class ServerTime {
  static Duration _offset = const Duration(hours: 3);

  static void setOffset(int timezoneOffsetSeconds) {
    _offset = Duration(seconds: timezoneOffsetSeconds);
  }

  /// Current time expressed in the server's local timezone.
  static DateTime get now => DateTime.now().toUtc().add(_offset);

  /// The server's UTC offset (e.g. Duration(hours: 3) for UTC+3).
  static Duration get offset => _offset;
}

extension WidthHeight on num {
  Widget get width => SizedBox(width: toDouble());
  Widget get height => SizedBox(height: toDouble());
}

extension AppDateTime on DateTime {
  String get toMMDDYY {
    return DateFormat("MMM d, y").format(this);
  }

  String get toMMDDYYYY {
    return DateFormat("MMM d, yyyy").format(this);
  }

  String get toDDMMYYYY {
    return DateFormat("dd-MM-yyyy").format(this);
  }

  String get toWEEKDAY {
    return DateFormat.EEEE().format(this);
  }

  String get toYYYMMDD {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String get tohhMMh {
    return DateFormat.jm().format(this);
  }

  String get toMMOnly {
    return DateFormat.E().format(this);
  }

  String get toHOUR24MINUTESECOND {
    return DateFormat.Hms().format(this);
  }
}
