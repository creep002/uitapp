// ignore_for_file: prefer_const_constructors, unused_import, avoid_print, use_build_context_synchronously, valid_regexps

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uitapp/screens/Notifications.dart';
import 'package:intl/intl.dart';
import 'package:uitapp/screens/auth_service.dart';
import 'package:uitapp/screens/Exam.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Calendardata>? apiList; // Danh sách thời khóa biểu
  late DateTime currentDate;
  late DateTime chosenDate;
  late DateTime circleDate;

  String? token;
  //bool isLoading = true;
  int expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    token = AuthService().token;
    currentDate = DateTime.now();
    chosenDate = currentDate;
    circleDate = currentDate;
    fetchData(chosenDate: chosenDate);
  }

  List<DateTime> getWeekDays(DateTime currentDate) {
    int currentWeekday = currentDate.weekday;
    DateTime startingDate =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    //DateTime endingDate = startingDate.add(Duration(days: 5));

    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(startingDate.add(Duration(days: i)));
    }

    return weekDays;
  }

  Future<void> fetchData({required DateTime chosenDate}) async {
    // Lấy thứ trong tuần của chosenDate
    final dayOfWeek = chosenDate.weekday;

    try {
      final response = await http.get(
        Uri.parse(
            'http://26.100.34.245/class-schedule/${_getDayOfWeek(dayOfWeek)}/${DateFormat('yyyy-MM-dd').format(chosenDate)}'),
        headers: {
          /* 'Authorization': 'Bearer $token', */
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTdHVfSUQiOiIyMTUyMTc0MyJ9.5e8ZnLgI6l3UTQ7D7FFh9eOe6XmktG83-jBr6ZYuHIc',
        },
      );

      if (response.statusCode == 200) {
        apiList = jsonDecode(response.body)
            .map((item) => Calendardata.fromJson(item))
            .toList()
            .cast<Calendardata>();
        setState(() {});
      } else {
        setState(() {
          expandedIndex = 1;
        });
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* IconButton(
                onPressed: () {
                  setState(() {
                    currentDate = currentDate.subtract(Duration(days: 7));
                  });
                },
                icon: Icon(Icons.arrow_back),
              ), */
          Text(
            "${DateFormat.MMMM().format(currentDate)}/${currentDate.year}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          /* IconButton(
                onPressed: () {
                  setState(() {
                    currentDate = currentDate.add(Duration(days: 7));
                  });
                },
                icon: Icon(Icons.arrow_forward),
              ), */
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var day in getWeekDays(currentDate))
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    debugPrint(
                        'Tapped on ${_getDayOfWeek(chosenDate.weekday)}'); //Hiển thị ấn vào thứ (giá trị day dạng chữ 'Mon')

                    setState(() {
                      //chosenDate = day;
                      print(
                          '${_getDayOfWeek(chosenDate.weekday)} button clicked 111');
                    });
                  },
                  child: Text(
                    //highlight thứ hiện tại
                    DateFormat.E().format(day),
                    style: TextStyle(
                      fontWeight: day.weekday == currentDate.weekday
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: day.weekday == currentDate.weekday
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // ignore: unrelated_type_equality_checks
                    if (day == 'Sun') {
                      setState(() {
                        expandedIndex = 1; // Set expandedIndex to -1 for Sunday
                        circleDate = day;
                      });
                    } else {
                      debugPrint(//hiện ngày
                          'Tapped number ${day.day}');
                      setState(() {
                        chosenDate = day; //chọn ngày được hay ko ở đây
                        circleDate = day;
                        print('$chosenDate button clicked');
                      });
                      // Gọi fetchData với chosenDate mới trước khi hiển thị showModalBottomSheet và then để khi mà fetchData xong thì nó mới show
                      fetchData(chosenDate: chosenDate).then((_) {
                        if (apiList?.isEmpty == true) {
                          expandedIndex = 1;
                        } else {
                          expandedIndex = -1;
                        }
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Vòng tròn cho ngày hiện tại
                      if (currentDate.day == day.day)
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 33, 150,
                                  243), // Chọn màu cho vòng tròn outline
                              width: 1.5, // độ dày của vòng tròn
                            ),
                          ),
                        ),
                      // Circle for ChosenDate
                      if (chosenDate.day == day.day)
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 9, 103, 180), //chinh mau
                          ),
                        ),
                      Positioned(
                        child: Text(
                          DateFormat('d').format(day), //hiển thị ngày
                          style: TextStyle(
                            fontSize: 18,
                            color: circleDate.day == day.day
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      Divider(
        //Dấu gạch ngang
        height: 20,
        thickness: 2,
        color: Colors.grey.shade700, // Set the color of the divider
      ),
      InkWell(
        onTap: () {
          // Navigate to the Exam Schedule page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Exam()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border(
              left: BorderSide(
                color: Colors.green, // Màu xanh lá cây cho cạnh bên trái
                width: 5.0, // Độ rộng của cạnh bên trái
              ),
              top: BorderSide(
                color: Colors.grey, // Màu xám cho các cạnh khác (nếu có)
              ),
              right: BorderSide(
                color: Colors.grey, // Màu xám cho các cạnh khác (nếu có)
              ),
              bottom: BorderSide(
                color: Colors.grey, // Màu xám cho các cạnh khác (nếu có)
              ),
            ),
          ),
          padding: EdgeInsets.all(5),
          child: Text(
            'Exam Schedule',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      if (expandedIndex == -1)
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: apiList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final item = apiList![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons
                                  .account_circle_rounded), // Icon for tiet
                              SizedBox(width: 5),
                              Text('Class: ${item.subID ?? ''}'),
                            ],
                          ),
                          Divider(endIndent: 20),
                          Row(
                            children: [
                              Icon(Icons.access_time), // Icon for tiet
                              SizedBox(width: 5),
                              Text(
                                  'Time: ${item.thu ?? ''}, T${item.tiet ?? ''}, P ${item.room ?? ''}'),
                            ],
                          ),
                          Divider(endIndent: 20), // Divider under tiet
                          Row(
                            children: [
                              Icon(Icons.person), // Icon for teachername
                              SizedBox(width: 5),
                              Text(
                                'Teacher: ${item.teachername?.replaceAll(RegExp(r'[(),]'), '') ?? ''}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Divider(endIndent: 20), // Divider under teachername
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.grey.shade500,
                    ), // Extra divider
                  ],
                );
              },
            ),
          ),
        ),
      if (expandedIndex != -1)
        Expanded(
            child: Center(
          child: Text(
            'KHONG CO DU LIEU ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ))
    ]));
  }
}

