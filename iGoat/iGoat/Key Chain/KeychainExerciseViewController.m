//
//  KeychainExerciseViewController.m
//  iGoat
//
//  Created by Mansi Sheth on 1/29/12.
//  Copyright (c) 2012 KRvW Associates, LLC. All rights reserved.
//

#import "KeychainExerciseViewController.h"

@interface KeychainExerciseViewController()

- (void)storeCredentialsInSettingsApp;
- (void)storeCredentialsInKeychain;

@end

@implementation KeychainExerciseViewController

NSString *alertMessage;

@synthesize username = _username, password = _password, rememberMe = _rememberMe;

- (void) storeCredentialsInSettingsApp {
    NSUserDefaults *credentials = [NSUserDefaults standardUserDefaults];

    [credentials setObject:self.username.text forKey:@"username"];
    [credentials setObject:self.password.text forKey:@"password"];
    [credentials synchronize];

    // setting message for UIAlert
    alertMessage = @"Stored in NSUserDefaults";
}

- (void)storeCredentialsInKeychain {
    NSMutableDictionary *storeCredentials = [NSMutableDictionary dictionary];

    // Prepare keychain dict for storing credentials.
    [storeCredentials setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];

    // Store password encoded.
    [storeCredentials setObject:[self.password.text dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)CFBridgingRelease(kSecValueData)];
    [storeCredentials setObject:self.username.text forKey:(id)CFBridgingRelease(kSecAttrAccount)];

    // Access keychain data for this app, only when unlocked. Imp to have this while
    // adding as well as updating keychain item. This is the default, but best practice
    // to specify if apple changes its API.
    [storeCredentials setObject:(id)CFBridgingRelease(kSecAttrAccessibleWhenUnlocked) forKey:(id)CFBridgingRelease(kSecAttrAccessible)];

    // Query Keychain to see if credentials exist.
    OSStatus results = SecItemCopyMatching((CFDictionaryRef) CFBridgingRetain(storeCredentials), nil);

    // If username exists in keychain...
    if (results == errSecSuccess) {
        // NSDictionary *dataFromKeyChain = NULL;
        CFDataRef dataFromKeyChain;

        // There will always be one matching entry, thus limit resultset size to 1.
        [storeCredentials setObject:(id)CFBridgingRelease(kSecMatchLimitOne) forKey:(id)CFBridgingRelease(kSecMatchLimit)];
        [storeCredentials setObject:(id)kCFBooleanTrue forKey:(id)CFBridgingRelease(kSecReturnData)];

        // Query keychain, with entered credentials and this will retrieve only 1 matching entry.
        results = SecItemCopyMatching((CFDictionaryRef) CFBridgingRetain(storeCredentials), (CFTypeRef *) &dataFromKeyChain);

        // Encoded passsword.
        NSData *encodePassword = [NSData dataWithData:(NSData *)CFBridgingRelease(dataFromKeyChain)];

        if (results == errSecSuccess) {
            NSString *passwordFromKeychain = [[NSString alloc] initWithData:encodePassword encoding:NSUTF8StringEncoding] ;
            NSLog(@"Password from keychain: %@",passwordFromKeychain);

            NSMutableDictionary *updateQuery = [NSMutableDictionary dictionary];

            // Setting up updateQuery dictionary to query existing keychain entries.
            [updateQuery setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];
            [updateQuery setObject: self.username.text forKey:(id)CFBridgingRelease(kSecAttrAccount)];

            // Making dictionary with information to update "SecItemUpdate" ready. It's
            // needed both updateQuery and tempUpdateQuery dictionaries to be similar.
            // Could have re-used storeCredentials dictionary, but was leading to compile
            // time warnings, while removing some objects.
            NSMutableDictionary *tempUpdateQuery = [NSMutableDictionary dictionary];

            [tempUpdateQuery setObject:(id)CFBridgingRelease(kSecClassGenericPassword) forKey:(id)CFBridgingRelease(kSecClass)];
            [tempUpdateQuery setObject:[self.password.text dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)CFBridgingRelease(kSecValueData)];
            [tempUpdateQuery setObject:self.username.text forKey:(id)CFBridgingRelease(kSecAttrAccount)];
            [tempUpdateQuery setObject:(id)CFBridgingRelease(kSecAttrAccessibleWhenUnlocked) forKey:(id)CFBridgingRelease(kSecAttrAccessible)];

            results = SecItemUpdate((CFDictionaryRef) CFBridgingRetain(updateQuery), (CFDictionaryRef) CFBridgingRetain(tempUpdateQuery));

            alertMessage = @"Updated in keychain.";

        } else {
            alertMessage = @"Exists in keychain, but error updating it.";
        }

    } else if (results == errSecItemNotFound) {
        // Credentials not entered in keychain, thus add it.
        results = SecItemAdd((CFDictionaryRef) CFBridgingRetain(storeCredentials), NULL);
        alertMessage = @"Added in keychain.";
    } else {
        alertMessage = @"Error adding/updating in keychain.";
    }
}

-(IBAction)storeButtonPressed:(id)sender {
    NSLog(@"In storeButtonPressed()");

    self.username.text = _username.text;
    self.password.text = _password.text;

    /*
     [userName setText:userName.text];
     [password setText:password.text];
     */

    NSLog(@"Username: %@, password: %@, remember me: %d", self.username.text, self.password.text, self.rememberMe.on);

    if (self.rememberMe.on) {
        // Stores/updates credentials in NSUserDefaults.
        // [self storeCredentialsInSettingsApp];

        /*
         SOLUTION

         The problem lies in the use of NSUserDefaults to store credentials in function "storeCredentialsInSettingsApp". This causes the credentials to be stored in plaintext as we have seen.

         Instead of using this method, use iOS's Keychain to store credentials, which stores the credentials data into a keychain entry, where it is relatively safe from casual attacker. This can be achieved by simply uncommenting call to function "storeCredentialsInKeychain" below. Don't forget to comment out call to function "storeCredentialsInSettingsApp" above.

         Note: iOS gives an application access to only its own keychain items and does not have access to any other application’s items. However since iOS 4, keychain items can be shared among different applications by using access groups. Due to this feature, keychain is not stored inside an application's sandbox. Thus, when we delete (uninstall) an application from an iOS device, its corresponding keychain entries are not deleted. Also, its is backed up in iTunes backs.

         Keychain is encrypted using device's Unique identifier (UID), which is unique for each and every device. If an attacker gets hold of UID of a particular backup (not very difficult to get it from the device), he can retrieve all keychain data.

         Although keychain data is encrypted, we are still placing user's sensitive data in plaintext into an encrypted data store. Due to above factors and depending on how we use this data, we may want to further protect that data by hashing(encrypting) it prior to storing it in keychain.
         */

        // Stores/udates data in Keychain.
         //[self storeCredentialsInKeychain];

    } else {
        alertMessage = @"Not to be remembered.";
    }

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Password"
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

@end

//******************************************************************************
//
// KeychainExerciseViewController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2013 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC
// Project Leader: Kenneth R. van Wyk (ken@krvw.com)
// Lead Developer: Sean Eidemiller (sean@krvw.com)
//
// iGoat is free software; you may redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation; version 3.
//
// iGoat is distributed in the hope it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
// License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc. 59 Temple Place, suite 330, Boston, MA 02111-1307
// USA.
//
// Source Code: http://code.google.com/p/owasp-igoat/
// Project Home: https://www.owasp.org/index.php/OWASP_iGoat_Project
//
//******************************************************************************
