import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_app/Helpers/preferences_helper.dart';
import 'package:diet_app/common/RoundButton.dart';
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/common/common_widget/workout_row.dart';
import 'package:diet_app/screen/bmi/bmiCalculator.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/meal_plan_view.dart';
import 'package:diet_app/screen/on_boarding/started_view.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../database/auth_service.dart';
import 'activity_tracker_view.dart';
import 'finished_workout_view.dart';


class HomeView extends StatefulWidget {
  final int remainingCalories;
  late bool logGoogle = false;

  HomeView({Key? key, required this.remainingCalories}) : super(key : key);

  HomeView.loginWithGoogle(logGoogle, this.remainingCalories){
    this.logGoogle = logGoogle;
  }

  final User? user = FirebaseAuth.instance.currentUser;


  @override
  State<HomeView> createState() => _HomeViewState(logGoogle);
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  Future<DocumentSnapshot<Map<String, dynamic>>>? userDataFuture;

  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  double? bmi = 0;
  double? bmiPercentage;
  String? bmiMessage;
  String bmiStatus = "";


  //late int _remainingCalories;
  int _remainingCalories = 2500;
  late ValueNotifier<double> _progressNotifier = ValueNotifier(0);

  bool logGoogle;
  _HomeViewState(this.logGoogle);


  Map<String, Map<String, dynamic>> selectedMeals = {
    "Breakfast": {},
    "Lunch": {},
    "Snack": {},
    "Dinner": {},
  };

  int get _totalCalories {
    int total = 0;
    selectedMeals.forEach((key, meal) {
      if (meal.isNotEmpty) {
        total += meal["calories"] as int;
      }
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    print('${_emailController}');
    print('${_firstnameController}');
    print('${_lastnameController}');
    fetchUserData();
    _remainingCalories = widget.remainingCalories;
    _progressNotifier = ValueNotifier(_calculateProgress(widget.remainingCalories));
    _loadData();
    _loadRemainingCalories();
  }

  Future<void> _loadRemainingCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastUpdateDate = prefs.getString('lastUpdateDate');
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastUpdateDate == null || lastUpdateDate != currentDate) {
      // Reset remaining calories if date has changed
      await _updateRemainingCalories(widget.remainingCalories);
      await prefs.setString('lastUpdateDate', currentDate);
    } else {
      setState(() {
        _remainingCalories = prefs.getInt('remainingCalories') ?? widget.remainingCalories;
        _progressNotifier.value = _calculateProgress(_remainingCalories);
      });
    }
  }

