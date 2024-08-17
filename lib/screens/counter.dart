import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:counter/enums/workout_statuses.dart';
import 'package:counter/models/workflow.dart';
import 'package:counter/models/workout.dart';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _seconds = 0;
  late Workout _workout;
  late Timer _timer;
  WorkoutStatus _currentStatus = WorkoutStatus.WORKOUT;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playWhistle() async {
    await _audioPlayer.play(AssetSource('sounds/whistle.mp3'));
  }

  void _playRing() async {
    await _audioPlayer.play(AssetSource('sounds/ring.mp3'));
  }

  Future<void> _startAndAwaitTimer(int time, WorkoutStatus status) async {
    final completer = Completer<void>();
    status == WorkoutStatus.WORKOUT ? _playWhistle() : _playRing();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentStatus = status;
        _seconds++;
      });

      if (_seconds > time) {
        _timer.cancel();
        setState(() {
          _seconds = 0;
        });
        completer.complete(); // Signal that the timer is done
      }
    });

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _workout = ModalRoute
          .of(context)!
          .settings
          .arguments as Workout;
      Workflow? workflow = Workflow.constructWorkflow(_workout);
      while(workflow != null){
        await _startAndAwaitTimer(workflow.time, workflow.status);
        workflow = workflow.next;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _currentStatus == WorkoutStatus.WORKOUT ? Colors.green : Colors.red
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentStatus.text,
              style: const TextStyle(
                  fontSize: 50
              ),
            ),
            Text("$_seconds", style: const TextStyle(fontSize: 60),)
          ],
        ),
      ),
    );
  }
}