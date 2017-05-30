//
//  UIAlertController+EasyBlock.h
//  UIAlertController+EasyBlock
//
//  Created by Anthony Gonsalves P. on 31/08/16.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Anthony Gonsalves P.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import <Foundation/Foundation.h>


typedef void (^UIAlertCompletionBlock) (UIAlertAction * __nonnull action, NSInteger buttonIndex);

@interface UIViewController (TopViewController)
+(nullable UIViewController*)topViewController:(nullable UIViewController*)viewController;
@end

@interface UIAlertController (Blocks)
+(NSInteger)cancelButtonIndex;
+ (__nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                     preferedStyle:(UIAlertControllerStyle)preferredStyle
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                          tapBlock:(nullable UIAlertCompletionBlock)tapBlock;

+ (__nonnull instancetype)showWithTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                          preferedStyle:(UIAlertControllerStyle)preferredStyle
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
                               tapBlock:(nullable UIAlertCompletionBlock)tapBlock;
@end
