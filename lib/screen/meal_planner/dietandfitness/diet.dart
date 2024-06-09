import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/model/diet.dart';
import 'package:diet_app/model/meal.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/MealPlanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../database/auth_service.dart';

class DietScreen extends StatefulWidget {
  final Meal meal;
  const DietScreen({Key? key, required this.meal}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthService authService = AuthService();
  List<Diet> diets = [];

  List<String> dietTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchDiets();
    _fetchDietTypes();
  }

  Future<void> _fetchDietTypes() async {
    try {
      final snapshot = await _firestore.collection('diets').get();
      setState(() {
        dietTypes = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (error) {
      print('Error fetching diet types: $error');
    }
  }

  Future<void> _fetchDiets() async {
    try {
      final snapshot = await _firestore.collection('diets').get();
      setState(() {
        diets = snapshot.docs.map((doc) => Diet.fromFirestore(doc)).toList();
      });
    } catch (error) {
      print('Error fetching diets: $error');
    }
  }

  Future<void> _saveDietChoice(String dietType) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'selectedDiet': dietType,
        });
      } catch (error) {
        print('Error saving diet choice: $error');
      }
    }
  }

  void _onDietSelected(String dietType) {
    _saveDietChoice(dietType).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealPlanner(
              dietType: diets.map(
                      (diet) => diet.dietType).toList()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: TColor.secondaryG,
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
                "Diet",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
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
                  "assets/img/keep_walking.png",
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
                topRight: Radius.circular(25),
              ),
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
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       // Image.network(meal.image),
                      ],
                    ),
                  ),
                  // ...diets.map((diet) {
                  //   return ListTile(
                  //     title: Text(diet.dietType),
                  //     onTap: () => _onDietSelected(diet.dietType),
                  //   );
                  // }).toList(),
                  SizedBox(height: media.width * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
