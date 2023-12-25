// ignore_for_file: unused_import

import 'package:uitapp/screens/Notifications.dart';
import 'package:uitapp/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uitapp/screens/auth_service.dart';

class TuiTionFeeView extends StatefulWidget {
  const TuiTionFeeView({super.key});

  @override
  State<TuiTionFeeView> createState() => _TuiTionFeeViewState();
}

class _TuiTionFeeViewState extends State<TuiTionFeeView> {
  List<Fee>? apiList;
  // bool isLoading = true;
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = AuthService().token;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://26.100.34.245/exam'),
        headers: {
          'Authorization': 'Bearer $token', // Thay thế 'Bearer' nếu cần
        },
      );

      if (response.statusCode == 200) {
        apiList = jsonDecode(response.body)
            .map((item) => Fee.fromJson(item))
            .toList()
            .cast<Fee>();

        setState(() {
          // isLoading = false;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return Scaffold(
      body: ListView.builder(
        itemCount: apiList!.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                    child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Exam : ${apiList![index].examSemester}'),
                      Text('Exam Date: ${apiList![index].examDay}'),
                      Text('Exam ID: ${apiList![index].subID}'),
                      Text('Exam Shift: ${apiList![index].caThi}'),
                      Text('Exam Room: ${apiList![index].room}'),

                      // Add more Text widgets for other properties as needed
                    ],
                  ),
                ))
              ]);
        },
      ),
    );
  }
}

class Fee {
  String? examDay;
  String? caThi;
  String? subID;
  String? examSemester;
  String? room;

  Fee({this.examDay, this.caThi, this.subID, this.examSemester, this.room});

  Fee.fromJson(Map<String, dynamic> json) {
    examDay = json['Exam_Day'];
    caThi = json['Ca_Thi'];
    subID = json['sub_ID'];
    examSemester = json['Exam_Semester'];
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Exam_Day'] = examDay;
    data['Ca_Thi'] = caThi;
    data['sub_ID'] = subID;
    data['Exam_Semester'] = examSemester;
    data['room'] = room;
    return data;
  }
}
