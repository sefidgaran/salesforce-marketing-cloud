import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sfmc_plugin_method_channel.dart';

abstract class SfmcPluginPlatform extends PlatformInterface {
  SfmcPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SfmcPluginPlatform _instance = MethodChannelSfmcPlugin();

  static SfmcPluginPlatform get instance => _instance;

  static set instance(SfmcPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
    return _instance.initialize(
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

  Future<bool?> setContactKey(String? contactKey) =>
      _instance.setContactKey(contactKey);

  Future<String?> getContactKey() => _instance.getContactKey();

  //Tags
  Future<bool?> addTag(String? tag) => _instance.addTag(tag);

  Future<bool?> removeTag(String? tag) => _instance.removeTag(tag);

  Future<List<String>> getTags() => _instance.getTags();

  // Push
  Future<bool?> setPushEnabled(bool? enabled) =>
      _instance.setPushEnabled(enabled);
}
