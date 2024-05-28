import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/exercise_set_section.dart';
import 'package:diet_app/screen/workout_tracker/add_exercise.dart';
import 'package:diet_app/screen/workout_tracker/exercise_step_detail.dart';
import 'package:flutter/material.dart';

import '../../common/common_widget/icon_title_next_row.dart';

class WorkoutDetailView extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;
  // final String document;
   final String category;

  const WorkoutDetailView({
    Key? key,
    required this.exercises,
    // required this.document,
     required this.category,
  }) : super(key: key);

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  // dummy data for illustration
  final Map<String,dynamic> sObj = {
    'title': 'Jumping Jack',
  };
  // final String image = 'assets/images/jumping_jack.png';
  // final String duration = '5 minutes';
  // final String exercise = 'Jumping Jack';
  // final String difficulty = 'Easy';
  // final String document = 'jumping_jack_document_id';

  Map<String, List<Map<String, dynamic>>> _groupedExercises = {};

  @override
  void initState() {
    super.initState();
    print("Exercise to be shown: ${widget.exercises}");
    setState(() {
      _difficulty = "Beginner";
    });
    _fetchAndGroupExercisesByTitle();
    _groupExercisesByTitle();
    //fetchTitle();
  }

  Future<void> _fetchAndGroupExercisesByTitle() async {
    try {
      QuerySnapshot<Map<String,dynamic>> querySnapshot = await _firestore
          .collection('exercises')
          .doc(widget.category)
          .collection('jumping_jack')
          .get();

      Map<String,List<Map<String,dynamic>>> groupedExercises = {};

      for(var doc in querySnapshot.docs){
        var exercise = doc.data();
        exercise['id'] = doc.id; // add document id to the exercise data
        String title = exercise['title'];
        if(groupedExercises.containsKey(title)){
          groupedExercises[title]!.add(exercise);
        } else {
          groupedExercises[title] = [exercise];
        }
      }
      setState(() {
        _groupedExercises = groupedExercises;
      });
    } catch (e,printStack){
      print("Error fetching exercises: $e");
      print(printStack);
    }
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



  // Future<void> fetchTitle() async {
  //   try {
  //    // List<String> exerciseCategory = ['full body','arms','legs','abs']; //widget.document;
  //     String exerciseCategory = widget.category; // e.g: beginner
  //     String exerciseName = widget.document; // e.g: jumping_jack
  //
  //     print("Fetching titles for category: $exerciseCategory , "
  //         "and exercise Named : $exerciseName");
  //
  //     DocumentSnapshot<Map<String,dynamic>> querySnapshot = await _firestore
  //             .collection('exercises')
  //             .doc(exerciseCategory)
  //             .collection(exerciseName)
  //             .doc(exerciseName)
  //             .get();
  //
  //     if (querySnapshot.exists){
  //       print('Title found for exercise name: $exerciseName');
  //       Map<String,dynamic> data = querySnapshot.data() ?? {};
  //
  //       String title = data['title'] ?? "No title found";
  //       print("Title: $title");
  //
  //       //data = querySnapshot.data() ?? {};
  //       //print("Data: $data");
  //     } else {
  //       print('No document found for exercise name: $exerciseName');
  //     }
  //
  //   } catch (e, stackTrace) {
  //     print("Error fetching title : $e");
  //     print(stackTrace);
  //   }
  // }
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)
                              => const AddExercise()
                          )
                      );
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
                                  widget.exercises.first["title"].toString(),
                                  //widget.category,
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  //" ${widget.exercises.first["duration"].toString()} ",
                                  //"${_difficulty}",
                                  "Add duration here later",
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
                              fontSize: 18,
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
                              // Text(
                              //   title,
                              //   style: TextStyle(
                              //     color: TColor.gray,
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: exercises.length,
                                itemBuilder: (context, exerciseIndex) {
                                  // Debug print to check the length of exercises
                                  print('Length of exercises: ${exercises.length}');

                                  // Check if exerciseIndex is valid
                                  if (exerciseIndex >= 0 && exerciseIndex < exercises.length){
                                    // to access sObj
                                    Map<String,dynamic> sObj =  Map<String, dynamic>
                                        .from(exercises[exerciseIndex]);

                                    // Debug print to check the data
                                    print('Exercise object: $sObj');
                                    // Debug print to check the structure of each item in exercises
                                    print('Exercise object at index $exerciseIndex: $sObj');
                                    //print('Exercise name: ${sObj.containsKey('exercise') ? sObj['exercise'] : 'Key not found'}');

                                    // Assign default values if any of the fields are null
                                    String image = sObj["image"] ?? '';
                                   // String duration = sObj["duration"] ?? '';
                                    String exercise = sObj["title"] ?? '';
                                    String document = sObj["name"] ?? '';
                                    //String steps = sObj["steps"] ?? '';

                                    print('Image: ${sObj.containsKey('image') ? sObj['image'] : 'Key not found'}');
                                    //print('Duration: ${sObj.containsKey('duration') ? sObj['duration'] : 'Key not found'}');
                                    print('Exercise: ${sObj.containsKey('title') ? sObj['title'] : 'Key not found'}');
                                    print('Document: ${sObj.containsKey('name') ? sObj['name'] : 'Key not found'}');
                                    //print('Steps: ${sObj.containsValue('steps') ? sObj['steps'] : 'Key not found'}');

                                    // Debug print to check the exercise name
                                    print('Exercise name: $document');

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: ExercisesSetSection(
                                            sObj: sObj,
                                            onPressed: (sObj) {
                                              if (exercise.isNotEmpty) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ExercisesStepDetails(
                                                      eObj: sObj,
                                                      image: image,
                                                      //duration: duration,
                                                      difficulty: _difficulty,
                                                      document: document,
                                                      exerciseName: exercise,
                                                      steps: '',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print("Exercise name is empty or exercise object: $sObj");
                                              }
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ExercisesStepDetails(
                                                  eObj: sObj,
                                                  image: image,
                                                  //duration: duration,
                                                  exerciseName: exercise,
                                                  difficulty: _difficulty,
                                                  document: document,
                                                  steps: '',
                                                ),
                                              ),
                                            );
                                            // if(exercise.isNotEmpty){
                                            //
                                            // }
                                            // else {
                                            //   print("Exercise name is empty for exercise object: $sObj");
                                            // }
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    print('Invalid exercise index: $exerciseIndex');
                                    return const SizedBox();
                                  }
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
