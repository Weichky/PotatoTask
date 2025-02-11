import 'dart:async';

class TimerCalibrator {
  final int _minBase = 2;
  final Duration testDuration;

  /// Constructs a TimerCalibrator with a specified test duration.
  /// The test duration must be greater than `_minBase` seconds.
  TimerCalibrator({this.testDuration = const Duration(seconds: 4)});

  /// Calibrates the timer drift and returns the expected duration for 1 second.
  /// This helps in adjusting for timer inaccuracies across different devices.
  Future<Duration> fetchDrift() async {
    if (testDuration <= Duration(seconds: _minBase)) {
      throw ArgumentError(
          'Test duration must be greater than $_minBase seconds. (Given: ${testDuration.inSeconds} seconds)');
    }

    Duration totalDrift = Duration();
    Duration baselineDrift = Duration();

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    int tickCount = 0;
    Completer<Duration> completer = Completer<Duration>();

    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
      tickCount++;
      Duration expectedElapsed = Duration(seconds: tickCount);
      Duration actualElapsed = stopwatch.elapsed;
      Duration drift = actualElapsed - expectedElapsed;

      // Accumulate initial baseline drift for the first `_minBase` seconds
      if (tickCount <= _minBase) {
        baselineDrift += drift;
      } else {
        totalDrift += drift;
      }

      if (tickCount >= testDuration.inSeconds) {
        timer.cancel();
        stopwatch.stop();

        // Compute the average baseline drift per second (in microseconds)
        int avgBaselineDriftMicroseconds =
            (baselineDrift.inMicroseconds / _minBase).round();

        // Compute total drift (corrected)
        int correctedDriftMicroseconds = totalDrift.inMicroseconds.round();

        // Compute the adjusted time needed for 1 second (in microseconds)
        int averageDriftPerSecond = ((correctedDriftMicroseconds /
                    (testDuration.inSeconds - _minBase)) -
                avgBaselineDriftMicroseconds)
            .round()
            .abs();

        // Convert drift into seconds
        Duration driftDuration = Duration(
            seconds:
                (Duration(seconds: 1).inMicroseconds / averageDriftPerSecond)
                    .round());

        completer.complete(driftDuration);
      }
    });

    timer.cancel();

    return completer.future;
  }
}