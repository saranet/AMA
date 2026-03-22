import 'package:flutter/material.dart';
import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/widgets/activity_card.dart';
import 'package:intl/intl.dart';

class user_schedule_view extends StatelessWidget {
  final UserActivityModel? userActivityModel;
  const user_schedule_view({required this.userActivityModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (userActivityModel == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        if (userActivityModel!.checkIn != null) ...{
          ActivityCard(
            iconData: Icons.input_rounded,
            title: "Check In",
            dateTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(
              "${userActivityModel!.createdAt!.split(" ").first} ${userActivityModel!.checkIn!.first.inTime!}",
            ),
            description: userActivityModel!.checkIn!.first.msg ?? '-',
          )
        },
        arrangeInOutList(userActivityModel?.breakInTime ?? [],
            userActivityModel?.breakOutTime ?? []),
        if (userActivityModel!.outTime != null) ...{
          16.height,
          ActivityCard(
            iconData: Icons.output_rounded,
            title: "Check Out",
            dateTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(
              "${userActivityModel!.createdAt!.split(" ").last} ${userActivityModel!.outTime!.last.outTime!}",
            ),
            description: userActivityModel!.outTime!.last.msg ?? '-',
          )
        },
      ],
    );
  }

  Widget arrangeInOutList(List<String> inTimes, List<String> outTimes) {
    var newList = mergeBreakInBreakOutTimes(inTimes, outTimes);
    print(newList);
    return Column(
      children: [
        for (int i = 0; i < newList.length; i++) ...[
          if (i.isEven) ...{
            16.height,
            ActivityCard(
              iconData: Icons.free_breakfast_outlined,
              title: "Break In",
              dateTime: DateFormat("HH:mm:ss yyyy-MM-dd")
                  .parse("${newList[i]} ${userActivityModel!.createdAt!}"),
              description: "",
            ),
          } else ...[
            16.height,
            ActivityCard(
              iconData: Icons.free_breakfast_outlined,
              title: "Break Out",
              dateTime: DateFormat("HH:mm:ss yyyy-MM-dd")
                  .parse("${newList[i]} ${userActivityModel!.createdAt!}"),
              description: "",
            ),
          ],
        ],
      ],
    );
  }
}
