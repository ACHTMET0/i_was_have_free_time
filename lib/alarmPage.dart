import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class alarmPage extends StatefulWidget {
  const alarmPage({Key? key}) : super(key: key);

  @override
  State<alarmPage> createState() => _alarmPageState();
}

class _alarmPageState extends State<alarmPage> {
  Color myColor = Colors.grey;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getHex() async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getInt('hex'));
    setState(() {
      myColor = new Color(prefs.getInt('hex')!);
    });
  }

  void initState() {
    super.initState();
    getHex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
