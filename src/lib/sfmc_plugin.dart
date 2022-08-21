import 'sfmc_plugin_platform_interface.dart';

class SfmcPlugin {
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

  // Contact key
  Future<bool?> setContactKey(String? contactKey) =>
      SfmcPluginPlatform.instance.setContactKey(contactKey);

  Future<String?> getContactKey() =>
      SfmcPluginPlatform.instance.getContactKey();

  // Tags
  Future<bool?> addTag(String? tag) => SfmcPluginPlatform.instance.addTag(tag);

  Future<bool?> removeTag(String? tag) =>
      SfmcPluginPlatform.instance.removeTag(tag);

  Future<List<String>> getTags() => SfmcPluginPlatform.instance.getTags();

  //Push
  Future<bool?> setPushEnabled(bool? enabled) async =>
      SfmcPluginPlatform.instance.setPushEnabled(enabled);
}
