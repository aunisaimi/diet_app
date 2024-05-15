class StepModel {
  final String id;
  final String steps;
  final String description;

  StepModel({required this.id, required this.description, required this.steps});

  factory StepModel.fromMap(String id, Map<String, dynamic> data) {
    return StepModel(
      id:id,
      steps:data['steps'] as String,
      description: data['description'] as String,
    );
  }
}
