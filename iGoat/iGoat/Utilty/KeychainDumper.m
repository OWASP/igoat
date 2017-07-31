//
//  KeychainDumper.m
//  iGoat
//
//  Created by heefan on 31/7/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainDumper.h"
#import <Security/Security.h>
#import "sqlite3.h"

@interface KeychainDumper()
{
    NSMutableArray * _arguments;
    NSString * _keychainPath;
}

@end

@implementation KeychainDumper

- (instancetype)initWithSimulator:(NSString *)path
{
    if(self = [super init])
    {
        _arguments = [[NSMutableArray alloc] init];
        [_arguments addObject:(id)kSecClassGenericPassword];
		[_arguments addObject:(id)kSecClassInternetPassword];
		[_arguments addObject:(id)kSecClassIdentity];
	    [_arguments addObject:(id)kSecClassCertificate];
        [_arguments addObject:(id)kSecClassKey];

        _keychainPath = path;
    }

    return self;

}

- (NSArray *)getKeychainObjectsForSecClass:(CFTypeRef)kSecClassType
{
	NSMutableDictionary *genericQuery = [[NSMutableDictionary alloc] init];

	[genericQuery setObject:(__bridge id)kSecClassType forKey:(id)kSecClass];
	[genericQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnRef];
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];

	NSArray *keychainItems = nil;

    OSStatus ret = SecItemCopyMatching((CFDictionaryRef)genericQuery, (CFTypeRef *)&keychainItems);

    switch (ret) {
        case errSecSuccess:
            NSLog(@"");
            break;
        case errSecCRLNotFound:
            NSLog(@"iGoat keychain has no data");
            keychainItems = nil;
            break;
        default:
            NSLog(@"keychain error code : %d", ret);
		keychainItems = nil;
            break;
    }

	return keychainItems;
}

- (NSString *)getEmptyKeychainItemString:(CFTypeRef)kSecClassType
{
    if (kSecClassType == kSecClassGenericPassword) {
        return @"No Generic Password Keychain items found.\n";
    }
    else if (kSecClassType == kSecClassInternetPassword) {
        return @"No Internet Password Keychain items found.\n";	
    } 
    else if (kSecClassType == kSecClassIdentity) {
        return @"No Identity Keychain items found.\n";
    }
    else if (kSecClassType == kSecClassCertificate) {
        return @"No Certificate Keychain items found.\n";	
    }
    else if (kSecClassType == kSecClassKey) {
        return @"No Key Keychain items found.\n";	
    }
    else {
        return @"Unknown Security Class\n";
    }
}

 - (NSDictionary *)dumpAllKeychainData
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSArray * keychainItems = nil;
	for (id kSecClassType in (NSArray *) _arguments) {
		keychainItems = [self getKeychainObjectsForSecClass:(CFTypeRef)kSecClassType];
        dict[kSecClassType] = keychainItems;
	}

    return dict; 
}

- (void)printResultsForSecClass:(NSArray *)keychainItems classType:(CFTypeRef)kSecClassType
{
//	if (keychainItems == nil) {
//		printToStdOut(getEmptyKeychainItemString(kSecClassType));
//		return;
//	}
//
//	NSDictionary *keychainItem;
//	for (keychainItem in keychainItems) {
//		if (kSecClassType == kSecClassGenericPassword) {
//			printGenericPassword(keychainItem);
//		}	
//		else if (kSecClassType == kSecClassInternetPassword) {
//			printInternetPassword(keychainItem);
//		}
//		else if (kSecClassType == kSecClassIdentity) {
//			printIdentity(keychainItem);
//		}
//		else if (kSecClassType == kSecClassCertificate) {
//			printCertificate(keychainItem);
//		}
//		else if (kSecClassType == kSecClassKey) {
//			printKey(keychainItem);
//		}
//	}
	return;
}

@end
