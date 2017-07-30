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
- (void)dumpKeychainEntitlements
{
    NSString *databasePath = _keychainPath;
    const char *dbpath = [databasePath UTF8String];
    sqlite3 *keychainDB;
    sqlite3_stmt *statement;
	NSMutableString *entitlementXML = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                                       "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
                                       "<plist version=\"1.0\">\n"
                                       "\t<dict>\n"
                                       "\t\t<key>keychain-access-groups</key>\n"
                                       "\t\t<array>\n"];
	
    if (sqlite3_open(dbpath, &keychainDB) == SQLITE_OK)
    {
        const char *query_stmt = "SELECT DISTINCT agrp FROM genp UNION SELECT DISTINCT agrp FROM inet";
		
        if (sqlite3_prepare_v2(keychainDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
			while(sqlite3_step(statement) == SQLITE_ROW)
            {            
				NSString *group = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
				
                [entitlementXML appendFormat:@"\t\t\t<string>%@</string>\n", group];
            }
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Unknown error querying keychain database\n");
		}
		[entitlementXML appendString:@"\t\t</array>\n"
         "\t</dict>\n"
         "</plist>\n"];
		sqlite3_close(keychainDB);
		NSLog(@"%@", entitlementXML);
	}
	else
	{
		NSLog(@"Unknown error opening keychain database\n");
	}
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
	if (SecItemCopyMatching((CFDictionaryRef)genericQuery, (void *)&keychainItems) != noErr)
	{
		keychainItems = nil;
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

    

@end
