import 'package:diet_app/common/color_extension.dart';
import 'package:diet_app/model/exercises.dart';
import 'package:diet_app/model/steps.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';

class StepDetailRow extends StatelessWidget {
  final StepModel sObj;
  final bool isLast;

  const StepDetailRow({
    Key? key,
    required this.sObj,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = sObj.stepNumber ?? 'N/A';
    final description = sObj.description ?? 'No Description Available';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: TColor.secondaryColor1, // Purple color
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                steps,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 12,
                ),
              ),
            ),
            if (!isLast)
              DottedDashedLine(
                height: 80,
                width: 5,
                dashColor: TColor.secondaryColor1,
                axis: Axis.vertical,
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step $steps', // Display the step number with label
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 12,
                ),
              ),
              Text(
                description, // Display the description
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
