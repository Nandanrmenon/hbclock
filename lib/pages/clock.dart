import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:analog_clock/analog_clock.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff394259),
      body: Center(
        child: AnalogClock(
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.transparent),
              color: Color(0xff546184),
              shape: BoxShape.circle),
          width: 250.0,
          isLive: true,
          hourHandColor: Colors.white,
          minuteHandColor: Colors.white,
          showSecondHand: true,
          secondHandColor: Theme.of(context).accentColor,
          numberColor: Colors.white,
          showNumbers: true,
          textScaleFactor: 1.4,
          showTicks: false,
          showDigitalClock: false,
        ),
      ),
    );
  }
}
