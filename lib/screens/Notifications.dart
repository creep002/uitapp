// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uitapp/screens/DataNotifi.dart';
import 'package:uitapp/screens/auth_service.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<DataNotifi>? apiList;
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
        Uri.parse('http://26.100.34.245/Notification'),
        headers: {
          'Authorization': 'Bearer $token', // Thay thế 'Bearer' nếu cần
        },
      );

      if (response.statusCode == 200) {
        apiList = jsonDecode(response.body)
            .map((item) => DataNotifi.fromJson(item))
            .toList()
            .cast<DataNotifi>();

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
    List<String> generateList(DataNotifi dataNotifi) {
      List<String> list = [];
      for (var noti in dataNotifi.noti!) {
        list.add("${noti.notifyName} - ${noti.notifyNoiDung}");
      }
      return list;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Notification",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/notification.png',
                width: 28,
                height: 28,
              ),
            ),
          )
        ],
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView.builder(
        itemCount: apiList!.length,
        itemBuilder: (BuildContext context, int index) {
          String generateTitle(DataNotifi dataNotifi) {
            return dataNotifi.noti!
                .map((noti) => "${noti.notifyName}")
                .join(', ');
          }

          String generateSubtitle(DataNotifi dataNotifi) {
            return dataNotifi.noti!
                .map((noti) => "${noti.notifyNoiDung}")
                .join(', ');
          }

          return Card(
            child: ListTile(
              //title: Text(_generateTitle(apiList![index])),

              subtitle: Column(
                //Text(_generateList(apiList![index]).join('\n')),

                children: generateList(apiList![index]).map((text) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black, // Adjust the color of the border
                          width: 1.0, // Adjust the width of the border
                        ),
                      ),
                    ),
                    child: Text(text),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
