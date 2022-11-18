## 3.3.1

* Fix Android push notification open analytics
  
## 3.3.0

* Add Analytics, default = true
* Fix iOS setDelayRegistrationUntilContactKeyIsSet, default = true

## 3.2.1

* Dart Format

## 3.2.0

* Add `setProfileAttribute` and `clearProfileAttribute` methods for both Android and iOS Platforms

## 3.1.0

* Fix iOS SFMC SDK initialization and remove redundant caching - iOS Only
  
## 3.0.0

* Migrate iOS MarketingCloudSDK to 8.0.8 and SFMCSdk 1.0.6 - iOS Only
* Fix iOS SFMC SDK initialization - iOS Only
* Fix iOS receive push notification data when app is killed - iOS Only
  
## 2.2.1

* Add setPushEnabled for iOS

## 2.2.0

* Handle Multiple Push SDKs (push notifications) in iOS

## 2.1.2

* Revert cleaning code in iOS SwiftSfmcPlugin.swift changes in version 2.1.1 to fix in app message bug
  
## 2.1.1

* Cleaning code in iOS SwiftSfmcPlugin.swift
* Add UIBackgroundModes keys into example iOS info.plist
* Update readme
  
## 2.1.0

* Add URL call back from iOS to Flutter by methodCall.method 'handle_url'
  
## 2.0.1

* Set iOS platform version to 10

## 2.0.0

* Update Readme
* Refactor Android SFMC SDK initialization
  
## 1.0.5

* Update Readme
  
## 1.0.4

* Remove redundant from project.pbxproj in example
* Update Readme

## 1.0.3

* Remove redundant from project.pbxproj in example
* Move home screen widget to main.dart in example
* Update Readme

## 1.0.2

* Update readme

## 1.0.1

* Update readme
* Change Android Push  Notification PendingIntent to FLAG_IMMUTABLE
* Add firebase-bom dependency to plugin Android and remove redundant from example
* Remove Firebase initialize and package from example

## 1.0.0

* Update and fix SFMC plugin in iOS and test Push Notifications
* Update and fix SFMC plugin in Android and test Push Notifications

## 0.0.1

* SFMC Flutter Plugin
