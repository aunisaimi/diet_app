import 'package:diet_app/common/common_widget/upcoming_workout_row.dart';
import 'package:diet_app/common/common_widget/what_train_row.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/screen/home/activity_tracker_view.dart';
import 'package:diet_app/screen/workout_tracker/workout_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutTrackerView extends StatelessWidget {
  WorkoutTrackerView({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> latestArr = [
    {
      "image": "assets/img/1.png",
      "title": "Full Body Workout",
      "time": "Today, 03:00pm"
    },
    {
      "image": "assets/img/leg_extension.jpg",
      "title": "Leg Workout",
      "time": "Tomorrow, 10:00am"
    }
  ];

  final List<Map<String, dynamic>> whatArr = [
    {
      "image": "assets/img/1.png",
      "title": "Full Body Workout",
      "exercises": "2 set",
      "duration": " 12 mins"
    },
    {
      "image": "assets/img/2.png",
      "title": "Abs Workout",
      "exercises": "5 set",
      "duration": "25 mins"
    },
    {
      "image": "assets/img/3.png",
      "title": "Legs Workout",
      "exercises": "4 set",
      "duration": "3 mins"
    },
    {
      "image": "assets/img/push_up.jpg",
      "title": "Arm Workout",
      "exercises": "2 set",
      "duration": "10 seconds"
    }
  ];

  Future<void> _onSeeMorePressed(BuildContext context) async {
    // Simulate data fetching delay
    await Future.delayed(Duration(seconds: 1));
    // Navigate to the desired screen after data fetching
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityTrackerView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: TColor.primaryG,
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScroller) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: TColor.lightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              title: Text(
                "Activity Tracker",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.more_horiz_rounded),
                  ),
                )
              ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                        color: TColor.gray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                        color: TColor.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Daily Workout Schedule",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Check",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const ActivityTrackerView())),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Upcoming Workout",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () async {
                          await _onSeeMorePressed(context);
                        },
                        child: Text(
                            "See More",
                            style: TextStyle(
                                color: TColor.gray,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: latestArr.length,
                    itemBuilder: (context, index) =>
                        UpcomingWorkoutRow(wObj: latestArr[index]),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "What Do You Want to Train?",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: whatArr.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutDetailView(dObj: whatArr[index]))),


                        child: WhatTrainRow(wObj: whatArr[index]),
                      );
                    },
                  ),
                  SizedBox(height: media.width * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
