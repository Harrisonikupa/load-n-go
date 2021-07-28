import 'dart:convert';

ModelOptions modelOptionsFromMap(String str) =>
    ModelOptions.fromMap(json.decode(str));

String modelOptionsToMap(ModelOptions data) => json.encode(data.toMap());

class ModelOptions {
  ModelOptions({
    this.computeTimeMilliseconds,
    this.lateHourlyPenaltyCents,
    this.nodeSlackTimeMinutes,
    this.performBreaks,
    this.timeWindows,
    this.workingTimeLimitMinutes,
    this.firstSolutionStrategy,
    this.localSearchMetaheuristic,
  });

  int? computeTimeMilliseconds;
  int? lateHourlyPenaltyCents;
  int? nodeSlackTimeMinutes;
  bool? performBreaks;
  String? timeWindows;
  int? workingTimeLimitMinutes;
  dynamic firstSolutionStrategy;
  dynamic localSearchMetaheuristic;

  factory ModelOptions.fromMap(Map<String, dynamic> json) => ModelOptions(
        computeTimeMilliseconds: json["compute_time_milliseconds"],
        lateHourlyPenaltyCents: json["late_hourly_penalty_cents"],
        nodeSlackTimeMinutes: json["node_slack_time_minutes"],
        performBreaks: json["perform_breaks"],
        timeWindows: json["time_windows"],
        workingTimeLimitMinutes: json["working_time_limit_minutes"],
        firstSolutionStrategy: json["first_solution_strategy"],
        localSearchMetaheuristic: json["local_search_metaheuristic"],
      );

  Map<String, dynamic> toMap() => {
        "compute_time_milliseconds": computeTimeMilliseconds,
        "late_hourly_penalty_cents": lateHourlyPenaltyCents,
        "node_slack_time_minutes": nodeSlackTimeMinutes,
        "perform_breaks": performBreaks,
        "time_windows": timeWindows,
        "working_time_limit_minutes": workingTimeLimitMinutes,
        "first_solution_strategy": firstSolutionStrategy,
        "local_search_metaheuristic": localSearchMetaheuristic,
      };
}
