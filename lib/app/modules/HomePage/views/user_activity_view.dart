import 'package:flutter/material.dart';
import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/widgets/activity_card.dart';
import 'package:intl/intl.dart';

class UserActivityView extends StatelessWidget {
  final UserActivityModel? userActivityModel;
  const UserActivityView({required this.userActivityModel, super.key});

  @override
  Widget build(BuildContext context) {
    final activity = userActivityModel;

    if (activity == null) {
      return const SizedBox();
    }

    // ✅ Get all activities sorted chronologically
    final sortedActivities = _getAllActivitiesSorted(activity);

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

  // ✅ MAIN FUNCTION: Combine all activities and sort by time
  List<Map<String, dynamic>> _getAllActivitiesSorted(
      UserActivityModel activity) {
    List<Map<String, dynamic>> allActivities = [];
    final date = activity.createdAt ?? '';

    // Add all Check-ins
    activity.checkIn?.forEach((checkIn) {
      if (checkIn.inTime != null) {
        allActivities.add({
          'icon': Icons.input_rounded,
          'title': 'Check In',
          'time': checkIn.inTime!, // "09:00:00"
          'dateTime': _parseDateTime(date, checkIn.inTime!),
          'description': checkIn.msg ?? '-',
        });
      }
    });

    // Add all Break-ins
    activity.breakInTime?.forEach((breakIn) {
      allActivities.add({
        'icon': Icons.free_breakfast_outlined,
        'title': 'Break In',
        'time': breakIn, // "10:30:00"
        'dateTime': _parseDateTime(date, breakIn),
        'description': '',
      });
    });

    // Add all Break-outs
    activity.breakOutTime?.forEach((breakOut) {
      allActivities.add({
        'icon': Icons.free_breakfast_outlined,
        'title': 'Break Out',
        'time': breakOut, // "11:00:00"
        'dateTime': _parseDateTime(date, breakOut),
        'description': '',
      });
    });

    // Add all Check-outs
    activity.outTime?.forEach((out) {
      if (out.outTime != null) {
        allActivities.add({
          'icon': Icons.output_rounded,
          'title': 'Check Out',
          'time': out.outTime!, // "17:00:00"
          'dateTime': _parseDateTime(date, out.outTime!),
          'description': out.msg ?? '-',
        });
      }
    });

    // ✅ SORT ALL BY TIME CHRONOLOGICALLY
    allActivities.sort((a, b) {
      final timeA = DateFormat("HH:mm:ss").parse(a['time']);
      final timeB = DateFormat("HH:mm:ss").parse(b['time']);
      return timeA.compareTo(timeB);
    });

    return allActivities;
  }

  // ✅ Helper to parse date + time string
  DateTime _parseDateTime(String date, String time) {
    try {
      // date = "2025-10-11" or "2025-10-11 15:30:00"
      // time = "09:00:00"
      final dateOnly = date.split(' ').first; // Extract just "2025-10-11"
      final combined = "$dateOnly $time"; // "2025-10-11 09:00:00"
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(combined);
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now();
    }
  }
}
