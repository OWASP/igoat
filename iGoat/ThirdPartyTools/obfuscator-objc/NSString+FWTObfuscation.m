//
//  NSString+FWTObfuscation.m
//  WTObfuscation
//
//  Created by Fabio Gallonetto on 23/01/2014.
//  Copyright (c) 2014 Future Workshops. All rights reserved.
//

#import "NSString+FWTObfuscation.h"
#import "FWTObfuscator+Private.h"

@implementation NSString(FWTObfuscation)
- (NSString *)unobfuscatedString
{
    return [[FWTObfuscator defaultObfuscator] unobfuscate:self];
}

@end
