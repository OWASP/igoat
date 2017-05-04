//
//  NSData+AESEncryption.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 04/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

@interface NSData (AESEncryption)
- (NSData *)dataUsingAES256EncryptionWithKey:(NSString *)key;
- (NSData *)dataUsingAES256DecryptionWithKey:(NSString *)key;
@end
