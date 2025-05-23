import 'package:existimer/core/constants/task_type.dart';
import 'package:existimer/core/constants/timer_unit_type.dart';

import 'package:existimer/snapshots/user_settings_snapshot.dart';

class DefaultSettings {
  //外观与语言
  static final String language = "zh-CN";

  static final bool enableDarkMode = true;
  static final bool autoDarkMode = true;
  static final bool darkModeFollowSystem = true; // 未来再加入自订时间

  static final String themeColor = ""; // 暂未填入

  // 声音与通知
  static final bool enableSound = true;
  static final bool enableFinishedSound = true;
  static final bool enableNotification = true;

  // 调试默认配置
  static final bool enableDebug = false;
  static final bool enableLog = false;

  // 任务默认配置
  static final TaskType defaultTaskType = TaskType.timer;

  // 计时默认配置
  static final TimerUnitType defaultTimerUnitType = TimerUnitType.countdown;

  static final Duration countdownDuration = Duration(minutes: 35);

  static UserSettingsSnapshot toSnapshot() {
    return UserSettingsSnapshot(
      language: language,
      enableDarkMode: enableDarkMode,
      autoDarkMode: autoDarkMode,
      darkModeFollowSystem: darkModeFollowSystem,
      themeColor: themeColor,
      enableSound: enableSound,
      enableFinishedSound: enableFinishedSound,
      enableNotification: enableNotification,
      enableDebug: enableDebug,
      enableLog: enableLog,
      defaultTaskType: defaultTaskType,
      defaultTimerUnitType: defaultTimerUnitType,
      countdownDuration: countdownDuration,
    );
  }
}
