import 'dart:async';
import 'package:potato_task/core/utils/timer/timer_type.dart';

import 'timer_calibrator.dart';
import 'timer_engine.dart';

class SimpleTimer {
  final Duration _defaultDriftAccumulationTime = Duration(seconds: 300);

  Duration _driftAccumulationTime;

  bool _isAutoCalibrate;

  TimerEngine? _timerEngine;

  SimpleTimer({
    Duration? driftAccumulationTime,
  }) :
    _driftAccumulationTime = driftAccumulationTime ?? Duration.zero,
    _isAutoCalibrate = driftAccumulationTime == null {
        if (_isAutoCalibrate) {
          _driftAccumulationTime = _defaultDriftAccumulationTime;
        }
      }

  Future<void> create({
    required TimerType type,
    Duration? duration,
  }) async {
    if (_timerEngine != null) {
      delete();
    }

    if (_isAutoCalibrate) {
      TimerCalibrator timerCalibrator =TimerCalibrator();
      _driftAccumulationTime = await timerCalibrator.calibrate();
    }

    _timerEngine = TimerEngine(
      type: type,
      totalDuration: duration,
    );
  }

  void delete() {
    if (_timerEngine == null) {
      return;
    } else if (_timerEngine!.isRunning == true) {
      _timerEngine!.abort();
    }
  }

  void stop() {

  }

  void setAutoCalibrate() {
    _isAutoCalibrate = true;
    _driftAccumulationTime = _defaultDriftAccumulationTime;
  }

  void setFixedCalibrate(Duration time) {
    _isAutoCalibrate = false;
    _driftAccumulationTime = time;
  }
}