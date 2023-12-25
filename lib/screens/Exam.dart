// ignore_for_file: unused_import, recursive_getters, unused_field, prefer_final_fields, duplicate_ignore

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uitapp/screens/Examdata.dart';
import 'package:uitapp/screens/login_screen.dart';
import 'package:uitapp/screens/auth_service.dart';
import 'package:uitapp/screens/Home.dart';

class Exam extends StatefulWidget {
  const Exam({Key? key}) : super(key: key);

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
// ignore: unused_field
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 38, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Exam(),
    Home(),
    Text(
      'Index 1: Home',
      style: optionStyle,
    ),
  ];
  static const List<String> _title = <String>[
    'Exam',
    'Home',
  ];

  List<Examdata>? apiList;
  bool isLoading = true;
  String? token;
  @override
  void initState() {
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
            .map((item) => Examdata.fromJson(item))
            .toList()
            .cast<Examdata>();

        setState(() {
          isLoading = false;
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Exam Schedule',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
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
