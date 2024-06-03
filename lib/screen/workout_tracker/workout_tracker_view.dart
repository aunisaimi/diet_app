import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/common_widget/upcoming_workout_row.dart';
import 'package:diet_app/common/common_widget/what_train_row.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/screen/home/activity_tracker_view.dart';
import 'package:diet_app/screen/workout_tracker/workout_detail_view.dart';
import 'package:diet_app/screen/workout_tracker/workout_schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../database/auth_service.dart';

class WorkoutTrackerView extends StatefulWidget {
  final String document;
  final String title;
  WorkoutTrackerView({
    Key? key,
    required this.document,
    required this.title}) : super(key: key);

  @override
  _WorkoutTrackerViewState createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();

  final List<Map<String, dynamic>> latestArr = [
    {
      "image": "assets/img/1.png",
      "title": "full body ",
      "time": "Today, 03:00pm"
    },
    {
      "image": "assets/img/leg_extension.jpg",
      "title": "legs",
      "time": "Tomorrow, 10:00am"
    }
  ];


  List<Map<String,dynamic>> whatArr =[];

  @override
  void initState() {
    super.initState();
    fetchExercise();
    fetchTitles();
  }


  Future<void> fetchExercise() async {
    try {
      List<String> exerciseNames = ['jumping_jack','bear_crawl','donkey_kick','explosive_jump','skipping','squat','plank', 'pushup', 'situp', 'imaginary_chair', 'wall_pushup', 'bicycle_kick'];
      List<String> exerciseDifficulty = ['advanced','beginner','intermediate'];
      List<Map<String,dynamic>> exercisesList =[];

      //for(String difficulty in exerciseDifficulty)
      for (String exerciseName in exerciseNames){
        print('Fetching exercises for path: exercises/$exerciseName');
        // QuerySnapshot<Map<String,dynamic>> querySnapshot = await FirebaseFirestore.instance
        //     .collection('exercises')
        //     .doc('beginner')
        //     .collection(exerciseName)
        //     .get();

        DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection("exercises")
            .doc("beginner") // change this if needed
            .collection(exerciseName)
            .doc(exerciseName)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();
          if (data != null) {
            data['name'] = exerciseName; // Add the exercise name to the data
            exercisesList.add(data); // Add the exercise data to the list
          }
        }
      }
      setState(() {
        //whatArr = exercisesList;
        whatArr.addAll(exercisesList);
      });
    } catch (e){
      print('Error fetching exercises: $e');
    }
  }

  Future<void> fetchTitles() async {
    try {
      // define the list of categories and the exercises within them
      List<String> titles = ['full_body','arms','legs','abs'];

      List<Map<String,dynamic>> titleList = [];

      // Loop through each category and fetch the exercises
      for (String title in titles){
        QuerySnapshot<Map<String,dynamic>> snapshot = await _firestore
            .collection('exercises')
            .doc('beginner')
            .collection(title)
            .get();

        for (var doc in snapshot.docs) {
          Map<String, dynamic>? data = doc.data();
          if (data != null) {
            //data['category'] = title; // Add the category title to the data
            data['title'] = title;
            titleList.add(data); // Add the title data to the list
          }
        }
      }

      setState(() {
        //whatArr = exercisesList;
        whatArr = titleList;
      });

    } catch (e,printStack){
      print('Error fetching exercises: $e');
      print(printStack);
    }
  }

  Future<void> _onViewMorePressed(BuildContext context, String title) async {
    List<Map<String,dynamic>> filteredExercises = whatArr
        .where((exercise) => exercise['title'] == title)
        .toList();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkoutDetailView(
                  exercises: filteredExercises,
                  category: '',
                  // document: 'jumping_jack',
                  // category: 'beginner',
                )
        )
    );
  }


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
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)),
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
                                    const WorkoutScheduleView())),
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
                    // get the unique titles from whatArr list
                    itemCount: whatArr.map((exercise) => exercise['title'])
                        .toSet()
                        .length,
                    itemBuilder: (context, index) {
                      // Get the unique titles from the whatArr list
                      final uniqueTitles = whatArr
                          .map((exercise) => exercise['title'])
                          .toSet()
                          .toList();

                      // Find the first exercise that matches the current unique title
                      final exercise = whatArr
                          .firstWhere((exercise) =>
                      exercise['title'] == uniqueTitles[index]);

                      return WhatTrainRow(
                        wObj: exercise,
                        onViewMorePressed: () {
                          _onViewMorePressed(
                              context,
                              exercise['title']);
                        },
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