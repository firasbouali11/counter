import 'package:counter/models/workout.dart';
import 'package:counter/screens/counter.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final TextEditingController countController = TextEditingController(text: "3");
  final TextEditingController restLapsController = TextEditingController(text: "5");
  final TextEditingController lapsCountController = TextEditingController(text: "1");
  final TextEditingController workoutController = TextEditingController(text: "60");
  final TextEditingController restController = TextEditingController(text: "30");

  Home({super.key});

  void _startWorkout(BuildContext context){
    var count = int.parse(countController.text);
    var restDuration = int.parse(restController.text);
    var workoutDuration = int.parse(workoutController.text);
    var lapsCount = int.parse(lapsCountController.text);
    var restLapsDuration = int.parse(restLapsController.text);
    var workout = Workout(workoutDuration, restDuration, lapsCount, restLapsDuration, count);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Counter(),
            settings: RouteSettings(arguments: workout)
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("COUNTER"),
        centerTitle: true,
        shadowColor: Colors.red,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: countController,
              decoration: const InputDecoration(
                  labelText: "Number of exercises"
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: workoutController,
              decoration: const InputDecoration(
                  labelText: "Workout duration per exercise (seconds)"
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: restController,
              decoration: const InputDecoration(
                  labelText: "Rest duration between each exercise (seconds)"
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lapsCountController,
              decoration: const InputDecoration(
                  labelText: "Laps count (at least 1)"
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: restLapsController,
              decoration: const InputDecoration(
                  labelText: "Rest duration between laps (seconds)"
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
                onPressed: (){_startWorkout(context);},
                child: const Text("Start Workout")
            )
          ],
        ),
      ),
    );
  }
}
