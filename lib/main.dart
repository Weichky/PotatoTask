import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("倒计时示例")),
        body: Center(
          child: TimerCountdown(
            format: CountDownTimerFormat.minutesSeconds,
            endTime: DateTime.now().add(const Duration(seconds: 10)), // 10秒倒计时
            onEnd: () => print("倒计时结束！"),
          ),
        ),
      ),
    );
  }
}
