# Gachbom Player

This is a Flutter music player application for Android.

## Setup Instructions

Since this code was generated in an environment without the Flutter SDK, please follow these steps to run the application on your machine.

### 1. Create a New Flutter Project

Open your terminal and run:

```bash
flutter create gachbom_player
cd gachbom_player
```

### 2. Replace Source Files

Replace the generated `lib` folder and `pubspec.yaml` file with the ones provided in this repository.

### 3. Android Configuration (Important)

You must configure Android permissions for the app to work (Internet access and Storage access for downloads).

Open `android/app/src/main/AndroidManifest.xml` and add the following permissions inside the `<manifest>` tag, above the `<application>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<!-- For downloading files -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<!-- Android 13+ permissions -->
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
```

Also, inside the `<application>` tag, add the service declaration for `audio_service` to allow background playback (this is required by the `audio_service` package):

```xml
<service android:name="com.ryanheise.audioservice.AudioService"
    android:foregroundServiceType="mediaPlayback"
    android:exported="true">
    <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService" />
    </intent-filter>
</service>

<receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
    </intent-filter>
</receiver>
```

### 4. Run the App

Install dependencies and run the app:

```bash
flutter pub get
flutter run
```

## Features

*   **Browse**: View music categories and songs from a mock server.
*   **Download**: Download songs to your device for offline listening.
*   **Library**: Play your downloaded songs.
*   **Background Play**: Music continues playing when the app is in the background.
