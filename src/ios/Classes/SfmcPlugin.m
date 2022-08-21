#import "SfmcPlugin.h"
#if __has_include(<sfmc_plugin/sfmc_plugin-Swift.h>)
#import <sfmc_plugin/sfmc_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sfmc_plugin-Swift.h"
#endif

@implementation SfmcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSfmcPlugin registerWithRegistrar:registrar];
}
@end
