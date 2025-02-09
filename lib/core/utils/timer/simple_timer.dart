import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

class SimpleTimer {
  final Duration calibrateTestDuration = Duration(minutes: 1);
  Duration _calibration = Duration(seconds: 1);

  // 校时方法
  void calibrate() {
    int timerCounter = 0;
    int timerCounterLimit = calibrateTestDuration.inSeconds;

    DateTime startTime = DateTime.now();

    Timer periodicTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      timerCounter++;

      if (timerCounter >= timerCounterLimit) {
        timer.cancel();

        // 这里获取实际结束时间
        DateTime endTime = DateTime.now();
        Duration diffTime = endTime.difference(startTime); // 实际运行的时间

        // 计算每次 Timer 运行的真实间隔
        double actualPerTick = diffTime.inMilliseconds / timerCounterLimit;

        // 计算需要多少次才能积累 1s 偏差
        double calibrationFactor = 1000 / actualPerTick;

        // 计算修正后的间隔
        _calibration = Duration(milliseconds: (1000 * calibrationFactor).round());
        
       printToConsole("${_calibration.inMilliseconds} ms");
      }
    });
  }
}
