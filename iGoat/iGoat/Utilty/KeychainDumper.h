
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeychainDumper : NSObject
- (instancetype)initWithSimulator:(NSString *)path;
- (NSDictionary *)dumpAllKeychainData;


@end
