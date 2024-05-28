import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/firebase_options.dart';
import 'package:diet_app/screen/main_tab/main_tab_view.dart';
import 'package:diet_app/screen/on_boarding/started_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if(email != null) {
      // user has previously logged in, show the main screen
      return MainTabView();
    } else {
      // user not logged in
      return StartedView();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Fitness with Me',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primaryColor: TColor.primaryColor1,
  //       fontFamily: "Poppins"
  //     ),
  //
  //     //home:  const MainTabView(),
  //     home:  const StartedView(),
  //      //body: FeedScreen(currentUserId: '')
  //
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return MaterialApp(
            title: 'Fitness with Me',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: TColor.primaryColor1,
              fontFamily: "Poppins",
            ),
            home: snapshot.data,
          );
        }
      },
    );
  }
}
