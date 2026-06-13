import 'package:flutter/material.dart';
import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/widgets/activity_card.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

class UserActivityView extends StatelessWidget {
  final UserActivityModel? userActivityModel;
  const UserActivityView({required this.userActivityModel, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activity = userActivityModel;

    if (activity == null) {
      return const SizedBox();
    }

    final sortedActivities = _getAllActivitiesSorted(activity, l10n);

    if (sortedActivities.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedActivities.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ActivityCard(
            iconData: item['icon'] as IconData,
            title: item['title'] as String,
            dateTime: item['dateTime'] as DateTime,
            description: item['description'] as String,
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getAllActivitiesSorted(
    UserActivityModel activity,
    AppLocalizations l10n,
  ) {
    List<Map<String, dynamic>> allActivities = [];
    final date = activity.createdAt ?? '';

    // Check-ins
    activity.checkIn?.forEach((checkIn) {
      if (checkIn.inTime != null) {
        allActivities.add({
          'icon': Icons.input_rounded,
          'title': l10n.checkIn,
          'time': checkIn.inTime!,
          'dateTime': _parseDateTime(date, checkIn.inTime!),
          'description': _translateMsg(checkIn.msg, l10n), // ✅ translated
        });
      }
    });

    // Break-ins
    activity.breakInTime?.forEach((breakIn) {
      allActivities.add({
        'icon': Icons.free_breakfast_outlined,
        'title': l10n.breakIn,
        'time': breakIn,
        'dateTime': _parseDateTime(date, breakIn),
        'description': '',
      });
    });

    // Break-outs
    activity.breakOutTime?.forEach((breakOut) {
      allActivities.add({
        'icon': Icons.free_breakfast_outlined,
        'title': l10n.breakOut,
        'time': breakOut,
        'dateTime': _parseDateTime(date, breakOut),
        'description': '',
      });
    });

    // Check-outs
    activity.outTime?.forEach((out) {
      if (out.outTime != null) {
        allActivities.add({
          'icon': Icons.output_rounded,
          'title': l10n.checkOut,
          'time': out.outTime!,
          'dateTime': _parseDateTime(date, out.outTime!),
          'description': _translateMsg(out.msg, l10n), // ✅ translated
        });
      }
    });

    // Sort by time
    allActivities.sort((a, b) {
      final timeA = DateFormat("HH:mm:ss").parse(a['time']);
      final timeB = DateFormat("HH:mm:ss").parse(b['time']);
      return timeA.compareTo(timeB);
    });

    return allActivities;
  }

  DateTime _parseDateTime(String date, String time) {
    try {
      final dateOnly = date.split(' ').first;
      final combined = "$dateOnly $time";
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(combined);
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now();
    }
  }

  /// Translates backend status messages to localized text.
  /// Falls back to original message if unknown.
  String _translateMsg(String? msg, AppLocalizations l10n) {
    if (msg == null || msg.trim().isEmpty) return '-';

    // Normalize: lowercase + trim + remove extra spaces
    final normalized = msg.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

    switch (normalized) {
      case 'late':
        return l10n.msgLate;
      case 'on time':
      case 'ontime':
        return l10n.msgOnTime;
      case 'over time':
      case 'overtime':
        return l10n.msgOverTime;
      case 'early':
        return l10n.msgEarly;
      case 'early checkout':
      case 'earlycheckout':
        return l10n.msgEarlyCheckout;
      default:
        return msg; // Unknown message — show as-is
    }
  }
}
