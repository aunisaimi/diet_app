import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common.dart';
import 'package:diet_app/common/common_widget/icon_title_next_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddScheduleView extends StatefulWidget {
  final DateTime date;
  const AddScheduleView({super.key, required this.date});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.close),
          ),
        ),
        title: Text(
          "Add Schedule",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: (){},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.more_horiz_rounded),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.date_range),

                const SizedBox(width: 8),

                Text(
                  dateToString(widget.date, formatStr: "E, dd/MM/yyyy"),
                  style: TextStyle(
                    color: TColor.gray,
                    fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Time",
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            ),

            SizedBox(
              height: media.width * 0.35,
              child: CupertinoDatePicker(
                onDateTimeChanged: (newDate){},
                initialDateTime: DateTime.now(),
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Details Workout",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            IconTitleNextRow(
                icon: "assets/img/choose_workout.png",
                title: "Choose Workout",
                time: "Upperbody",
                onPressed: (){},
                color: TColor.lightGray),

            const SizedBox(height: 10),

            IconTitleNextRow(
                icon: "assets/img/difficulty.png",
                title: "Difficulty",
                time: "Beginner",
                onPressed: (){},
                color: TColor.lightGray),

            const SizedBox(height: 10),

            IconTitleNextRow(
                icon: "assets/img/p_workout.png",
                title: "Custom Repetitions",
                time: "",
                onPressed: (){},
                color: TColor.lightGray),

            const SizedBox(height: 10),

            const Spacer(),

            RoundButton(
              title: "Save",
              onPressed: (){}),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
