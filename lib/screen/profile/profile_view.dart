import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/setting_row.dart';
import 'package:diet_app/common/common_widget/title_subtitle_cell.dart';
import 'package:diet_app/screen/home/activity_tracker_view.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;

  List accountArr = [
    {
      "image": "assets/img/pic_5.png",
      "name": "Personal Data",
      "tag": "1"
    },
    {
      "image": "assets/img/p_achi.png",
      "name": "Achievement",
      "tag": "2"
    },
    {
      "image": "assets/img/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/img/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {
      "image": "assets/img/p_contact.png",
      "name": "Contact Us",
      "tag": "5"
    },
    {
      "image": "assets/img/p_privacy.png",
      "name": "Privacy Policy",
      "tag": "6"
    },
    {
      "image": "assets/img/p_setting.png",
      "name": "Setting",
      "tag": "7"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
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
                          "Auni Afeeqah",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Lose a Fat Program",
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
                          MaterialPageRoute(builder: (context) => const ActivityTrackerView()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "180cm",
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "65 kg",
                      subtitle: "Weight",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "23 ",
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 25),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: TColor.white,
              //     borderRadius: BorderRadius.circular(15),
              //     boxShadow: const [
              //       BoxShadow(color: Colors.black12, blurRadius: 2),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Account",
              //         style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
              //       ),
              //       const SizedBox(height: 8),
              //       ListView.builder(
              //         physics: const NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //         itemCount: accountArr.length,
              //         itemBuilder: (context, index) {
              //           var iObj = accountArr[index] as Map? ?? {};
              //           return SettingRow(
              //             icon: iObj["image"].toString(),
              //             title: iObj["name"].toString(),
              //             onPressed: () {},
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 25),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: TColor.white,
              //     borderRadius: BorderRadius.circular(15),
              //     boxShadow: const [
              //       BoxShadow(color: Colors.black12, blurRadius: 2),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Notification",
              //         style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
              //       ),
              //       const SizedBox(height: 8),
              //       SizedBox(
              //         width: 30,
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             const Icon(Icons.notifications),
              //             const SizedBox(width: 15),
              //             Expanded(
              //               child: Text(
              //                 "Pop-Up Notification",
              //                 style: TextStyle(color: TColor.black, fontSize: 12, fontWeight: FontWeight.w600),
              //               ),
              //             ),
              //             CustomAnimatedToggleSwitch<bool>(
              //               current: positive,
              //               values: [false, true],
              //               dif: 0.0,
              //               indicatorSize: const Size.square(30.0),
              //               animationDuration: const Duration(milliseconds: 200),
              //               animationCurve: Curves.linear,
              //               onChanged: (b) => setState(() => positive = b),
              //               iconBuilder: (context, local, global) {
              //                 return const SizedBox();
              //               },
              //               defaultCursor: SystemMouseCursors.click,
              //               onTap: () => setState(() => positive = !positive),
              //               iconsTappable: false,
              //               wrapperBuilder: (context, global, child) {
              //                 return Stack(
              //                   alignment: Alignment.center,
              //                   children: [
              //                     Positioned(
              //                       left: 10.0,
              //                       right: 10.0,
              //                       height: 30.0,
              //                       child: DecoratedBox(
              //                         decoration: BoxDecoration(
              //                           gradient: LinearGradient(colors: TColor.secondaryG),
              //                           borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              //                         ),
              //                       ),
              //                     ),
              //                     child,
              //                   ],
              //                 );
              //               },
              //               foregroundIndicatorBuilder: (context, global) {
              //                 return SizedBox.fromSize(
              //                   size: const Size(10, 10),
              //                   child: DecoratedBox(
              //                     decoration: BoxDecoration(
              //                       color: TColor.white,
              //                       borderRadius: BorderRadius.all(Radius.circular(50.0)),
              //                       boxShadow: const [
              //                         BoxShadow(
              //                           color: Colors.black38,
              //                           spreadRadius: 0.05,
              //                           blurRadius: 1.1,
              //                           offset: Offset(0.0, 0.8),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               },
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 25),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              //   decoration: BoxDecoration(
              //     color: TColor.white,
              //     borderRadius: BorderRadius.circular(15),
              //     boxShadow: const [
              //       BoxShadow(color: Colors.black12, blurRadius: 2),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Other",
              //         style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
              //       ),
              //       const SizedBox(height: 8),
              //       ListView.builder(
              //         physics: const NeverScrollableScrollPhysics(),
              //         padding: EdgeInsets.zero,
              //         shrinkWrap: true,
              //         itemCount: otherArr.length,
              //         itemBuilder: (context, index) {
              //           var iObj = otherArr[index] as Map? ?? {};
              //           return SettingRow(
              //             icon: iObj["image"].toString(),
              //             title: iObj["name"].toString(),
              //             onPressed: () {},
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
