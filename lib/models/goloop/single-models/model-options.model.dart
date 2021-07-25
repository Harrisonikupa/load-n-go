class ModelOptions {
  ModelOptions({
    this.computeTimeMilliseconds,
    this.lateHourlyPenaltyCents,
    this.workingTimeLimitMinutes,
    this.timeWindows,
  });

  int? computeTimeMilliseconds;
  int? lateHourlyPenaltyCents;
  int? workingTimeLimitMinutes;
  String? timeWindows;

  factory ModelOptions.fromMap(Map<String, dynamic> json) => ModelOptions(
        computeTimeMilliseconds: json["compute_time_milliseconds"],
        lateHourlyPenaltyCents: json["late_hourly_penalty_cents"],
        workingTimeLimitMinutes: json["working_time_limit_minutes"],
        timeWindows: json["time_windows"],
      );

  Map<String, dynamic> toMap() => {
        "compute_time_milliseconds": computeTimeMilliseconds,
        "late_hourly_penalty_cents": lateHourlyPenaltyCents,
        "working_time_limit_minutes": workingTimeLimitMinutes,
        "time_windows": timeWindows,
      };
}
