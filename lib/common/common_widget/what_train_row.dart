import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/screen/workout_tracker/exercise_step_detail.dart';
import 'package:diet_app/screen/workout_tracker/workout_detail_view.dart';
import 'package:flutter/material.dart';

class WhatTrainRow extends StatelessWidget {
  //final Map wObj;
  final Map<String,dynamic> wObj;
  final VoidCallback onViewMorePressed;

  const WhatTrainRow({
    Key? key,
    required this.wObj,
    required this.onViewMorePressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              TColor.primaryColor2.withOpacity(0.3),
              TColor.primaryColor1.withOpacity(0.3)
            ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wObj["title"]?.toString() ?? "No Title",
                      style: TextStyle(
                        color: TColor.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                    const SizedBox(height: 4,),
                    // Text(
                    //   "${wObj["exercises"]?.toString()?? "N/A"} "
                    //       " | ${ wObj["duration"]?.toString()?? "N/A" }" ,
                    //   style: TextStyle(
                    //     color: TColor.gray,
                    //     fontSize: 12,
                    //   ),
                    // ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: 100,
                      height: 30,
                      child: RoundButton(
                        title: "View More",
                        fontSize: 10,
                        type: RoundButtonType.textGradient,
                        elevation: 0.05,
                        fontWeight: FontWeight.w400,
                        onPressed: onViewMorePressed,
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => WorkoutDetailView(dObj: wObj,
                          //       //difficulty: "Beginner",
                          //     ),
                          //   ),
                          // );

                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(width: 15),

              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.54),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      wObj["image"]?.toString() ?? " ",
                      width: 90,
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (context,error, stackTrace){
                        return Image.asset(
                          'assets/img/error.png',
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}