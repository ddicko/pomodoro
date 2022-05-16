import 'dart:async';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  Color bgcLightTop = const Color(0xffD7DFE4);
  Color bgcDarkTop = const Color(0xff62696E);
  Color bgcLightBottom = const Color(0xff7A7886);
  Color bgcDarkBottom = const Color(0xff2A1D29);

  bool inProgress = false;

  Color textcLight = const Color(0xff2A1D29);
  Color textcDark = const Color(0xff2A1D29);

  Timer? _timer;
  int _seconds = 0;
  int _minutes = 25;

  var f = NumberFormat("00");

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _seconds = 0;
      _minutes = 25;
    }
  }

  _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    if (_minutes > 0) {
      _seconds = _minutes * 60;
    }
    if (_seconds > 60) {
      _minutes = (_seconds / 60).floor();
      _seconds -= (_minutes * 60);
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _seconds = 59;
            _minutes--;
          } else {
            debugPrint("Timer Complete!");
            _timer!.cancel();
          }
        }
        if (_minutes == 0 && _seconds == 0) {
          _timer!.cancel();
          _seconds = 0;
          _minutes = 25;
          inProgress = false;
          const snackBar = SnackBar(content: Text("vous meritez bien une pause !"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    });
    if (_timer?.isActive == false) {
      setState(() {
        _stopTimer();
        inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1542bf), Color(0xff51a8ff)],
          begin: FractionalOffset(0.5, 1),
        ),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _displayingTime(),
          const SizedBox(
            height: 20.0,
          ),
          _startOrstopButton(_minutes, _seconds, "Start"),
          const SizedBox(
            height: 70.0,
          ),
        ],
      ),
    );
  }

  ElevatedButton _startOrstopButton(int _minutes, int _seconds, String text) {
    return ElevatedButton(
      onPressed: () {
        if (_minutes > 0) {
          _startTimer();
          setState(() {
            inProgress = true;
          });
        }
        if (_minutes != 0 && _seconds != 0) {
          setState(() {
            _stopTimer();
            inProgress = false;
          });
        } else {
          debugPrint("Hello solo, he is in progress ...!");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          inProgress ? "stop" : text,
          style:
              const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _displayingTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _plusOrMoinsIcon(icon: const Icon(Icons.minimize_outlined), isPlus: false),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              percent: 0.1,
              animation: true,
              animateFromLastPercent: true,
              radius: 80.0,
              lineWidth: 15.0,
              progressColor: const Color(0xFFB8C7CB),
              center: Text(
                "${f.format(_minutes)} : ${f.format(_seconds)}",
                style: const TextStyle(color: Color.fromARGB(213, 9, 9, 9), fontSize: 40.0),
              ),
            ),
          ),
          _plusOrMoinsIcon(icon: const Icon(Icons.add), isPlus: true)
        ],
      ),
    );
  }

  IconButton _plusOrMoinsIcon({required Icon icon, required bool isPlus}) {
    return IconButton(
      onPressed: () {
        if (isPlus) {
          setState(() {
            _minutes++;
          });
        } else {
          setState(() {
            if (_minutes > 0) {
              _minutes--;
            }
          });
        }
      },
      icon: icon,
    );
  }
}
