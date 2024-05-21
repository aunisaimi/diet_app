import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/exercise_set_section.dart';
import 'package:diet_app/screen/workout_tracker/exercise_step_detail.dart';
import 'package:flutter/material.dart';

import '../../common/common_widget/icon_title_next_row.dart';

class WorkoutDetailView extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;

  const WorkoutDetailView({
    Key? key,
    required this.exercises,
  }) : super(key: key);

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  String _difficulty = "Beginner"; // Default difficulty level
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

  Map<String, List<String>> durations = {
    "Beginner": [
      "05:00", "12x", "15x", "20x", "25x", "02:00", "00:25", "12x", "00:30", "15x", "02:00"
    ],
    "Intermediate": [
      "06:00", "15x", "18x", "25x", "30x", "02:30", "00:30", "15x", "00:45", "20x", "02:30"
    ],
    "Advanced": [
      "07:00", "18x", "20x", "30x", "35x", "03:00", "00:35", "18x", "01:00", "25x", "03:00"
    ],
  };

  List exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {
          "image": "assets/img/run_treadmill.jpg",
          "title": "Warm Up",
          "value": "05:00",
          "document": "warm_up"
        },
        {
          "image": "assets/img/jumping_jack.png",
          "title": "Jumping Jack",
          "value": "12",
          "document": "jumping_jack"
        },
        {
          "image": "assets/img/Workout1.png",
          "title": "Skipping",
          "value": "15x",
          "document": "skipping"
        },
        {
          "image": "assets/img/squat.jpg",
          "title": "Squats",
          "value": "20x",
          "document": "squat"
        },
        {
          "image": "assets/img/push_up.jpg",
          "title": "Push Up",
          "value": "25x",
          "document": "push_up"
        },
        {
          "image": "assets/img/rest.jpg",
          "title": "Rest and Drink",
          "value": "02:00",
          "document": "rest_drink"
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

  Map<String, List<Map<String, dynamic>>> _groupedExercises = {};

  @override
  void initState() {
    super.initState();
    print(widget.exercises);
    setState(() {
      _difficulty = "Beginner";
    });
    _groupExercisesByTitle();
  }

  void _groupExercisesByTitle() {
    for (var exercise in widget.exercises) {
      String title = exercise['title'];
      print("Title fetched: $title");
      if (_groupedExercises.containsKey(title)) {
        _groupedExercises[title]!.add(exercise);
      } else {
        _groupedExercises[title] = [exercise];
      }
    }
  }

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
                    child: const Icon(Icons.arrow_back_ios_new_rounded),
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
                      child: const Icon(Icons.more_horiz_outlined),
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
              borderRadius: const BorderRadius.only(
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
                                  widget.exercises.first["area"].toString(),
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  " ${widget.exercises.first["duration"].toString()} ",
                                  style: TextStyle(
                                    color: TColor.gray,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.05),
                      IconTitleNextRow(
                        icon: "assets/img/difficulty.png",
                        title: "Difficulty",
                        time: _difficulty, // Display selected difficulty
                        color: TColor.secondaryColor2.withOpacity(0.3),
                        onPressed: () {
                          // Show dialog to choose difficulty
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Select Difficulty"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text("Beginner"),
                                      onTap: () {
                                        setState(() {
                                          _difficulty = "Beginner";
                                          print("Selection: $_difficulty");
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: const Text("Intermediate"),
                                      onTap: () {
                                        setState(() {
                                          _difficulty = "Intermediate";
                                          print("Selection: $_difficulty");
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    ListTile(
                                      title: const Text("Advanced"),
                                      onTap: () {
                                        setState(() {
                                          _difficulty = "Advanced";
                                          print("Selection: $_difficulty");
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: media.width * 0.05),
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
                              "${_groupedExercises.length} Sets",
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
                        itemCount: _groupedExercises.keys.length,
                        itemBuilder: (context, index) {
                          String title = _groupedExercises.keys.elementAt(index);
                          List<Map<String, dynamic>> exercises = _groupedExercises[title]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: exercises.length,
                                itemBuilder: (context, exerciseIndex) {
                                  var sObj = exercises[exerciseIndex];

                                  // Assign default values if any of the fields are null
                                  String image = sObj["image"] ?? '';
                                  String duration = sObj["duration"] ?? '';
                                  String exercise = sObj["exercise"] ?? '';
                                  String document = sObj["document"] ?? '';

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ExercisesSetSection(
                                          sObj: sObj,
                                          onPressed: (sObj) {
                                            print("Document: $document");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ExercisesStepDetails(
                                                  eObj: sObj,
                                                  image: image,
                                                  duration: duration,
                                                  exercise: exercise,
                                                  difficulty: _difficulty,
                                                  document: document,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ExercisesStepDetails(
                                                eObj: sObj,
                                                image: image,
                                                duration: duration,
                                                exercise: exercise,
                                                difficulty: _difficulty,
                                                document: document,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
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
