
import 'package:diet_app/model/diet.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/MealPlanner.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/diet.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/meal_plan_view.dart';
import 'package:diet_app/screen/water_intake/water_intake.dart';
import 'package:diet_app/screen/workout_tracker/add_exercise.dart';
import 'package:flutter/material.dart';

import '../../common/RoundButton.dart';
import '../workout_tracker/workout_tracker_view.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Diet> diets = [];
    // var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
                title: "Workout Tracker",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkoutTrackerView(
                            document: '',
                            title: ''),
                    ),
                  );
                }),

            const SizedBox(height: 15,),

            RoundButton(
                title: "Meal Planner",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MealPlanView(
                        //remainingCalories: 2500,
                        onCaloriesUpdated: (int value) {  },),
                    ),
                  );
                }),

            const SizedBox(height: 15),

            RoundButton(
                title: "Diet Helper",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MealPlanner(dietType:  diets.map(
                              (diet) => diet.dietType).toList()),
                    ),
                  );
                }),

            const SizedBox(height: 15),

            RoundButton(
                title: "Add Workout (Trainer)",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddExercise(),
                    ),
                  );
                }),


          ],
        ),
      ),
    );
  }
}