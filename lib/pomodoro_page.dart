import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  Timer? _timer;
  int _seconds = 0;
  int _minutes = 25;

  _startTimer() {
    // _timer!.cancel();
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
      });
    });
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _displayingTime(),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                        Expanded(
                          child: Column(
                            children: const <Widget>[
                              Text(
                                "Study Time",
                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "25",
                                style: TextStyle(fontSize: 50.0, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 80,
                        ),
                        Expanded(
                          child: Column(
                            children: const <Widget>[
                              Text(
                                "Pause Time",
                                style: TextStyle(fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "25",
                                style: TextStyle(fontSize: 50.0, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _startTimer();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "Start Studying",
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _displayingTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        percent: 0.1,
        animation: true,
        animateFromLastPercent: true,
        radius: 80.0,
        lineWidth: 10.0,
        progressColor: Colors.white,
        center: Text(
          "$_minutes : $_seconds",
          style: const TextStyle(color: Color.fromARGB(213, 9, 9, 9), fontSize: 40.0),
        ),
      ),
    );
  }
}
