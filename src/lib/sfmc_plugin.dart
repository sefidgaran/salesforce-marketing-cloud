import 'sfmc_plugin_platform_interface.dart';

class SfmcPlugin {
  /// To Initialize the SDK for iOS only
  Future<bool?> initialize(
      {String? appId,
      String? accessToken,
      String? mid,
      String? sfmcURL,
      String? senderId,
      bool? locationEnabled,
      bool? inboxEnabled,
      bool? analyticsEnabled,
      bool? delayRegistration}) {
    return SfmcPluginPlatform.instance.initialize(
        appId: appId,
        accessToken: accessToken,
        mid: mid,
        sfmcURL: sfmcURL,
        senderId: senderId,
        locationEnabled: locationEnabled,
        inboxEnabled: inboxEnabled,
        analyticsEnabled: analyticsEnabled,
        delayRegistration: delayRegistration);
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

  /// To Enable/Disable Push Notification
  Future<bool?> setPushEnabled(bool? enabled) async =>
      SfmcPluginPlatform.instance.setPushEnabled(enabled);
}
