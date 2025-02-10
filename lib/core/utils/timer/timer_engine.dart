import 'dart:async';
import 'timer_type.dart';

class TimerEngine {
  final TimerType type;
  final Duration? totalDuration;
  
  Timer? _timer;
  Duration _elapsed = Duration();

  void Function(Duration elapsed)? onTick;
  void Function()? onComplete;
  void Function(Duration elapsed)? onAbort;

  TimerEngine({
    required this.type,
    this.totalDuration,
    this.onTick,
    this.onComplete,
    this.onAbort,
  });

  void start() {
    _stop();
    _elapsed = Duration();

    if (type == TimerType.countdown && totalDuration != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsed += const Duration(seconds: 1);

        final remaining =  totalDuration! - _elapsed;
        onTick?.call(remaining);

        if (remaining <= Duration.zero) {
          _stop();
          onComplete?.call();
        }
      });
    } else if (type == TimerType.forward) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsed += const Duration(seconds: 1);

        onTick?.call(_elapsed);
      });
    } else {
      throw ArgumentError(
        "Countdown Timer must have a totalDuration."
      );
    }
  }

  void abort() {
    _stop();
    onAbort?.call(_elapsed);
  }

  void _stop() {
    if (_timer == null) {
      return;
    }
      _timer!.cancel();
      _timer = null;
  }

  bool get isRunning => _timer != null;
}