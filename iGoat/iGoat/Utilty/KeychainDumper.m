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
            NSLog(@"Keychain Read Successfully");
            break;
        case errSecCRLNotFound:
            NSLog(@"iGoat keychain Record Item has not found");
            keychainItems = nil;
            break;
        default:
            NSLog(@"keychain error code : %d", ret);
		keychainItems = nil;
            break;
    }

	return keychainItems;
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
@end
