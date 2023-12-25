// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uitapp/screens/auth_service.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  String? token = AuthService().token;

  Future<Account> fetchData() async {
    final response = await http.get(
      Uri.parse('http://26.100.34.245/user'),
      headers: {
        'Authorization': 'Bearer $token', // Thay thế 'Bearer' nếu cần
      },
    );

    if (response.statusCode == 200) {
      var jsons = json.decode(response.body);
      return Account.fromJson(jsons as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
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
                Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.1),
                    child: Image.asset(
                      'assets/images/image-1.png',
                      height: MediaQuery.of(context).size.height * 0.16,
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Image.asset(
                      'assets/images/Frame.png',
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                ]),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(59, 64, 210, 0.50),
                      ),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50.0, vertical: 4.0),
                    child: Text(
                      "Full name : ${data?.stuName ?? ''}",
                      style: const TextStyle(
                        color: Color.fromRGBO(59, 64, 210, 0.50),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Student ID : ${data?.stuID ?? ''}",
                  style: const TextStyle(
                    color: Color.fromRGBO(59, 64, 210, 0.50),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.2,
                  height: 1,
                  color: const Color.fromRGBO(59, 64, 210, 0.50),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.blue.shade900,
                            size: 32.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            data?.stuEmail ?? '',
                            style: const TextStyle(fontSize: 26.0),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromRGBO(59, 64, 210, 0.50),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.blue.shade900,
                            size: 32.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            data?.stuBirth ?? '',
                            style: const TextStyle(fontSize: 26.0),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.map,
                            color: Colors.blue.shade900,
                            size: 32.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            data?.stuAddress ?? '',
                            style: const TextStyle(fontSize: 26.0),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.view_column,
                            color: Colors.blue.shade900,
                            size: 32.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            data?.stuMajority ?? '',
                            style: const TextStyle(fontSize: 26.0),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Text('No data available.');
          }
        }
      },
    );
  }
}

class Account {
  String? stuID;
  String? stuName;
  String? stuBirth;
  String? stuMajority;
  String? stuEmail;
  String? stuAddress;

  Account(
      {this.stuID,
      this.stuName,
      this.stuBirth,
      this.stuMajority,
      this.stuEmail,
      this.stuAddress});

  Account.fromJson(Map<String, dynamic> json) {
    stuID = json['Stu_ID'];
    stuName = json['Stu_name'];
    stuBirth = json['Stu_Birth'];
    stuMajority = json['Stu_Majority'];
    stuEmail = json['Stu_Email'];
    stuAddress = json['Stu_Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Stu_ID'] = stuID;
    data['Stu_name'] = stuName;
    data['Stu_Birth'] = stuBirth;
    data['Stu_Majority'] = stuMajority;
    data['Stu_Email'] = stuEmail;
    data['Stu_Address'] = stuAddress;
    return data;
  }
}
