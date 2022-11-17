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

# Let's get started #

First of all you need to add sfmc_plugin in your project. In order to do that, follow [this guide](https://pub.dev/packages/sfmc_plugin/install).

We suggest you to check [example](https://github.com/sefidgaran/salesforce-marketing-cloud/tree/main/src/example) source code.

## Setup Android 
Create an app in MobilePush. This process connects the device to the MobilePush app you created previously in [MobilePush](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/create-apps/create-apps-overview.html).

Note: The Android SDK requires Android API 21 or greater and has dependencies on the Android Support v4 and Google Play Services libraries.

### Set up Firebase
Follow the [Android Firebase setup](https://firebase.google.com/docs/android/setup) documentation.

#### And your Firebase google-services.json to your android/app folder.

#### Add google-services plugin to your android/app/build.gradle:
```java
  apply plugin: 'com.google.gms.google-services'
```

#### Add google-services dependency to android/build.gradle:
```java
  dependencies {
    classpath 'com.google.gms:google-services:4.3.13'
  }
```
## Initialize SFMC SDK in Android

Please update android/gradle.properties as example below:
```java
MC_APP_ID="<YOUR_SFMC_APP_ID>"
MC_ACCESS_TOKEN="<YOUR_SFMC_ACCESS_TOKEN>"
MC_SENDER_ID="<YOUR_FIREBASE_CLOUD_MESSAGING_SENDER_ID_FOR_SFMC>"
MC_MID="<YOUR_SFMC_MID>"
MC_SERVER_URL="<YOUR_SFMC_URL>"
```
## Setup iOS 

###  Provision for Push
Please follow the [Provision for Push](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/get-started-provision.html).

### Update info.plist
Note: Please add UIBackgroundModes keys into your info.plist file as below:

```plist
<key>UIBackgroundModes</key>
	<array>
    	<string>fetch</string>
    	<string>remote-notification</string>
	</array>
```

### Setup `UNUserNotificationCenter` delegate
Add the following lines to the `application` method in the AppDelegate.m/AppDelegate.swift file of your iOS project.

Objective-C:
```objc
if (@available(iOS 10.0, *)) {
  [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
}
```

Swift:
```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```
## Use Flutter Plugin

The first step is initializing the SFMC plugin with credential information (applies to iOS only, for Android please refer to setup Android section). 
[Learn more](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/get-started-setupapps.html)

```dart
    /// iOS only
    var isInitialized = await SfmcPlugin().initialize(
        appId: '<YOUR_APP_ID>',
        accessToken: '<YOUR_ACCESS_TOKEN>',
        mid: '<YOUR_MID>',
        sfmcURL:
            '<YOUR_SFMC_URL>',
        senderId: '<YOUR_FIREBASE_CLOUD_MESSAGING_SENDER_ID>',

        /// Set delayRegistration on iOS only, 
        /// delayRegistration on Android is by default true
        delayRegistration: true,
        
        /// Set analytics on iOS only, 
        /// analytics on Android is by default true
        analytics: true,
      );
```

The second step is setting your sfmc contact key which is a unique client id in Salesforce Marketing Cloud.

```dart
await SfmcPlugin().setContactKey('<Uniquely Identifying Key>');
```

### Attributes

You can use attributes to segment your audience and personalize your messages. Before you can use attributes, create them in your MobilePush account. Attributes may only be set or cleared by the SDK. See the [Reserved Words](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-Android/sdk-implementation/device-contact-registration.html#reserved-words) section for a list of attribute keys that can’t be modified by the SDK or your application.

```dart
await SfmcPlugin().setProfileAttribute("key", "value");

await SfmcPlugin().clearProfileAttribute("key");
```


## Contributions

🍺 Pull requests are welcome!

Feel free to contribute to this project.
