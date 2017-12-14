//
//  FWTObfuscator.m
//  WTObfuscation
//
//  Created by Fabio Gallonetto on 23/01/2014.
//  Copyright (c) 2014 Future Workshops. All rights reserved.
//

#import "FWTObfuscator.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>



NSString * const FWTObfuscatorErrorDomain = @"com.futureworkshops.objcobfuscator";

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 2000;  // ~16ms on an iPhone 4 -> same # rounds as ruby lib


@implementation FWTObfuscator

+ (instancetype)defaultObfuscator
{
    static dispatch_once_t onceToken;
    static FWTObfuscator *defaultObfuscator = nil;
    dispatch_once(&onceToken, ^{
        defaultObfuscator = [[self alloc] init];
    });
    return defaultObfuscator;
}

- (void)setClassAsKey:(Class)classRef
{
    self.encryptionKey = NSStringFromClass(classRef);
}


- (NSString *)unobfuscate:(NSString *)obfuscatedString
{
    NSAssert(self.encryptionKey!=nil, @"Encryption key cannot be nil");
    
    NSArray *components = [obfuscatedString componentsSeparatedByString:@"-"];
    NSAssert(components.count==3, @"Obfuscated string is not of the right format");
    
    NSData *encryptedString = [[NSData alloc] initWithBase64EncodedString:components[0] options:0];
    NSData *iv = [[NSData alloc] initWithBase64EncodedString:components[1] options:0];
    NSData *salt = [[NSData alloc] initWithBase64EncodedString:components[2] options:0];
    NSError *error = nil;
    NSData *unobfuscatedData = [FWTObfuscator decryptedDataForData:encryptedString
                                                          password:self.encryptionKey
                                                                iv:iv
                                                              salt:salt
                                                             error:&error];
    
    NSAssert2(error == nil, @"Error unobfuscating the string: '%@' - %@", obfuscatedString, error);
    
    return [[NSString alloc] initWithData:unobfuscatedData encoding:NSUTF8StringEncoding];
}


//#######################

+ (NSData *)decryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData *)iv
                            salt:(NSData *)salt
                           error:(NSError **)error {
    NSAssert(iv, @"IV must not be NULL");
    NSAssert(salt, @"salt must not be NULL");
    
    
    NSData *key = [self AESKeyForPassword:password salt:salt];
    
    size_t outLength;
    NSMutableData * cipherData = [NSMutableData dataWithLength:data.length + kAlgorithmBlockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     iv.bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:FWTObfuscatorErrorDomain
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    
    return cipherData;
}


// ===================

+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    __unused int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

// ===================

// Replace this with a 10,000 hash calls if you don't have CCKeyDerivationPBKDF
+ (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int
    __unused result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  kPBKDFRounds,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}

@end
