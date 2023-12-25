// ignore_for_file: file_names, unnecessary_new, unnecessary_this, prefer_collection_literals

class DataNotifi {
  List<Noti>? noti;
  
  DataNotifi({this.noti});

  DataNotifi.fromJson(Map<String, dynamic> json) {
    if (json['Noti'] != null) {
      noti = <Noti>[];
      json['Noti'].forEach((v) {
        noti!.add(new Noti.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.noti != null) {
      data['Noti'] = this.noti!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Noti {
  String? notifyName;
  String? notifyNoiDung;

  Noti({this.notifyName, this.notifyNoiDung});

  Noti.fromJson(Map<String, dynamic> json) {
    notifyName = json['Notify_Name'];
    notifyNoiDung = json['Notify_NoiDung'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Notify_Name'] = this.notifyName;
    data['Notify_NoiDung'] = this.notifyNoiDung;
    return data;
  }
}
