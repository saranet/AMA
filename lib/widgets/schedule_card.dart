import 'package:ama/app/modules/ScheduleReport/model/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/utils/theme/app_theme.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              schedule.slug ?? "No Title",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ID and Created Info
            Text("Schedule ID: ${schedule.id ?? "-"}"),
            Text("Created By: ${schedule.created_by ?? "-"}"),
            Text("Created At: ${schedule.created_at ?? "-"}"),

            const Divider(height: 20),

            // Users
            if (schedule.usersName != null && schedule.usersName!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Assigned Users:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...schedule.usersName!.map((u) => Text("- $u")),
                ],
              ),

            const SizedBox(height: 10),

            // Time Info
            Text("In Time: ${schedule.inTime ?? "-"}"),
            Text("Out Time: ${schedule.outTime ?? "-"}"),

            const SizedBox(height: 10),

            // Working Days
            if (schedule.workingDays != null &&
                schedule.workingDays!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Working Days:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: schedule.workingDays!
                        .map((day) => Chip(label: Text(day)))
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
