import 'package:flutter/material.dart';
import 'package:hbclock/pages/clock.dart';
import 'package:hbclock/pages/stopwatch.dart';
import 'package:hbclock/pages/timer.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 100), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff394259),
      appBar: AppBar(
        backgroundColor: Color(0xff394259),
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: new PageView(
        children: [
          new Clock(),
          new TimerPage(),
          new StopWatch(),
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff394259),
        elevation: 0.0,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time,), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_bottom),label: ""),
        ],
        onTap: navigationTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
