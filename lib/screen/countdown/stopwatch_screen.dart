import 'dart:async';

import 'package:diet_app/common/color_extension.dart';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  final String exerciseName;

  const StopwatchScreen({
    Key? key,
    required this.exerciseName
  }) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState(){
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {

      });
    });
  }

  void _stopStopwatch(){
    _stopwatch.stop();
    _timer.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {});
  }

  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  String _formattedTime(){
    final duration = _stopwatch.elapsed;
    return '${duration.inMinutes.toString().padLeft(2, '0')}'
        ':${(duration.inSeconds % 60).toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formattedTime(),
            style: TextStyle(fontSize: 48),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _stopwatch.isRunning
                    ? _stopStopwatch
                    : _startStopwatch,
                child: Text(
                    _stopwatch.isRunning
                        ? 'Stop'
                        : 'Start'
                ),
              ),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
