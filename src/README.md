# sfmc_plugin

[![pub package](https://img.shields.io/pub/v/sfmc_plugin.svg)](https://pub.dartlang.org/packages/sfmc_plugin)

[Salesforce Marketing Cloud (SFMC)](https://www.salesforce.com/) - MobilePush SDK for Flutter.

Marketing Cloud MobilePush lets you create and send notifications to encourage use of your app.

This SFMC Flutter Plugin includes:

* Push Notifications
Create a message using one of the templates in Marketing Cloud MobilePush or the Push Notification template in Content Builder or Journey Builder.

* In-App Messages
In-app messages allow you to interact with your mobile app users while they use your mobile app, which is when they are most engaged. Trigger a message to show in your mobile app when a user opens the app on their device. While you can send this message to all of a contact’s devices, it only shows on the first device that opens the app. In-app messages can’t be created in MobilePush.

Learn more about SFMC Mobile Push SDK: 
* [SFMC SDK Android](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/)
* [SFMC SDK iOS](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/)

## Install

Add `sfmc_plugin` to your `pubspec.yaml` dependencies:
```yaml
...
dependencies:
  flutter:
    sdk: flutter

  sfmc_plugin:
...
```

## Setup Android 
Create an app in MobilePush. This process connects the device to the MobilePush app you created previously in [MobilePush](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/create-apps/create-apps-overview.html).

Note: The Android SDK requires Android API 21 or greater and has dependencies on the Android Support v4 and Google Play Services libraries.

Prerequisites

1. Implement the SDK

* Update module-level build.gradle file

Add the SDK repository:
```java
repositories {
  maven { url "https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/repository" }
}
```

Add the SDK dependency:
```java
dependencies {
  implementation 'com.salesforce.marketingcloud:marketingcloudsdk:8.0.6'
}
```

2. Set up Firebase
Follow the [Android Firebase setup](https://firebase.google.com/docs/android/setup) documentation. When you add the Firebase core dependency to your module gradle file, use:
```java
dependencies {
  implementation platform('com.google.firebase:firebase-bom:30.3.0')
}
```

Note: Don't forget to add your Firebase google-services.json to your android/app folder and initialize Firebase in your Flutter project.
[Example](https://github.com/sefidgaran/salesforce-marketing-cloud/src/example):
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
```

# Setup iOS 

Note: Please follow the [Provision for Push](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/get-started-provision.html) and use the Flutter plugin.

## Use Flutter Plugin

The first step is initializing the SFMC plugin with credential information, then setting the contact key as a unique key which is already available in SFMC panel. 

```dart
var isInitialized = await SfmcPlugin().initialize(
        appId: '<your appId>',
        accessToken: '<your access token>',
        mid: '<your mid>',
        sfmcURL:
            '<your sfmc url>',
        senderId: '<your firebase sender id>',
        locationEnabled: false,
        inboxEnabled: false,
        analyticsEnabled: true,
        delayRegistration: true);
```

The second step is setting your sfmc contact key which is a unique client id in Salesforce Marketing Cloud.

```dart
await SfmcPlugin().setContactKey('<unique contact key>');
```