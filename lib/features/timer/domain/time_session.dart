//timer_session.dart
import 'package:potato_task/core/utils/timer/timer_type.dart';
import 'timer_status.dart';

class TimerSession {
  Duration? _totalDuration;
  Duration _elapsedDuration = Duration();
  Duration _lastElapsedDuration = Duration();
  
  DateTime? _lastCheckPoint;
  TimerStatus _timerStatus = TimerStatus.ready;
  TimerType _timerType;

  TimerSession({
    Duration? totalDuration,
    required TimerType timerType,
  }) : 
  _timerType = timerType,
  _totalDuration =
    (timerType == TimerType.countdown)
    ? (totalDuration ?? Duration(minutes: 35,))
    : null {
      if (timerType == TimerType.forward
        && _totalDuration != null) {
          throw ArgumentError(
            "Forward TimeSession is not allow to have totalDuration.");
        }
    }

  void start() {
    if (_timerStatus == TimerStatus.running) return;
    _timerStatus = TimerStatus.running;
    _lastCheckPoint = DateTime.now();
  }

  void pause() {
    if (_timerStatus != TimerStatus.running) return;
    _timerStatus = TimerStatus.paused;
    _lastElapsedDuration = _elapsedDuration;
    _lastCheckPoint = DateTime.now();
  }

  void resume() {
    if (_timerStatus != TimerStatus.paused) return;
    _timerStatus = TimerStatus.running;
  }
}