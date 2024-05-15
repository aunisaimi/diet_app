import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/step_detail_row.dart';
import 'package:diet_app/model/steps.dart';
import 'package:diet_app/screen/countdown/countdown_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../database/auth_service.dart';

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj; // exercise obj contains details about exercise
  final String image;
  final String duration;

  const ExercisesStepDetails({
    Key? key,
    required this.eObj,
    required this.image,
    required this.duration,
  }) : super(key: key);

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();

  List<StepModel> stepArr = []; // list to store steps of exercises

  Future<void> fetchSteps() async {
    try {
      String exerciseName = widget.eObj['title']; // Assuming 'title' is the field containing exercise names
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore
          .collection('steps')
          .doc('jumping_jack') // Assuming 'jumping_jack' is the document ID
          .get();

      if (docSnapshot.exists) {
        print('Document exists: ${docSnapshot.data()}');
        // Ensure explicit type for data retrieval
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        if (data != null) {
          List<StepModel> stepsList = data.entries.map((entry) {
            int stepNumber = int.tryParse(entry.key) ?? 0;
            return StepModel.fromMap(
              stepNumber.toString(),
              entry.value,
            );
          }).toList();

          setState(() {
            stepArr = stepsList;
          });
        } else {
          print('Document exists but data is not a Map<String, dynamic>');
          // Handle the case where data is not as expected
        }
      } else {
        print('Document does not exist for exercise: jumping_jack');
        // Handle the case where the document does not exist
      }
    } catch (e) {
      print('Error fetching steps: $e');
      // Handle any errors that occur during fetching
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSteps();
  }

  // @override
  // Widget build(BuildContext context) {
  //   var media = MediaQuery.of(context).size; // get the size of the media
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: TColor.white,
  //       centerTitle: true,
  //       elevation: 0,
  //       leading: InkWell(
  //         onTap: () {
  //           Navigator.pop(context);
  //         },
  //         child: Container(
  //           margin: const EdgeInsets.all(8),
  //           height: 40,
  //           width: 40,
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: TColor.lightGray,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: const Icon(Icons.close),
  //         ),
  //       ),
  //       actions: [
  //         InkWell(
  //           onTap: () {},
  //           child: Container(
  //             margin: const EdgeInsets.all(8),
  //             height: 40,
  //             width: 40,
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               color: TColor.lightGray,
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: const Icon(Icons.more_horiz_rounded),
  //           ),
  //         ),
  //       ],
  //     ),
  //     backgroundColor: Colors.white,
  //     body: SingleChildScrollView(
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Stack(
  //               alignment: Alignment.center,
  //               children: [
  //                 Container(
  //                   width: media.width,
  //                   height: media.width * 0.43,
  //                   decoration: BoxDecoration(
  //                     color: TColor.black.withOpacity(0.2),
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: Image.asset(
  //                     widget.image,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () {},
  //                   icon: const Icon(
  //                     Icons.play_arrow_rounded,
  //                     color: Colors.white,
  //                     size: 50,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               widget.eObj["title"].toString().replaceAll('_', ' '),
  //               style: TextStyle(
  //                 color: TColor.black,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               "Easy | 390 calories burn",
  //               style: TextStyle(
  //                 color: TColor.gray,
  //                 fontSize: 12,
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               "Descriptions",
  //               style: TextStyle(
  //                 color: TColor.black,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             ReadMoreText(
  //               'A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide',
  //               trimLines: 4,
  //               colorClickableText: TColor.black,
  //               trimMode: TrimMode.Line,
  //               trimCollapsedText: ' Read More ...',
  //               trimExpandedText: ' Read Less',
  //               style: TextStyle(
  //                 color: TColor.gray,
  //                 fontSize: 12,
  //               ),
  //               moreStyle: TextStyle(
  //                 fontSize: 12,
  //                 color: TColor.primaryColor1,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "How To Do It",
  //                   style: TextStyle(
  //                     color: TColor.black,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {},
  //                   child: Text(
  //                     "${stepArr.length} steps",
  //                     style: TextStyle(
  //                       color: TColor.gray,
  //                       fontSize: 12,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             stepArr.isEmpty
  //                 ? const Center(child: CircularProgressIndicator())
  //                 : ListView.builder(
  //               physics: const NeverScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               itemCount: stepArr.length,
  //               itemBuilder: (context, index) {
  //                 var sObj = stepArr[index];
  //                 return StepDetailRow(
  //                   sObj: sObj,
  //                   isLast: stepArr.last == sObj,
  //                 );
  //               },
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               "Custom Repetitions",
  //               style: TextStyle(
  //                 color: TColor.black,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 150,
  //               child: CupertinoPicker.builder(
  //                 itemExtent: 40,
  //                 selectionOverlay: Container(
  //                   width: double.maxFinite,
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     border: Border(
  //                       top: BorderSide(
  //                         color: TColor.gray.withOpacity(0.2),
  //                         width: 1,
  //                       ),
  //                       bottom: BorderSide(
  //                         color: TColor.gray.withOpacity(0.2),
  //                         width: 1,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 onSelectedItemChanged: (index) {},
  //                 childCount: 60,
  //                 itemBuilder: (context, index) {
  //                   return Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       const Icon(Icons.local_fire_department),
  //                       Text(
  //                         "${(index + 1) * 15} calories burn",
  //                         style: TextStyle(
  //                           color: TColor.gray,
  //                           fontSize: 10,
  //                         ),
  //                       ),
  //                       Text(
  //                         " ${index + 1} ",
  //                         style: TextStyle(
  //                           color: TColor.gray,
  //                           fontSize: 24,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       Text(
  //                         " times",
  //                         style: TextStyle(
  //                           color: TColor.gray,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ),
  //             RoundButton(
  //               title: "Start",
  //               elevation: 1,
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) =>
  //                     const CountdownScreen(duration: '5'),
  //                   ),
  //                 );
  //               },
  //             ),
  //             const SizedBox(height: 15),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              child: const Icon(Icons.more_horiz_rounded),
            ),
          ),
        ],
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
                    child: Image.asset(
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
                widget.eObj["title"].toString().replaceAll('_', ' '),
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Easy | 390 calories burn",
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
              ReadMoreText(
                'A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide A jumping jack, also known as a star jump and called a side-straddle hop in the US military, is a physical jumping exercise performed by jumping to a position with the legs spread wide',
                trimLines: 4,
                colorClickableText: TColor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More ...',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
                moreStyle: TextStyle(
                  fontSize: 12,
                  color: TColor.primaryColor1,
                  fontWeight: FontWeight.w700,
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
                  var sObj = stepArr[index];
                  return StepDetailRow(
                    sObj: sObj,
                    isLast: stepArr.last == sObj,
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const CountdownScreen(duration: '5'),
                    ),
                  );
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
