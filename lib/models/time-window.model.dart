class TimeWindow {
  TimeWindow({
    this.earliest,
    this.latest,
  });

  int? earliest;
  int? latest;

  factory TimeWindow.fromMap(Map<String, dynamic> json) => TimeWindow(
        earliest: json["earliest"],
        latest: json["latest"],
      );

  Map<String, dynamic> toMap() => {
        "earliest": earliest,
        "latest": latest,
      };
}
