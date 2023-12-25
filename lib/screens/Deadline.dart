// ignore_for_file: unused_import, recursive_getters, avoid_print, prefer_const_constructors, unnecessary_this

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uitapp/screens/login_screen.dart';
import 'package:uitapp/screens/auth_service.dart';
import 'package:intl/intl.dart';

class Deadline extends StatefulWidget {
  const Deadline({Key? key}) : super(key: key);

  @override
  State<Deadline> createState() => _DeadlineState();
}

class _DeadlineState extends State<Deadline> {
  List<Deadlinedata>? apiList;
  String? token;
  late DateTime currentDate;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = AuthService().token;
    currentDate = DateTime.now();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://26.100.34.245/deadline'),
        headers: {
          //'Authorization': 'Bearer $token',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTdHVfSUQiOiIyMTUyMTc0MiJ9.SHaeO2H9K29gNtHaNWs6qlWv7vocn5EVZQGF_kLhAFE',
        },
      );

      if (response.statusCode == 200) {
        apiList = jsonDecode(response.body)
            .map((item) => Deadlinedata.fromJson(item))
            .toList()
            .cast<Deadlinedata>();
        setState(() {
          isLoading = false;
        });
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch data. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: apiList!.length,
        itemBuilder: (BuildContext context, int index) {
          bool isStillWaiting =
              apiList![index].timeDeadline!.isAfter(currentDate);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book),
                          //SizedBox(width: 8.0),
                          Text(' ${apiList![index].subID}'),
                        ],
                      ), //Mã  môn học
                      Row(
                        children: [
                          Icon(Icons.calendar_month_sharp),
                          //SizedBox(width: 9.0),
                          Text(' ${apiList![index].deadlineName}'),
                        ],
                      ), // Tên môn học
                      Row(
                        children: [
                          if (apiList![index].deadlineStatus?.length == 9) ...[
                            Icon(Icons.assignment_turned_in),
                            Text(' ${apiList![index].deadlineStatus}'),
                          ] else ...[
                            Icon(Icons.assignment_turned_in_outlined),
                            Text(' ${apiList![index].deadlineStatus}'),
                          ]
                        ],
                      ), // Tình trạng nộp bài
                      Row(
                        children: [
                          Icon(Icons.access_time),
                          // Use a custom formatting function to exclude milliseconds
                          Text(
                              ' ${formatDateTimeWithoutMilliseconds(apiList![index].timeDeadline)}'),
                        ],
                      ), // deadline môn học
                      Row(
                        children: [
                          // Check if deadlineStatus is not null and its length is equal to 9
                          if (isStillWaiting) ...[
                            // If the condition is true, display a timer icon and text
                            Icon(Icons.timer_outlined),
                            Text(' Still waiting'),
                          ] else ...[
                            // If the condition is false, display a different icon and text
                            Icon(Icons.timer_off_rounded),
                            Text(' Expire'),
                          ],
                        ],
                      ), // còn hạn-hết hạn
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String formatDateTimeWithoutMilliseconds(DateTime? dateTime) {
  if (dateTime != null) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  } else {
    return ''; // Or another default value if dateTime is null
  }
}

class Deadlinedata {
  String? subID;
  String? deadlineName;
  DateTime? timeDeadline;
  String? deadlineStatus;

  Deadlinedata({
    this.subID,
    this.deadlineName,
    this.timeDeadline, // Make it nullable
    this.deadlineStatus,
  });

  Deadlinedata.fromJson(Map<String, dynamic> json) {
    subID = json['Sub_ID'];
    deadlineName = json['Deadline_Name'];
    timeDeadline = json['Time_Deadline'] != null
        ? DateTime.parse(json['Time_Deadline'])
        : null;
    deadlineStatus = json['Deadline_Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Sub_ID'] = this.subID;
    data['Deadline_Name'] = this.deadlineName;
    data['Time_Deadline'] = this.timeDeadline != null
        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(this.timeDeadline!)
        : null;
    data['Deadline_Status'] = this.deadlineStatus;
    return data;
  }
}
