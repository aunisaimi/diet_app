import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/step_detail_row.dart';
import 'package:diet_app/model/exercises.dart';
import 'package:diet_app/model/steps.dart';
import 'package:diet_app/screen/countdown/countdown_screen.dart';
import 'package:diet_app/screen/countdown/stopwatch_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/auth_service.dart';

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj;
  //final Map eObj; // exercise obj contains details about exercise
  final String image;
  final String? duration;
  //final String? type;
  String value;
  final String document;
  final String difficulty;
  final String exerciseName;
  final String? description;
  final String steps;

  String? type;

   ExercisesStepDetails({
    Key? key,
    required this.eObj,
    required this.image,
    this.duration,
    required this.value,
    required this.document,
    required this.difficulty,
    required this.exerciseName,
    this.description,
    required this.steps,
    this.type
  }) : super(key: key);

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();
  String? exerciseType;
  String? exerciseValue;

  List<StepModel> stepArr = []; // list to store steps of exercises

  // Future<void> fetchSteps() async {
  //   try {
  //     String exerciseName = widget.document;
  //     print('Fetching steps for exercise: $exerciseName');
  //
  //     DocumentSnapshot<Map<String, dynamic>> querySnapshot = await _firestore
  //         .collection('exercises')
  //         .doc('beginner') // Assuming 'beginner' is the level, replace it if needed
  //         .collection(exerciseName) // Accessing 'jumping_jack', 'plank', or 'push_up'
  //         .doc(exerciseName) // Accessing the specific exercise document
  //         .collection('steps') // Accessing the 'steps' subcollection
  //         .doc('steps') // Specific document within 'steps' collection
  //         .get();
  //
  //     if (querySnapshot.exists) {
  //       print('Steps found for exercise: $exerciseName');
  //       Map<String, dynamic> data = {};
  //
  //       /*for (var doc in querySnapshot) {
  //         data.addAll(doc.data());
  //       }*/
  //       data = querySnapshot.data() ?? {};
  //
  //       print("Data: $data");
  //
  //       List<String> orderedKeys = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth'];
  //
  //       // Sort the keys in the correct order
  //       List<String> sortedKeys = data.keys.toList();
  //       sortedKeys.sort((a, b) {
  //         return orderedKeys.indexOf(a).compareTo(orderedKeys.indexOf(b));
  //       });
  //
  //       // Create the steps list in the correct order
  //       List<StepModel> stepsList = sortedKeys.map((key) {
  //         String stepNumber = key;
  //         String stepDescription = data[key] as String;
  //
  //         // Create a map to match the expected structure for StepModel.fromMap
  //         Map<String, dynamic> stepData = {
  //           'steps': stepNumber,
  //           'description': stepDescription,
  //         };
  //
  //         return StepModel.fromMap(stepData);
  //       }).toList();
  //
  //       setState(() {
  //         stepArr = stepsList;
  //       });
  //     } else {
  //       print('No steps found for the exercise: $exerciseName');
  //     }
  //   } catch (e, printStack) {
  //     print('Error fetching steps: $e');
  //     print(printStack);
  //   }
  // }

  Future<void> fetchSteps() async {
    try {
      String exerciseName = widget.document;
      print('Fetching steps for exercise: $exerciseName');

      DocumentSnapshot<Map<String,dynamic>> exerciseDoc = await _firestore
          .collection('exercises')
          .doc('beginner')
          .collection(exerciseName)
          .doc(exerciseName)
          .get();

      if (exerciseDoc.exists){
        print("Exercise found: $exerciseName");
        Map<String,dynamic> data = exerciseDoc.data() ?? {};

        // Extracting exercise type and duration/freq
        String type = data['type'];
        String value = data['value'];

        setState(() {
          widget.type = type;
          widget.value = value;
        });

        // Fetching steps
        DocumentSnapshot<Map<String,dynamic>> stepsDoc = await exerciseDoc
            .reference
            .collection('steps')
            .doc('steps')
            .get();

        if (stepsDoc.exists){
          print('Steps found for exercise: $exerciseName');
          Map<String,dynamic> stepsData = stepsDoc.data() ?? {};

          List<String> orderedKeys = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth'];

          // Sort the keys in the correct order
          List<String> sortedKeys = stepsData.keys.toList();
          sortedKeys.sort((a, b) {
            return orderedKeys.indexOf(a).compareTo(orderedKeys.indexOf(b));
          });

          // Create the steps list in the correct order
          List<StepModel> stepsList = sortedKeys.map((key) {
            String stepNumber = key;
            String stepDescription = stepsData[key] as String;

            // Create a map to match the expected structure for StepModel.fromMap
            Map<String, dynamic> stepData = {
              'steps': stepNumber,
              'description': stepDescription,
            };

            return StepModel.fromMap(stepData);
          }).toList();

          setState(() {
            stepArr = stepsList;
          });
        } else {
          print('No steps found for the exercise: $exerciseName');
        }
      } else {
        print('No exercise found: $exerciseName');
      }
    }  catch (e, printStack) {
      print('Error fetching steps: $e');
      print(printStack);
    }
  }



  @override
  void initState() {
    super.initState();
    print("Document to be opened: ${widget.document}");
    //print("Steps: ");
    //fetchExerciseName();
    fetchSteps();
  }



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
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
            child: const Icon(Icons.close),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                      color: TColor.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                widget.eObj["name"].toString().replaceAll('_', ' '),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.difficulty,
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Descriptions",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.eObj['description'],
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How To Do It",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "${stepArr.length} sets",
                      style: TextStyle(
                        color: TColor.gray,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stepArr.length,
                itemBuilder: (context, index) {
                  var step = stepArr[index];
                  return ListTile(
                    title: Text(step.stepNumber),
                    subtitle: Text(step.description),
                  );
                  // return StepDetailRow(
                  //   sObj: sObj,
                  //   isLast: stepArr.last == sObj,
                  // );
                },
              ),
              Text(
                "Custom Repetitions",
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker.builder(
                  itemExtent: 40,
                  selectionOverlay: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: TColor.gray.withOpacity(0.2),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: TColor.gray.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {},
                  childCount: 60,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department),
                        Text(
                          "${(index + 1) * 15} calories burn",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          " ${index + 1} ",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " times",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              RoundButton(
                title: "Start",
                elevation: 1,
                onPressed: () {
                 if (widget.type == 'duration' && widget.value != null) {
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => CountdownScreen(
                               duration: widget.value!)
                       )
                   );
                 } else if (widget.type == 'frequency'){
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) =>
                               StopwatchScreen(
                                   exerciseName: widget.exerciseName)
                       )
                   );
                 }
                 else {
                   print('Invalid exercise type');
                 }
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}