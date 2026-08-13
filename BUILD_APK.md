# Build-ready instructions — MathAlarmApp

## Recommended: Android Studio

1. Install **Android Studio Koala (2024.1.1) or newer**.
2. Install **JDK 17** and Android **SDK Platform 34** from SDK Manager.
3. Open this folder (`MathAlarmApp`) in Android Studio.
4. Allow Gradle sync to download the Android/Kotlin/Compose/Room dependencies.
5. If Android Studio asks to create/update the Gradle wrapper, accept it. The project is pinned to **Gradle 8.7**, **Android Gradle Plugin 8.5.0**, and Kotlin **1.9.24**.
6. Connect an Android phone (USB debugging enabled) or start an emulator with API 26+.
7. Build the installable debug APK with **Build → Generate App Bundles or APKs → Generate APKs**.
8. The APK will be under:

   `app/build/outputs/apk/debug/app-debug.apk`

## Command line after Android Studio has generated the wrapper

```bash
./gradlew assembleDebug
```

The resulting APK is:

`app/build/outputs/apk/debug/app-debug.apk`

## First-run Android permissions

- Android 13+: allow **Notifications**.
- Android 12+: allow **Alarms & reminders / exact alarms** when Android presents the option.
- For OEMs that aggressively restrict background activity (for example some Xiaomi/Oppo/Realme devices), allow the app to run in the background if alarms are delayed.

## Important

This source package has been prepared as a build-ready Android Studio project, but this sandbox does not contain the Android SDK/Gradle dependency cache, so a real APK compilation cannot be performed here. The first Android Studio sync downloads the required build dependencies.
