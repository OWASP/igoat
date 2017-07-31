
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeychainDumper : NSObject
- (instancetype)initWithSimulator:(NSString *)path;
- (NSDictionary *)dumpAllKeychainData;

- (NSArray *)getKeychainObjectsForSecClass:(CFTypeRef)kSecClassType;
- (NSString *)getEmptyKeychainItemString:(CFTypeRef)kSecClassType;

@end
