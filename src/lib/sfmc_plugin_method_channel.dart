import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sfmc_plugin_platform_interface.dart';

/// An implementation of [SfmcPluginPlatform] that uses method channels.
class MethodChannelSfmcPlugin extends SfmcPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sfmc_plugin');

  @override
  setHandler(Future<dynamic> Function(MethodCall call)? handler) {
    methodChannel.setMethodCallHandler(handler);
  }

  @override
  Future<bool?> initialize({
    String? appId,
    String? accessToken,
    String? mid,
    String? sfmcURL,
    String? senderId,
    bool? delayRegistration,
    bool? analytics,
  }) async {
    final bool? result = await methodChannel.invokeMethod('initialize', {
      "appId": appId,
      "accessToken": accessToken,
      "mid": mid,
      "sfmcURL": sfmcURL,
      "senderId": senderId,
      "delayRegistration": delayRegistration,
      "analytics": analytics,
    });
    return result;
  }

  @override
  Future<bool?> setContactKey(String? contactKey) async {
    final bool? result = await methodChannel.invokeMethod('setContactKey', {
      "contactKey": contactKey,
    });

    return result;
  }

  @override
  Future<String?> getContactKey() async {
    final String? result = await methodChannel.invokeMethod('getContactKey');

    return result;
  }

  @override
  Future<bool?> addTag(String? tag) async {
    final bool? result = await methodChannel.invokeMethod('addTag', {
      "tag": tag,
    });

    return result;
  }

  @override
  Future<bool?> removeTag(String? tag) async {
    final bool? result = await methodChannel.invokeMethod('removeTag', {
      "tag": tag,
    });

    return result;
  }

  @override
  Future<List<String>> getTags() async {
    final List<String> result = await methodChannel.invokeMethod('getTags');

    return result;
  }

  @override
  Future<bool?> setProfileAttribute(String key, String value) async {
    final bool? result =
        await methodChannel.invokeMethod('setProfileAttribute', {
      "key": key,
      "value": value,
    });
    return result;
  }

  @override
  Future<bool?> clearProfileAttribute(String key) async {
    final bool? result =
        await methodChannel.invokeMethod('clearProfileAttribute', {
      "key": key,
    });
    return result;
  }

  @override
  Future<bool?> setPushEnabled(bool? enabled) async {
    final bool? result = await methodChannel.invokeMethod('setPushEnabled', {
      "isEnabled": enabled ?? true,
    });

    return result;
  }
}
