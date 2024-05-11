import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/exercise_set_section.dart';
import 'package:diet_app/screen/workout_tracker/exercise_step_detail.dart';
import 'package:flutter/material.dart';

import '../../common/common_widget/icon_title_next_row.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({Key? key, required this.dObj}) : super(key: key);

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  List youArr = [
    {
      "image": "assets/img/fitness.png",
      "title": "Barbell",
    },
    {
      "image": "assets/img/skipping_rope.png",
      "title": "Skipping Rope",
    },
    {
      "image": "assets/img/bottle.png",
      "title": "1 Litre Bottle",
    },
    {
      "image": "assets/img/bubur.jpeg",
      "title": "Bubur",
    },
  ];

  List exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {
          "image": "assets/img/run_treadmill.jpg",
          "title": "Warm Up",
          "value": "05:00",
        },
        {
          "image": "assets/img/jumping_jack.png",
          "title": "Jumping Jack",
          "value": "12x",
        },
        {
          "image": "assets/img/Workout1.png",
          "title": "Skipping",
          "value": "15x",
        },
        {
          "image": "assets/img/squat.jpg",
          "title": "Squats",
          "value": "20x",
        },
        {
          "image": "assets/img/push_up.jpg",
          "title": "Push Up",
          "value": "25x",
        },
        {
          "image": "assets/img/rest.jpg",
          "title": "Rest and Drink",
          "value": "02:00",
        },
      ],
    },
    {
      "name": "Set 2",
      "set": [
        {
          "image": "assets/img/plank.png",
          "title": "Plank",
          "value": "00:25",
        },
        {
          "image": "assets/img/scissor_kick.png",
          "title": "Scissor Kick",
          "value": "12x",
        },
        {
          "image": "assets/img/imaginary_chair.jpg",
          "title": "Imaginary Chair",
          "value": "00:30",
        },
        {
          "image": "assets/img/explosive_jump_m.jpg",
          "title": "Explosive Jump",
          "value": "15x",
        },
        {
          "image": "assets/img/rest.jpg",
          "title": "Rest and Drink",
          "value": "02:00",
        },
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.primaryG),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
                actions: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.more_horiz_outlined),
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
            ];
          },
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: TColor.gray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["title"].toString(),
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].toString()} | ${widget.dObj["duration"].toString()} | 320 Calories Burn",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: "assets/img/difficulty.png",
                        title: "Difficulty",
                        time: "Beginner",
                        color: TColor.secondaryColor2.withOpacity(0.3),
                        onPressed: () {},
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You'll Need",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${youArr.length} Items",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.4,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: youArr.length,
                          itemBuilder: (context, index) {
                            var yObj = youArr[index];
                            return Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: media.width * 0.25,
                                    width: media.width * 0.25,
                                    decoration: BoxDecoration(
                                      color: TColor.lightGray,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      yObj["image"].toString(),
                                      width: media.width * 0.15,
                                      height: media.width * 0.15,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      yObj["title"].toString(),
                                      style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${exercisesArr.length} Sets",
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: exercisesArr.length,
                        itemBuilder: (context, index) {
                          var sObj = exercisesArr[index];
                          return ExercisesSetSection(
                            sObj: sObj,
                            onPressed: (obj) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExercisesStepDetails(
                                    eObj: obj,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: media.width * 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
