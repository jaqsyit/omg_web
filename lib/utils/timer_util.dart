import 'dart:async';

class TimerUtil {
  int totalTimeInSeconds;
  Timer? _timer;
  Function()? onTimerTick;
  Function()? onTimerComplete;

  TimerUtil(
      {required this.totalTimeInSeconds,
      this.onTimerTick,
      this.onTimerComplete});

  String get timerText {
    int minutes = totalTimeInSeconds ~/ 60;
    int seconds = totalTimeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Timer get timerTimer {
    return _timer!;
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (totalTimeInSeconds > 0) {
        totalTimeInSeconds--;
        onTimerTick?.call();
      } else {
        _timer?.cancel();
        onTimerComplete?.call();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}