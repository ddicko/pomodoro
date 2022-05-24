import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/hidden_drawer.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pageDecoration = PageDecoration(
    titleTextStyle:
        const PageDecoration().titleTextStyle.copyWith(color: Colors.black),
    bodyTextStyle:
        const PageDecoration().titleTextStyle.copyWith(color: Colors.black),
    contentMargin: const EdgeInsets.all(10),
    // pageColor: Colors.red,
  );
  // late bool isFirstTime;
  bool? isFirstTime;

  @override
  void initState() {
    super.initState();
    checking();
  }

  checking() async {
    var prefs = await SharedPreferences.getInstance();
    var boolKey = 'isFirstTime';
    isFirstTime = prefs.getBool(boolKey);
    debugPrint("======<<>>:isFirstTime:$isFirstTime");
    if (isFirstTime == null) {
      setState(() {
        isFirstTime = true;
      });
      return isFirstTime;
    } else {
      setState(() {
        isFirstTime = false;
      });
      return isFirstTime;
    }
    // return isFirstTime;
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/images/online_Ad.png"),
          title: "Online Ads",
          body: "This is an online ad.",
          footer: const Text(
            "MTECHVIRAL",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/online_Ad.png"),
          title: "Online Ads",
          body: "This is an online ad.",
          footer: const Text(
            "MTECHVIRAL",
            style: TextStyle(color: Colors.black),
          ),
          decoration: pageDecoration),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.primaries.last,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: isFirstTime ?? true
              ? IntroductionScreen(
                  globalBackgroundColor: Colors.white,
                  pages: getPages(),
                  done: const Text(
                    "Done",
                    style: TextStyle(color: Colors.black),
                  ),
                  onDone: () async {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const HiddenDrawer()));
                    var prefs = await SharedPreferences.getInstance();
                    var boolKey = 'isFirstTime';
                    prefs.setBool(boolKey, false);
                    debugPrint("======<<second>>:isFirstTime:$isFirstTime");
                    setState(() {
                      isFirstTime = false;
                    });
                    debugPrint("------<<third>>:isFirstTime:$isFirstTime");
                  },
                  showNextButton: false,
                )
              : const HiddenDrawer(),
        ),
      ),
    );
  }
}
