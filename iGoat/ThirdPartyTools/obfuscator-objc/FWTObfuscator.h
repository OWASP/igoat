//
//  FWTObfuscator.h
//  WTObfuscation
//
//  Created by Fabio Gallonetto on 23/01/2014.
//  Copyright (c) 2014 Future Workshops. All rights reserved.
//

#import <Foundation/Foundation.h>
#define __obfuscated

extern NSString * const FWTObfuscatorErrorDomain;

@interface FWTObfuscator : NSObject

+ (instancetype)defaultObfuscator;
@property (nonatomic, copy) NSString *encryptionKey;

- (void)setClassAsKey:(Class)classRef;

@end
