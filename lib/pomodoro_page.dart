import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
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

  var formatNumber = NumberFormat("00");

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
          flushbar();
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

  Flushbar flushbar() {
    return Flushbar(
      title: "Hey Ninja",
      titleColor: Colors.white,
      message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: const [BoxShadow(color: Color.fromARGB(255, 16, 80, 2), offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: const LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: const Duration(minutes: 5),
      icon: const Icon(
        Icons.check,
        color: Colors.greenAccent,
      ),
      mainButton: FlatButton(
        onPressed: () {},
        child: const Text(
          "Start",
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.red,
      titleText: Text(
        "Hello Hero",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: const Text(
        "You killed that giant monster in the city. Congratulations!",
        style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff62696E), Color(0xff62696E)],
          begin: FractionalOffset(0.6, 0.3),
        ),
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //TODO: add text for motivation
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("Les distractions sont un des pires destructeurs de reves."),
          ),
          const SizedBox(
            height: 50.0,
          ),
          _displayingTime(),
          const SizedBox(
            height: 100.0,
          ),
          _startOrstopButton(_minutes, _seconds, "Start"),
          const SizedBox(
            height: 20.0,
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
          inProgress ? "Reset" : text,
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
                "${formatNumber.format(_minutes)} : ${formatNumber.format(_seconds)}",
                style:
                    const TextStyle(color: Color.fromARGB(213, 9, 9, 9), fontSize: 40.0, fontWeight: FontWeight.w300),
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
