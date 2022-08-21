import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc_plugin/sfmc_plugin_platform_interface.dart';
import 'package:sfmc_plugin/sfmc_plugin_method_channel.dart';

void main() {
  final SfmcPluginPlatform initialPlatform = SfmcPluginPlatform.instance;

  test('$MethodChannelSfmcPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSfmcPlugin>());
  });
}
