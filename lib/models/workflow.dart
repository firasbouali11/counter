import 'package:counter/enums/workout_statuses.dart';
import 'package:counter/models/workout.dart';
import 'package:flutter/foundation.dart';

class Workflow{

  final int time;
  final WorkoutStatus status;
  Workflow? next;

  Workflow({required this.time, required this.status, this.next});


  static Workflow constructWorkflow(Workout workout) {
    Workflow? workflow = Workflow(time: workout.workoutDuration, status: WorkoutStatus.WORKOUT);
    Workflow? head = workflow;
    // Add the initial rest period if there is one
    if (workout.restDuration != 0) {
      head.next = Workflow(time: workout.restDuration, status: WorkoutStatus.REST);
      head = head.next;
    }
    // Create the workout/rest cycles for each lap
    for (int lap = 0; lap < workout.lapsCount; lap++) {
      int cycles = (lap == 0) ? workout.count - 1 : workout.count;
      for (int i = 0; i < cycles; i++) {
        head?.next = Workflow(time: workout.workoutDuration, status: WorkoutStatus.WORKOUT);
        head = head?.next;
        // Add rest if needed, except for the last cycle
        if (workout.restDuration != 0 && i < cycles - 1) {
          head?.next = Workflow(time: workout.restDuration, status: WorkoutStatus.REST);
          head = head?.next;
        }
      }
      // Add rest between laps if it's not the last lap
      if (workout.restLapsDuration != 0 && lap < workout.lapsCount - 1) {
        head?.next = Workflow(time: workout.restLapsDuration, status: WorkoutStatus.LAP_REST);
        head = head?.next;
      }
    }
    return workflow;
  }

  void printWorkflow(){
    if (kDebugMode) {
      Workflow? head = this;
      while(head != null){
        print("${head.status.text}: ${head.time}");
        head = head.next;
      }
    }
  }

}