  Future<void> _updateRemainingCalories(int updatedCalories) async {
    setState(() {
      _remainingCalories = updatedCalories;
      _progressNotifier.value = _calculateProgress(_remainingCalories);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('remainingCalories', _remainingCalories);
  }


  double _calculateProgress(int remainingCalories) {
    const int dailyCalorieGoal = 2500; // default daily goal is 2500kcal
    double progress = (remainingCalories / dailyCalorieGoal) * 100;

    // Debugging print
    print("Progress calculation: $remainingCalories / $dailyCalorieGoal = $progress");

    return progress;
  }

  // Define a list of images or widgets for the carousel
  final List<String> imgList =[
    'assets/img/1.png',
    'assets/img/2.png',
    'assets/img/3.png',
  ];



  Future<void> _loadData() async{
    var meals = await PreferencesHelper.loadSelectedMeals();
    setState(() {
      selectedMeals = meals;
    });
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
          bmi = userDoc['bmi'];
          bmiPercentage = calculateBMIPercentage(bmi!);
          bmiStatus = determineBMIStatus(bmi!);
        });
        print("This is the current user email: ${userDoc['email']}");
        print("This is the current user name: ${userDoc['fname']}");
        print("This is the current user lname: ${userDoc['lname']}");
        print("This is the current user gender: ${userDoc['gender']}");
        print("This is the current user bmi: ${userDoc['bmi']}");

      } else {
        print("Data not exist");
      }
    } catch (e) {
      print("Error, please check: ${e}");
    }
  }



  double calculateBMIPercentage(double bmi){
    const double minNormalBMI = 18.5;
    const double maxNormalBMI  = 24.9;

    if (bmi < minNormalBMI){
      return ((bmi / minNormalBMI) * 100).clamp(0.0, 100.0);
    } else if (bmi > maxNormalBMI){
      return ((bmi / maxNormalBMI) * 100).clamp(0.0, 100.0);
    } else {
      return ((bmi - minNormalBMI) / (maxNormalBMI - minNormalBMI)) * 100;
    }
  }

  String determineBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return "You are underweight";
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return "You have a normal weight";
    } else {
      return "You are overweight";
    }
  }

  String _getBMIMessage(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }


  @override
  void dispose(){
    super.dispose();
    _progressNotifier.dispose();
  }


  void logout(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              TextButton(
                  child: const Text('Yes'),
                  onPressed: (){
                    final _auth = AuthService();
                    _auth.signOut();
                    Navigator.of(context)
                        .pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const StartedView())
                    );
                  },
              )
            ],
          );
        });
  }

  List lastWorkoutArr = [
    {
      "name": "Full Body Workout",
      "image": "assets/img/workout_2.jpg",
      "kcal": "180",
      "time": "20",
      "progress": 0.3
    },
    {
      "name": "Lower Body Workout",
      "image": "assets/img/leg_extension.jpg",
      "kcal": "200",
      "time": "30",
      "progress": 0.4
    },
    {
      "name": "Ab Workout",
      "image": "assets/img/situp.jpg",
      "kcal": "300",
      "time": "40",
      "progress": 0.7
    },
  ];
  List<int> showingTooltipOnSpots = [21];

  List<FlSpot> get allSpots => const [
    FlSpot(0, 20),
    FlSpot(1, 25),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 30),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40)
  ];

  List waterArr = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"},
  ];

  List ads = [
    {
      "image": "assets/img/drink.png",
      "subtitle":
      "Drink a lot of water"
    },
    {
      "image": "assets/img/do_yoga.png",
      "subtitle":
      "Remember to meditate "
    },
    {
      "image": "assets/img/keep_walking.png",
      "subtitle":
      "Do exercises even at minimal"
    },
    {
      "image": "assets/img/rest_well.png",
      "subtitle":
      "Exercise excessively is not good.\nTake a rest."
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    print("Building HomeView with remaining calories: $_remainingCalories");

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: TColor.primaryG,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back,",
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 12),
                        ),
                        Text(
                          "${_firstnameController.text} ${_lastnameController.text}",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        logout(context);
                      },
                      icon: const Icon(
                        Icons.exit_to_app_rounded,
                        size: 25,),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.05,),

                //BMI display
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryG),
                      borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/img/bg_dots.png",
                          height: media.width * 0.4,
                          width: double.maxFinite,
                          fit: BoxFit.fitHeight,
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BMI : ${bmi}",
                                style: TextStyle(
                                    color: TColor.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'BMI Message:${_getBMIMessage(bmi!)} ',
                                style: TextStyle(
                                    color: TColor.white.withOpacity(0.7),
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              SizedBox(
                                  width: 120,
                                  height: 35,
                                  child: RoundButton(
                                      title: "View More",
                                      type: RoundButtonType.bgSGradient,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      onPressed: ()  async {
                                        //final result = await
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const BMICalculator()
                                            )
                                        );
                                      }))
                            ],
                          ),
                          const SizedBox(height: 10),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event,
                                      pieTouchResponse) {},
                                ),
                                startDegreeOffset: 270,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 1,
                                centerSpaceRadius:  15,
                                sections: showingSections(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),

                SizedBox(height: media.width * 0.05),

                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: TColor.primaryColor2.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Target",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: RoundButton(
                          title: "Check",
                          type: RoundButtonType.bgGradient,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const ActivityTrackerView(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: media.width * 0.05),

                CarouselSlider(
                    items: ads.map((item) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: TColor.secondaryG,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(vertical: media.width * 0.05,horizontal: 10),
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Image.asset(
                              item['image'].toString(),
                              width: media.width * 0.5,
                              fit: BoxFit.fitWidth,
                            ),

                            SizedBox(height: media.width * 0.05),

                            Text(
                              item['subtitle'].toString(),
                              style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                      aspectRatio: 16/9,
                      initialPage: 0,
                      height: 200,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                    )),

                SizedBox(height: media.width * 0.05),

                Text(
                  "Activity Status",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),

                SizedBox(height: media.width * 0.02),

                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.4,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Heart Rate",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                      colors: TColor.primaryG,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)
                                      .createShader(
                                      Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "78 BPM",
                                  style: TextStyle(
                                      color: TColor.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        LineChart(
                          LineChartData(
                            showingTooltipIndicators:
                            showingTooltipOnSpots.map((index) {
                              return ShowingTooltipIndicators([
                                LineBarSpot(
                                  tooltipsOnBar,
                                  lineBarsData.indexOf(tooltipsOnBar),
                                  tooltipsOnBar.spots[index],
                                ),
                              ]);
                            }).toList(),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchCallback: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return;
                                }
                                if (event is FlTapUpEvent) {
                                  final spotIndex =
                                      response.lineBarSpots!.first.spotIndex;
                                  showingTooltipOnSpots.clear();
                                  setState(() {
                                    showingTooltipOnSpots.add(spotIndex);
                                  });
                                }
                              },
                              mouseCursorResolver: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return SystemMouseCursors.basic;
                                }
                                return SystemMouseCursors.click;
                              },
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                  List<int> spotIndexes) {
                                return spotIndexes.map((index) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: Colors.red,
                                    ),
                                    FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) =>
                                          FlDotCirclePainter(
                                            radius: 3,
                                            color: Colors.white,
                                            strokeWidth: 3,
                                            strokeColor: TColor.secondaryColor1,
                                          ),
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor: TColor.secondaryColor1,
                                tooltipRoundedRadius: 20,
                                getTooltipItems:
                                    (List<LineBarSpot> lineBarsSpot) {
                                  return lineBarsSpot.map((lineBarSpot) {
                                    return LineTooltipItem(
                                      "${lineBarSpot.x.toInt()} mins ago",
                                      const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: lineBarsData,
                            minY: 0,
                            maxY: 130,
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: media.width * 0.95,
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10)
                            ]),
                        child: Row(
                          children: [
                            SimpleAnimationProgressBar(
                              height: media.width * 0.85,
                              width: media.width * 0.07,
                              backgroundColor: Colors.grey.shade100,
                              foregrondColor: Colors.purple,
                              ratio: 0.5,
                              direction: Axis.vertical,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(15),
                              gradientColor: LinearGradient(
                                  colors: TColor.primaryG,
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Water Intake",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                            colors: TColor.primaryG,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)
                                            .createShader(
                                            Rect.fromLTRB(
                                                0, 0, bounds.width, bounds.height));
                                      },
                                      child: Text(
                                        "4 Liters",
                                        style: TextStyle(
                                            color: TColor.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      "Real time updates",
                                      style: TextStyle(
                                        color: TColor.gray,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: waterArr.map((wObj) {
                                          var isLast = wObj == waterArr.last;
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin:
                                                    const EdgeInsets.symmetric(vertical: 2),
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: TColor.secondaryColor1.withOpacity(0.5),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                  ),
                                                  if (!isLast)
                                                    DottedDashedLine(
                                                        height: media.width * 0.078,
                                                        width: 0,
                                                        dashColor: TColor
                                                            .secondaryColor1
                                                            .withOpacity(0.5),
                                                        axis: Axis.vertical)
                                                ],
                                              ),

                                              const SizedBox(width: 10),

                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    wObj["title"].toString(),
                                                    style: TextStyle(
                                                      color: TColor.gray,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  ShaderMask(
                                                    blendMode: BlendMode.srcIn,
                                                    shaderCallback: (bounds) {
                                                      return LinearGradient(
                                                          colors: TColor.secondaryG,
                                                          begin: Alignment.centerLeft,
                                                          end: Alignment.centerRight)
                                                          .createShader(
                                                          Rect.fromLTRB(
                                                              0,
                                                              0,
                                                              bounds.width,
                                                              bounds.height));
                                                    },
                                                    child: Text(
                                                      wObj["subtitle"].toString(),
                                                      style: TextStyle(
                                                          color: TColor.white
                                                              .withOpacity(0.7),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: media.width * 0.05),

                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: media.width * 0.45,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 2)
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sleep",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                            colors: TColor.primaryG,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)
                                            .createShader(
                                            Rect.fromLTRB(
                                                0, 0, bounds.width, bounds.height));
                                      },
                                      child: Text(
                                        "8h 20m",
                                        style: TextStyle(
                                            color: TColor.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.alarm)
                                  ]),
                            ),

                            SizedBox(height: media.width * 0.05),

                            Container(
                              width: double.maxFinite,
                              height: media.width * 0.45,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2)
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Calories",
                                      style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                            colors: TColor.primaryG,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)
                                            .createShader(Rect.fromLTRB(
                                            0, 0, bounds.width, bounds.height));
                                      },
                                      child: Text(
                                        "$_remainingCalories kCal",
                                        //"760 kCal",
                                        style: TextStyle(
                                            color: TColor.white, //.withOpacity(0.7),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: media.width * 0.2,
                                        height: media.width * 0.2,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: media.width * 0.15,
                                              height: media.width * 0.15,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: TColor.primaryG),
                                                borderRadius: BorderRadius.circular(media.width * 0.075),
                                              ),
                                              child: FittedBox(
                                                child: Text(
                                                  "$_remainingCalories kCal\nleft",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SimpleCircularProgressBar(
                                              progressStrokeWidth: 10,
                                              backStrokeWidth: 10,
                                              progressColors: [TColor.secondaryColor2, TColor.secondaryColor1],
                                              backColor: Colors.grey.shade100,
                                              valueNotifier: _progressNotifier,
                                              startAngle: -180,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MealPlanView(
                                        remainingCalories: _remainingCalories,
                                        onCaloriesUpdated: (updatedCalories) {
                                          _updateRemainingCalories(updatedCalories);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Text("Go to Meal Plan"),
                              ),
                            )
                          ],
                        )
                    )
                  ],
                ),

                SizedBox(height: media.width * 0.1,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Workout Progress",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.primaryG),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: ["Weekly", "Monthly"]
                                .map((name) => DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: TColor.gray, fontSize: 14),
                              ),
                            ))
                                .toList(),
                            onChanged: (value) {},
                            icon: Icon(Icons.expand_more, color: TColor.white),
                            hint: Text(
                              "Weekly",
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: media.width * 0.05,),
                Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: media.width * 0.5,
                    width: double.maxFinite,
                    child: LineChart(
                      LineChartData(
                        showingTooltipIndicators:
                        showingTooltipOnSpots.map((index) {
                          return ShowingTooltipIndicators([
                            LineBarSpot(
                              tooltipsOnBar,
                              lineBarsData.indexOf(tooltipsOnBar),
                              tooltipsOnBar.spots[index],
                            ),
                          ]);
                        }).toList(),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: false,
                          touchCallback: (FlTouchEvent event,
                              LineTouchResponse? response) {
                            if (response == null ||
                                response.lineBarSpots == null) {
                              return;
                            }
                            if (event is FlTapUpEvent) {
                              final spotIndex =
                                  response.lineBarSpots!.first.spotIndex;
                              showingTooltipOnSpots.clear();
                              setState(() {
                                showingTooltipOnSpots.add(spotIndex);
                              });
                            }
                          },
                          mouseCursorResolver: (FlTouchEvent event,
                              LineTouchResponse? response) {
                            if (response == null ||
                                response.lineBarSpots == null) {
                              return SystemMouseCursors.basic;
                            }
                            return SystemMouseCursors.click;
                          },
                          getTouchedSpotIndicator: (LineChartBarData barData,
                              List<int> spotIndexes) {
                            return spotIndexes.map((index) {
                              return TouchedSpotIndicatorData(
                                FlLine(
                                  color: Colors.transparent,
                                ),
                                FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) =>
                                      FlDotCirclePainter(
                                        radius: 3,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: TColor.secondaryColor1,
                                      ),
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: TColor.secondaryColor1,
                            tooltipRoundedRadius: 20,
                            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                              return lineBarsSpot.map((lineBarSpot) {
                                return LineTooltipItem(
                                  "${lineBarSpot.x.toInt()} mins ago",
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: lineBarsData1,
                        minY: -0.5,
                        maxY: 110,
                        titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: bottomTitles,
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: rightTitles,
                            )),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 25,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: TColor.gray.withOpacity(0.15),
                              strokeWidth: 2,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Workout",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See More",
                        style: TextStyle(
                            color: TColor.gray,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lastWorkoutArr.length,
                    itemBuilder: (context, index) {
                      var wObj = lastWorkoutArr[index] as Map? ?? {};
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const FinishedWorkoutView(),
                              ),
                            );
                          },
                          child: WorkoutRow(wObj: wObj));
                    }),
                SizedBox(
                  height: media.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2, (i) {
        final double value = bmiPercentage ?? 0;
        final double percentage = bmiPercentage ?? 0.0;
        final Color color = TColor.secondaryColor2;
        var color0 = LinearGradient(colors: TColor.primaryG);

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color,
                value: value,
                title:'${percentage.toStringAsFixed(2)}',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 100 - value,//100 - value,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.primaryColor2.withOpacity(0.5),
      TColor.primaryColor1.withOpacity(0.5),
    ]),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 35),
      FlSpot(2, 70),
      FlSpot(3, 40),
      FlSpot(4, 80),
      FlSpot(5, 25),
      FlSpot(6, 70),
      FlSpot(7, 35),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    gradient: LinearGradient(colors: [
      TColor.secondaryColor2.withOpacity(0.5),
      TColor.secondaryColor1.withOpacity(0.5),
    ]),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
    ),
    spots: const [
      FlSpot(1, 80),
      FlSpot(2, 50),
      FlSpot(3, 90),
      FlSpot(4, 40),
      FlSpot(5, 80),
      FlSpot(6, 35),
      FlSpot(7, 60),
    ],
  );

  SideTitles get rightTitles => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 20,
    reservedSize: 40,
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }
}