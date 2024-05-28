import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/title_subtitle_cell.dart';
import 'package:diet_app/database/auth_service.dart';
import 'package:diet_app/screen/profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the user's document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Extract and set user data to the respective TextEditingController
        setState(() {
          _emailController.text = userDoc['email'];
          _firstnameController.text = userDoc['fname'];
          _lastnameController.text = userDoc['lname'];
          _genderController.text = userDoc['gender'];
          txtHeight.text = userDoc['height'].toString();
          txtWeight.text = userDoc['weight'].toString();
        });
        print("This is the current user email: ${userDoc['email']}");
        print("This is the current user name: ${userDoc['fname']}");

      } else {
        print("Data not exist");
      }
    } catch (e) {
      print("Error, please check: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    //var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
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
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/img/workingcats.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_firstnameController.text} ${_lastnameController.text}",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Lose a Fat Program", // Update this
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile())
                        );
                        // Navigate to edit profile page
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: txtHeight.text,
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: txtWeight.text,
                      subtitle: "Weight",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: _genderController.text,
                      subtitle: "Gender",
                    ),
                  ),
                ],
              ),
              // Other UI elements
            ],
          ),
        ),
      ),
    );
  }
}
