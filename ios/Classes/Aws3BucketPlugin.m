#import "Aws3BucketPlugin.h"
#if __has_include(<aws3_bucket/aws3_bucket-Swift.h>)
#import <aws3_bucket/aws3_bucket-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aws3_bucket-Swift.h"
#endif

@implementation Aws3BucketPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAws3BucketPlugin registerWithRegistrar:registrar];
}
@end
