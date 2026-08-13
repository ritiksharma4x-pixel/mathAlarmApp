#!/bin/sh
# Gradle launcher helper for MathAlarmApp.
# Android Studio can build this project directly. If a system Gradle is installed,
# this helper forwards all arguments to it; otherwise use Android Studio's Gradle sync.
set -eu
if command -v gradle >/dev/null 2>&1; then
  exec gradle "$@"
fi
printf '%s\n' "Gradle is not installed on PATH." "Open this project in Android Studio (JDK 17) and let Gradle sync, then build the APK." >&2
exit 1
