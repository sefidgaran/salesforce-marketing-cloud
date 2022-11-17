import 'package:flutter/services.dart';
import 'sfmc_plugin_platform_interface.dart';

class SfmcPlugin {
  /// To Initialize the SDK for iOS only
  Future<bool?> initialize({
    String? appId,
    String? accessToken,
    String? mid,
    String? sfmcURL,
    String? senderId,
    bool? delayRegistration,
    bool? analytics,
  }) {
    return SfmcPluginPlatform.instance.initialize(
      appId: appId,
      accessToken: accessToken,
      mid: mid,
      sfmcURL: sfmcURL,
      senderId: senderId,
      delayRegistration: delayRegistration,
      analytics: analytics,
    );
  }

  /// (Applicable to iOS only - pass URL to Flutter through 'handle_url' methodCall.method - refer to example)
  setHandler(Future<dynamic> Function(MethodCall call)? handler) {
    SfmcPluginPlatform.instance.setHandler(handler);
  }

  /// To Set Contact Key
  Future<bool?> setContactKey(String? contactKey) =>
      SfmcPluginPlatform.instance.setContactKey(contactKey);

  /// To Get Contact Key
  Future<String?> getContactKey() =>
      SfmcPluginPlatform.instance.getContactKey();

  /// To Add Tags
  Future<bool?> addTag(String? tag) => SfmcPluginPlatform.instance.addTag(tag);

  /// To Remove Tags
  Future<bool?> removeTag(String? tag) =>
      SfmcPluginPlatform.instance.removeTag(tag);

  /// To Get Tags
  Future<List<String>> getTags() => SfmcPluginPlatform.instance.getTags();

  /// Set Profile Attribute
  /// @param key - Key of the attribute
  /// @param value - Value of the attribute
  Future<bool?> setProfileAttribute(String key, String value) =>
      SfmcPluginPlatform.instance.setProfileAttribute(key, value);

  /// Clear Profile Attribute
  /// @param key - Key of the attribute
  Future<bool?> clearProfileAttribute(String key) =>
      SfmcPluginPlatform.instance.clearProfileAttribute(key);

  /// To Enable/Disable Push Notification
  Future<bool?> setPushEnabled(bool? enabled) async =>
      SfmcPluginPlatform.instance.setPushEnabled(enabled);
}