// Hàm để lấy tên ngày trong tuần từ số thứ tự (1-7)
String _getDayOfWeek(int dayOfWeek) {
  switch (dayOfWeek) {
    case DateTime.monday:
      return 'Mon'; //trả về "Mon"
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '';
  }
}

// Hàm để lấy số ngày trong tuần 1-7
int dayIndexFromAbbreviation(String abbreviation) {
  switch (abbreviation) {
    case 'Mon':
      return DateTime.monday; // trả về 1
    case 'Tue':
      return DateTime.tuesday;
    case 'Wed':
      return DateTime.wednesday;
    case 'Thu':
      return DateTime.thursday;
    case 'Fri':
      return DateTime.friday;
    case 'Sat':
      return DateTime.saturday;
    case 'Sun':
      return DateTime.sunday;
    default:
      return 0;
  }
}

class Calendardata {
  String? subID;
  String? thu;
  String? tiet;
  String? teachername;
  String? room;

  Calendardata({this.subID, this.thu, this.tiet, this.teachername, this.room});

  Calendardata.fromJson(Map<String, dynamic> json) {
    subID = json['Sub_ID'];
    thu = json['thu'];
    tiet = json['Tiet'];
    teachername = json['Tea_Name']?.replaceAll(RegExp(r'[(),]'), '');
    room = json['Room'];
  }

  /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Sub_ID'] = subID;
    data['thu'] = thu;
    data['Tiet'] = tiet;
    data['Tea_Name'] = teachername;
    data['Room'] = room;
    return data;
  } */
}
