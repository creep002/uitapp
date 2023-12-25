// ignore_for_file: file_names, unnecessary_this, unnecessary_new

class Examdata {
  String? examDay;
  String? caThi;
  String? subID;
  String? examSemester;
  String? room;

  Examdata(
      {this.examDay, this.caThi, this.subID, this.examSemester, this.room});

  Examdata.fromJson(Map<String, dynamic> json) {
    examDay = json['Exam_Day'];
    caThi = json['Ca_Thi'];
    subID = json['sub_ID'];
    examSemester = json['Exam_Semester'];
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Exam_Day'] = this.examDay;
    data['Ca_Thi'] = this.caThi;
    data['sub_ID'] = this.subID;
    data['Exam_Semester'] = this.examSemester;
    data['room'] = this.room;
    return data;
  }
}
