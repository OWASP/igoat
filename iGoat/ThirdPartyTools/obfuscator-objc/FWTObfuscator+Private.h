//
//  NSString+reg.h
//  WTObfuscation
//
//  Created by Fabio Gallonetto on 23/01/2014.
//  Copyright (c) 2014 Future Workshops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWTObfuscator.h"

@interface FWTObfuscator(Private)
- (NSString *)unobfuscate:(NSString *)obfuscatedString;
@end
