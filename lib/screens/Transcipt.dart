// ignore_for_file: unused_import, unnecessary_this, unnecessary_new

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitapp/screens/Notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:uitapp/screens/auth_service.dart';

class Transcript extends StatefulWidget {
  const Transcript({super.key});

  @override
  State<Transcript> createState() => _TranscriptState();
}

class _TranscriptState extends State<Transcript> {
  String? token = AuthService().token;
  String semesterValue =
      "X"; // Thay thế "X" bằng giá trị thực tế từ dữ liệu API
  String schoolYearValue =
      "Y"; // Thay thế "Y" bằng giá trị thực tế từ dữ liệu API
  Future<ListTranScritpt> fetchData() async {
    final response = await http.get(
      Uri.parse('http://26.100.34.245/result'),
      headers: {
        'Authorization': 'Bearer $token', // Thay thế 'Bearer' nếu cần
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ListTranScritpt.fromJson(jsonData as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

//write a flutter code to convert JSON about object?

  @override
  Widget build(BuildContext context) {
    TextStyle titles = const TextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    );

    return Center(
      //child:  Padding(padding:  const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: [
        //),
        FutureBuilder<ListTranScritpt>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                // ignore: unused_local_variable
                final data = snapshot.data;
                return Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        width: 308,
                        height: 25,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF262DE1),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              color:
                                  Colors.black.withOpacity(0.30000001192092896),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: SizedBox(
                          width: 287,
                          height: 25,
                          child: Text(
                            'Score: Semester ${snapshot.data?.semester?.semester ?? 'X'}, School year ${snapshot.data?.semester?.year ?? 'Y'} ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        )),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              'CLASS',
                              style: titles,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TC',
                              style: titles,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'QT',
                              style: titles,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TH',
                              style: titles,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'GK',
                              style: titles,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'CK',
                              style: titles,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'TB',
                              style: titles,
                            ),
                          ),
                        ],
                        rows: (snapshot.data?.score ?? []).map((item) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text('${item.subID}')),
                              DataCell(Text(item.tC.toString())),
                              DataCell(Text((item.qT as double).toString())),
                              DataCell(Text((item.tH as double).toString())),
                              DataCell(Text((item.gK as double).toString())),
                              DataCell(Text((item.cK as double).toString())),
                              DataCell(Text((item.tB as double).toString())),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return const Text('No data available.');
              }
            }
          },
        )
      ]),
    );
  }
}

class ListTranScritpt {
  Semester? semester;
  List<Score>? score;

  ListTranScritpt({this.semester, this.score});

  ListTranScritpt.fromJson(Map<String, dynamic> json) {
    semester = json['semester'] != null
        ? new Semester.fromJson(json['semester'])
        : null;
    if (json['score'] != null) {
      score = <Score>[];
      json['score'].forEach((v) {
        score!.add(new Score.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.semester != null) {
      data['semester'] = this.semester!.toJson();
    }
    if (this.score != null) {
      data['score'] = this.score!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Semester {
  String? semester;
  String? year;

  Semester({this.semester, this.year});

  Semester.fromJson(Map<String, dynamic> json) {
    semester = json['Semester'];
    year = json['Year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Semester'] = this.semester;
    data['Year'] = this.year;
    return data;
  }
}

class Score {
  String? subID;
  num? tC;
  num? qT;
  num? tH;
  num? gK;
  num? cK;
  num? tB;

  Score({this.subID, this.tC, this.qT, this.tH, this.gK, this.cK, this.tB});

  Score.fromJson(Map<String, dynamic> json) {
    subID = json['Sub_ID'];
    tC = json['TC'];
    qT = json['QT'];
    tH = json['TH'];
    gK = json['GK'];
    cK = json['CK'];
    tB = json['TB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Sub_ID'] = this.subID;
    data['TC'] = this.tC;
    data['QT'] = this.qT;
    data['TH'] = this.tH;
    data['GK'] = this.gK;
    data['CK'] = this.cK;
    data['TB'] = this.tB;
    return data;
  }
}
