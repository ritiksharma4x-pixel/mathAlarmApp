# Math Challenge Alarm — Android App

A production-oriented, Android-first alarm clock where each alarm can only be dismissed
after correctly solving 10 math questions. Built with Kotlin, Jetpack Compose, Room, and
Android's native alarm/notification APIs.

## What's implemented

- **Alarm creation** — time picker, repeat (once / every day / selected days), difficulty
  (Easy / Medium / Hard), 5 alarm sounds, optional label. Saved alarms show in a list with
  ON/OFF toggle, edit, and delete.
- **Reliable scheduling** — `AlarmManager.setAlarmClock()` (exact, survives Doze/App Standby),
  a `BroadcastReceiver` for firing, and a `BOOT_COMPLETED` receiver that reschedules every
  enabled alarm after a device reboot.
- **Alarm trigger** — a foreground `Service` loops the selected sound continuously and posts a
  high-priority notification with `setFullScreenIntent()`, which launches the challenge screen
  over the lock screen even while the app is closed.
- **Math challenge** — a dedicated full-screen `Activity` that:
  - Shows "WAKE UP! Solve 10 questions to stop the alarm."
  - Generates a new, mathematically valid, integer-answer question per difficulty tier
    (addition/subtraction/multiplication/division for Easy; larger ops, percentages, brackets
    for Medium; multi-step, squares, percentages, brackets for Hard). Division is always
    constructed to have a whole-number answer.
  - Tracks progress ("Question N / 10"), only advances on a correct answer, and re-generates a
    new question of the same difficulty on a wrong answer (does not accept a bypass).
  - Consumes the back button, is locked to portrait, is `singleInstance` and
    `excludeFromRecents`, and uses `setShowWhenLocked` / `setTurnScreenOn` so it reliably
    reappears over the lock screen.
  - On the 10th correct answer: stops the alarm sound service and shows
    "Alarm dismissed! Good morning! ☀️" before returning to Home.
- **5 original alarm sounds** — synthesized WAV files (Extreme Beep, Emergency Siren, Rapid
  Digital Alarm, High-Pitch Repeating Alarm, Annoying Wake-Up Alarm) in `res/raw`, each with a
  Play/Stop preview in the Sound Selection screen.
- **Persistence** — Room database (`alarms` table: id, time, repeat days, difficulty, sound,
  label, enabled) survives app restarts.
- **Settings** — default difficulty, default sound, volume guidance, dark-theme toggle, about.
- **Dark-first UI** with large, high-contrast buttons designed to be usable half-asleep.

## Project structure

```
app/src/main/java/com/mathalarm/app/
  data/        Room entities, DAO, database, repository, SharedPreferences settings
  math/        QuestionGenerator (difficulty-aware, integer-only question generation)
  alarm/       AlarmScheduler, AlarmReceiver, AlarmForegroundService, BootReceiver, SoundLibrary
  ui/          AlarmViewModel + Compose screens (home, create, sound, settings, challenge)
  MainActivity.kt, MathAlarmApp.kt
app/src/main/res/raw/   5 synthesized alarm sound .wav files
```

## Building & running

Requires **Android Studio (Koala or newer)** with JDK 17 and Android SDK 34 installed —
the project is prepared as an Android Studio build-ready project. This sandbox does not include
the Android SDK or Gradle dependency cache, so the final APK must be compiled on a machine with
Android Studio/JDK 17 and network access for the first dependency download:

1. Open the `MathAlarmApp` folder in Android Studio (`File → Open`).
2. Let Gradle sync (it will download dependencies from Google/Maven).
3. Run on a device or emulator running **API 26+** (min SDK 26, target/compile SDK 34).
4. On first run, grant the notification permission prompt, and if prompted, enable
   **"Alarms & reminders"** for the app in system settings (Android 12+ requires this for
   exact alarms — without it, alarms still fire but may be a few minutes late).

### Command line
```
./gradlew assembleDebug
```
(You'll need the Gradle wrapper jar, which isn't bundled here — run
`gradle wrapper --gradle-version 8.7` once inside the project, or open in Android Studio
which generates it automatically.)

## Known limitations / honest caveats

- **App icon** is a simple placeholder vector; swap in real launcher art via
  Android Studio's Image Asset tool if you want a polished icon.
- **Full lock-out is intentionally not absolute.** Per Android platform policy, no app can
  100% block the home button or force-quitting from Recents — doing so would make the device
  "unusable" in a way Google Play prohibits. This app uses every *officially supported*
  mechanism (full-screen intent, `setShowWhenLocked`, foreground service, ongoing notification,
  consumed back button) to make bypass very difficult and to make sure the alarm re-surfaces
  immediately if minimized, without crossing into device-lockdown territory.
  - **Emergency exception:** if you're building this for real-world use, consider whether you
    want a hidden "emergency dismiss" path (e.g., long-press a hidden area 10 seconds) so the
    app can never trap someone in a genuine emergency. This isn't implemented here since it
    wasn't requested, but it's worth adding before shipping.
- **Exact-alarm permission UX** is minimal (a notification permission prompt on first launch).
  For a polished release you'd add a dedicated onboarding screen that explains and requests
  "Alarms & reminders" access on Android 12+ and battery-optimization exemption, since OEM
  battery managers (Xiaomi, Oppo, Samsung, etc.) can still delay alarms if the app isn't
  whitelisted — that's outside what any app's code alone can control.
- This hasn't been run through an Android compiler in this environment, so treat it as a
  strong, structurally complete starting point — do a build pass in Android Studio and fix any
  small API-level mismatches Gradle surfaces (dependency versions move fast).
