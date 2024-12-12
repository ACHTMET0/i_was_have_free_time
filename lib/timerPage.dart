import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CountdownPage extends StatefulWidget {
  CountdownPage({
    Key? key,
  }) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playAlarm();
      setState(() {
        isVisible = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHex();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  late bool isVisible = false;
  Color myColor = Colors.grey;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getHex() async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getInt('hex'));
    setState(() {
      myColor = new Color(prefs.getInt('hex')!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: CircularProgressIndicator(
                                color: Colors.white70,
                                backgroundColor: myColor,
                                value: progress,
                                strokeWidth: 6,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.isDismissed) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                      height: 300,
                                      child: CupertinoTimerPicker(
                                        initialTimerDuration:
                                            controller.duration!,
                                        onTimerDurationChanged: (time) {
                                          setState(() {
                                            controller.duration = time;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) => Text(
                                  countText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    if (controller.isAnimating) {
                                      controller.stop();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    } else {
                                      controller.reverse(
                                          from: controller.value == 0
                                              ? 1.0
                                              : controller.value);
                                      setState(() {
                                        isPlaying = true;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      radius: 30,
                                      child: Icon(
                                        isPlaying == true
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 36,
                                        color: myColor,
                                      ),
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  controller.reset();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    radius: 30,
                                    child: Icon(
                                      Icons.stop,
                                      size: 36,
                                      color: myColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isVisible,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  icon: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Press the button to stop the noticifation.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 40),
                            child: GestureDetector(
                                onTap: () {
                                  FlutterRingtonePlayer.stop();
                                  setState(() {
                                    isVisible = false;
                                  });
                                },
                                child: Icon(
                                  Icons.emoji_people_rounded,
                                  size: 120,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8BD0FD),
                          Color(0xFF88D7F7),
                          Color(0xFF83E7EE),
                          Color(0xFF83E7EE),
                          Color(0xFF80F9E4),
                          Color(0xFF80F9E4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
