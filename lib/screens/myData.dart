
// ignore_for_file: file_names

import 'dart:convert';

List<Score> scoresFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Score>.from(jsonData.map((x) => Score.fromJson(x)));
}

class Score {
  String examName;
  String subID;
  int tc;
  double qt;
  double th;
  double gk;
  double ck;
  double tb;

  Score({
    required this.examName,
    required this.subID,
    required this.tc,
    required this.qt,
    required this.th,
    required this.gk,
    required this.ck,
    required this.tb,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        examName: json["Exam_Name"],
        subID: json["Sub_ID"],
        tc: json["TC"],
        qt: json["QT"].toDouble(),
        th: json["TH"].toDouble(),
        gk: json["GK"].toDouble(),
        ck: json["CK"].toDouble(),
        tb: json["TB"].toDouble(),
      );

  toJson() {}
}
