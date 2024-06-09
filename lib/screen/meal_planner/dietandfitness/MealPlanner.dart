import 'package:cloud_firestore/cloud_firestore.dart';  // Importing Firestore package
import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/model/meal.dart';  // Importing custom meal model
import 'package:diet_app/screen/meal_planner/dietandfitness/MealDetailScreen.dart';
import 'package:diet_app/screen/meal_planner/dietandfitness/diet.dart';
import 'package:flutter/material.dart';

class MealPlanner extends StatefulWidget {
  const MealPlanner({Key? key, required  dietType}) : super(key: key);

  @override
  State<MealPlanner> createState() => _MealPlannerState();
}

class _MealPlannerState extends State<MealPlanner> {
  List<Map<String, String>> dietTypes = [];  // List to hold diet types fetched from Firestore
  String selectedDietId = '';  // Variable to hold the selected diet ID
  String selectedDietName = '';  // Variable to hold the selected diet name
  List<Meal> meals = [];  // List to hold meals fetched from Firestore
  String selectedCategory = 'breakfast';  // Variable to hold the selected category, default is 'breakfast'

  @override
  void initState() {
    super.initState();
    _fetchDietTypes();  // Fetch diet types when the widget initializes
  }

  // Function to fetch diet types from Firestore
  Future<void> _fetchDietTypes() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('diets')
          .get();  // Fetch all documents from the 'diets' collection
      setState(() {
        dietTypes = snapshot.docs.map((doc) => {  // Map each document to a map with 'dietId' and 'name'
          'dietId': doc.id,
          'name': doc['dietType'] as String
        }).toList();

        if (dietTypes.isNotEmpty) {  // If there are diet types fetched
          selectedDietId = dietTypes.first['dietId']!;  // Set the first diet ID as selected
          selectedDietName = dietTypes.first['name']!;  // Set the first diet name as selected
          _fetchMeals(selectedDietId, selectedCategory);  // Fetch meals for the selected diet and category
        }
      });

      print('Diet types fetched: $dietTypes');  // Print fetched diet types

    } catch (e,stackTrace) {
      print('Error fetching diet types: $e');
      print(stackTrace);
    }
  }

  // Function to fetch meals from Firestore based on diet ID and category
  Future<void> _fetchMeals(String dietId, String category) async {
    try {
      print('Fetching meals for dietId: $dietId, category: $category');

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('meals')
          .where('dietId', isEqualTo: dietId)  // Query meals where 'dietId' matches
          .where('category', isEqualTo: category)  // Query meals where 'category' matches
          .get();

      setState(() {
        meals = snapshot.docs.map((doc) => Meal.fromFirestore(doc)).toList();  // Map each document to a Meal object and update the state
      });

      print('Meals fetched: $meals');  // Print fetched meals

    } catch (e) {
      print('Error fetching meals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Planner"),  // Title of the AppBar
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,  // Center align the row
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [TColor.secondaryColor1, TColor.secondaryColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  )
                ),
                child: DropdownButton<String>(
                  value: selectedDietName,  // Currently selected diet name
                  onChanged: (newValue) {  // Callback when a new diet type is selected
                    setState(() {
                      selectedDietId = dietTypes.firstWhere(
                              (diet) => diet['name'] == newValue)['dietId']!;  // Find the selected diet ID
                      selectedDietName = newValue!;  // Update the selected diet name
                    });

                    print('Selected dietId: $selectedDietId, dietName: $selectedDietName');  // Print selected diet ID and name

                    _fetchMeals(selectedDietId, selectedCategory);  // Fetch meals for the selected diet and category
                  },
                  items: dietTypes.map<DropdownMenuItem<String>>((diet) {  // Create dropdown items from diet types
                    return DropdownMenuItem<String>(
                      value: diet['name'],
                      child: Text(diet['name']!),
                    );
                  }).toList(),
                ),
              ),


              const SizedBox(width: 20),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [TColor.secondaryColor1, TColor.secondaryColor2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                    )
                ),
                child: DropdownButton<String>(
                  value: selectedCategory,  // Currently selected category
                  onChanged: (newValue) {  // Callback when a new category is selected
                    setState(() {
                      selectedCategory = newValue!;  // Update the selected category
                    });
                    print('Selected category: $selectedCategory');  // Print selected category
                    _fetchMeals(selectedDietId, selectedCategory);  // Fetch meals for the selected diet and category
                  },
                  items: ['breakfast', 'lunch', 'dinner', 'snack'].map<DropdownMenuItem<String>>((String category) {  // Create dropdown items for categories
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          // ListView to display the fetched meals
          Expanded(
            child: ListView.builder(
              itemCount: meals.length,  // Number of meals to display
              itemBuilder: (context, index) {
                Meal meal = meals[index];  // Get the meal at the current index
                return ListTile(
                  leading: Image.network(
                      meal.image,
                      fit: BoxFit.cover),

                  title: Text(meal.name),
                  subtitle: Text(
                    "Calories: ${meal.calories},"
                        " Fat: ${meal.fat}, "
                        "Recommended Plate: ${meal.recommend}",
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=> MealDetailScreen(meal: meal)
                        )
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
