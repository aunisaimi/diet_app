
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/firebase_options.dart';
import 'package:diet_app/screen/home/activity_tracker_view.dart';
import 'package:diet_app/screen/home/home_view.dart';
import 'package:diet_app/screen/main_tab/main_tab_view.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/meal_plan_view.dart';
import 'package:diet_app/screen/on_boarding/on_boarding_view.dart';
import 'package:diet_app/screen/on_boarding/started_view.dart';
import 'package:diet_app/screen/workout_tracker/workout_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Widget getScreenId(){
  //   return StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (BuildContext context, snapshot) {
  //         if(snapshot.hasData){
  //           return FeedScreen(currentUserId: snapshot.data!.uid);
  //         } else {
  //           return const LoginScreen(); //temporary
  //         }
  //       });
  // }
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness with Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins"
      ),

      home:  const MainTabView(),
      //home:  const MealPlanView(),
       //body: FeedScreen(currentUserId: '')

    );
  }
}
