import 'package:flutter/material.dart';
import 'dart:async';

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle =
      const TextStyle(fontSize: 50.0, color: Colors.white);
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class StopWatch extends StatefulWidget {
  StopWatch({Key key}) : super(key: key);

  StopWatchState createState() => new StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  final Dependencies dependencies = new Dependencies();
  List<String> _laps = new List<String>();
  List<String> _cummLaps = new List<String>();

  int _previousLap = 0;
  int _totalLapsed = 0;

  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsedMilliseconds}");
        setState(() {
          int _elapsed =
              dependencies.stopwatch.elapsedMilliseconds - _previousLap;
          _totalLapsed += _elapsed;
          _previousLap = dependencies.stopwatch.elapsedMilliseconds;
          _laps.add(convertTime(_elapsed));
          _cummLaps.add(convertTime(_totalLapsed));
        });
      } else {
        dependencies.stopwatch.reset();
        setState(() {
          _laps.clear();
        });
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  String convertTime(int timeInMilliseconds) {
    Duration timeDuration = Duration(milliseconds: timeInMilliseconds);
    int centiseconds = timeDuration.inMilliseconds ~/ 10;
    int seconds = timeDuration.inSeconds;
    int minutes = timeDuration.inMinutes;
    int hours = timeDuration.inHours;

    if (hours > 0) {
      return '$hours:$minutes:$seconds.$centiseconds';
    } else if (minutes > 0) {
      return '$minutes:$seconds.$centiseconds';
    } else {
      return '$seconds.$centiseconds';
    }
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 12.0, color: Colors.white);
    return new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.7,
        splashColor: Color(0xff394259),
        child: new Text(text, style: roundTextStyle),
        onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: new TimerText(dependencies: dependencies),
        ),
        new Expanded(
            child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _laps[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _cummLaps[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                  ListTile(
                    leading: Text('#' + '$index'),
                    title: Text(_laps[index]),
                  );
                })),
        new Expanded(
          flex: 0,
          child: new Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 60),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "Lap" : "Reset",
                    leftButtonPressed),
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "Stop" : "Start",
                    rightButtonPressed),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});

  final Dependencies dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});

  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new Hundreds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});

  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});

  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});

  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});

  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}
