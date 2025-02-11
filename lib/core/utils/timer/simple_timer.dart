import 'dart:async';
import 'package:potato_task/core/utils/timer/timer_type.dart';

import 'timer_calibrator.dart';
import 'timer_engine.dart';

class SimpleTimer {
  final Duration _defaultDriftAccumulationTime = Duration(seconds: 300);

  Duration _driftAccumulationTime;

  bool _isAutoCalibrate;
  bool _isCalibrating;

  TimerEngine? _timerEngine;
  TimerCalibrator? _timerCalibrator;

  SimpleTimer({
    Duration? driftAccumulationTime,
  }) :
    _driftAccumulationTime = driftAccumulationTime ?? Duration.zero,
    _isCalibrating = false,
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
      _isCalibrating = true;
      _timerCalibrator =TimerCalibrator();

      _timerCalibrator!.fetchDrift().then((drift) {
        _driftAccumulationTime = drift;
        _isCalibrating = false;
        _timerCalibrator = null;
      });
    }

    _timerEngine = TimerEngine(
      type: type,
      totalDuration: duration,
    );
  }

  void delete() {
    if (_timerEngine == null) {
      return;
    } else if (_timerEngine!.isRunning) {
      stop();
    }

    _timerEngine = null;
  }

  void stop() {
    if (_timerEngine == null) {
      return;
    } else if (!_timerEngine!.isRunning) {
      return;
    } else {
        _timerEngine!.abort();
    }
  }

  void start() {
    if (_timerEngine == null) {
    throw StateError('You must call create() before calling start().');
    }

    _timerEngine!.start();
  }

  void setAutoCalibrate() {
    _isAutoCalibrate = true;
    _driftAccumulationTime = _defaultDriftAccumulationTime;
  }

  void setFixedCalibrate(Duration time) {
    _isAutoCalibrate = false;
    _driftAccumulationTime = time;
  }


  Future<void> _calibrate() {
    Timer timer;
    Duration driftAccumulationTime = _driftAccumulationTime;
    if (_isAutoCalibrate) {
      if (_isCalibrating) {
        Timer(_timerCalibrator!.testDuration, () {

        });


        timer = Timer.periodic(_driftAccumulationTime, (timer) {
          
        });
      }
    }
  }
}
