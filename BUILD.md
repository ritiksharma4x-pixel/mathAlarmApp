# Math Challenge Alarm — Build Guide

## Requirements

- Android Studio Koala (2024.1.1) or newer
- JDK 17
- Android SDK Platform 34
- Android SDK Build-Tools 34.x

## Open and build

1. Extract this ZIP.
2. Open the `MathAlarmApp` folder in Android Studio.
3. Allow Gradle to sync and download the Android/Kotlin/Compose/Room dependencies.
4. Select **Build → Generate App Bundle(s) / APK(s) → Generate APK(s)**.
5. The debug APK will normally be under `app/build/outputs/apk/debug/app-debug.apk`.

## Command line

If Gradle is installed, run:

```bash
./gradlew assembleDebug
```

The project targets SDK 34, uses Java/Kotlin 17, and requires Gradle 8.7 with Android Gradle Plugin 8.5.0.

## Device requirements

- Android 8.0 (API 26) or newer.
- Android 12+: allow **Alarms & reminders** if the system asks for exact-alarm access.
- Android 13+: allow notifications so the alarm's full-screen notification can appear reliably.

## Important

The included `gradlew` helper forwards to a system `gradle` installation. The Gradle wrapper JAR is intentionally not included because this build environment cannot download external Gradle artifacts. Android Studio's built-in Gradle integration works normally after dependency download.
