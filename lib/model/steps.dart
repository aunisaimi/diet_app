import 'package:cloud_firestore/cloud_firestore.dart';

class StepModel {
  final String id; // Added id field to store document id
  final String step;
  final String description;

  StepModel(this.description, {required this.id, required this.step});

  factory StepModel.fromMap(String step,String description, String id) {
    return StepModel(
        description,
        id: id,
        step: step);
  }

// Optional: Uncomment the following methods if needed

// factory StepModel.fromMap(Map<String, dynamic> map) {
//   return StepModel(
//     step: map['step'] ?? '',
//   );
// }

// Map<String, dynamic> toMap() {
//   return {
//     'step': step,
//   };
// }
}
