enum WorkoutStatus {
  WORKOUT,
  REST,
  LAP_REST;

  String get text {
    switch(this){
      case WorkoutStatus.WORKOUT:
        return "Workout";
      case WorkoutStatus.REST:
        return "Rest";
      case WorkoutStatus.LAP_REST:
        return "Lap Rest";
    }
  }
}