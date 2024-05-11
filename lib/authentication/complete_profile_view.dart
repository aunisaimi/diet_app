import 'package:diet_app/authentication/what_your_goal_view.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),

                SizedBox(height: media.width * 0.05),

                Text(
                  "Lets Complete Your Profile",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 12),
                ),

                SizedBox(height: media.width * 0.05),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: TColor.lightGray,
                          borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 15),

                              child: Image.asset(
                                "assets/img/gender.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: TColor.gray),
                            ),

                            Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: ["Male","Female"].map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            color: TColor.gray,
                                            fontSize: 14),
                                        ),
                                    )).toList(),
                                    onChanged: (value){},
                                    isExpanded: true,
                                    hint: Text(
                                      "Choose Gender",
                                      style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ),

                            const SizedBox(width: 8),

                          ],
                        ),
                      ),
                      SizedBox(height: media.width * 0.04),

                      RoundTextField(
                        controller: txtDate,
                          hitText: "Date of Birth",
                          icon: "assets/img/menu_schedule.png",
                          obscureText: false),

                      SizedBox(height: media.width * 0.04),

                      Row(
                        children: [
                          Expanded(
                              child: RoundTextField(
                                controller: txtDate,
                                hitText: "Your Weight",
                                icon: "assets/img/menu_weight.png",
                                obscureText: false,
                              ),
                          ),

                          const SizedBox(width: 8),

                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "KG",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.04),

                      Row(
                        children: [
                          Expanded(
                              child: RoundTextField(
                                controller: txtDate,
                                hitText: "Your Height",
                                icon: "assets/img/menu_traning_status.png",
                                obscureText: false,
                              ),
                          ),

                          const SizedBox(width: 8),

                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "CM",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.07),
                      RoundButton(
                          title: "Next >",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WhatYourGoalView()));
                          })
                    ],
                  ),
                )
              ],
            ),
          ),),
      ),
    );
  }
}
