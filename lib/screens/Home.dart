// ignore_for_file: unused_import, unnecessary_import

import 'dart:ui';
import 'package:uitapp/screens/calendar.dart';
import 'package:uitapp/screens/Notifications.dart';
import 'package:uitapp/screens/Personal.dart';
import 'package:uitapp/screens/tuitionfee.dart';
import 'package:flutter/material.dart';
import 'package:uitapp/screens/transcipt.dart';
import 'package:uitapp/screens/deadline.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

  static fromJson(x) {}
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Calendar(),
    Transcript(),
    TuiTionFeeView(),
    Deadline(),
    Personal(),
    Text(
      'Index 3: Home',
      style: optionStyle,
    ),
    Personal(),
  ];

  static const List<String> _title = <String>[
    'Calendar',
    'Transcipt',
    'Tuition Fee',
    'Deadline',
    'Personal'
  ];

  /* void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        appBar: AppBar(
            title: Center(
              child: Text(
                _title.elementAt(_selectedIndex),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()),
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
            backgroundColor: Colors.blue.shade800),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.timer),
                label: ('Calendar'),
                backgroundColor: Colors.blue.shade800),
            BottomNavigationBarItem(
                icon: const Icon(Icons.score),
                label: ('Transcipt'),
                backgroundColor: Colors.blue.shade800),
            BottomNavigationBarItem(
                icon: const Icon(Icons.euro),
                label: ('Tuition Fee'),
                backgroundColor: Colors.blue.shade800),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month),
                label: ('Deadline'),
                backgroundColor: Colors.blue.shade800),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: ('Person'),
                backgroundColor: Colors.blue.shade800),
          ],
          currentIndex: _selectedIndex,
        ));
  }
}
