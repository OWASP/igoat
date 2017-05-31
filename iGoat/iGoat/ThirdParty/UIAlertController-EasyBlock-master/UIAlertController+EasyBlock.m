//
//  UIAlertController+EasyBlock.m
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


#import "UIAlertController+EasyBlock.h"
#import <objc/runtime.h>


@implementation UIViewController (TopViewController)
+(UIViewController*)topViewController:(UIViewController*)viewController {
    if (!viewController) {
        viewController = [[[UIApplication sharedApplication] keyWindow]rootViewController];
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        if (navigationController.viewControllers.count != 0) {
            return [self topViewController:navigationController.viewControllers.lastObject];
        }
    }
    else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        if (tabBarController.selectedViewController) {
            return [self topViewController:tabBarController.selectedViewController];
        }
    }
    else if (viewController.presentedViewController) {
        return [self topViewController:viewController.presentedViewController];
    }
    return viewController;
}

@end



static const void *AlertTitlesKey                          = &AlertTitlesKey;
static const void *AlertCompletionKey                          = &AlertCompletionKey;


@implementation UIAlertController (Blocks)
+(NSInteger)cancelButtonIndex{
    return -1;
}

+ (__nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                          preferedStyle:(UIAlertControllerStyle)preferredStyle
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
                               tapBlock:(nullable UIAlertCompletionBlock)tapBlock {
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:preferredStyle];
    
    NSMutableArray *titles = [@[] mutableCopy];
    
    [alert setAlertCompletionBlock:tapBlock];
    
    __weak UIAlertController* weakSelf = alert;
    if (cancelButtonTitle) {
        [titles addObject:cancelButtonTitle];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:cancelButtonTitle
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     UIAlertCompletionBlock tapBlock = [alert alertCompletionBlock];
                                     if (tapBlock) {
                                         tapBlock(action,weakSelf.class.cancelButtonIndex);
                                         [alert setAlertCompletionBlock:nil];
                                     }
                                 }];
        [alert addAction:cancel];
    }
    if (otherButtonTitles) {
        [titles addObjectsFromArray:otherButtonTitles];
        for (int i = 0; i < otherButtonTitles.count; i++) {
            NSString *title = otherButtonTitles[i];
            UIAlertAction* action = [UIAlertAction
                                     actionWithTitle:title
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         UIAlertCompletionBlock tapBlock = [alert alertCompletionBlock];
                                         if (tapBlock) {
                                             tapBlock(action,0);
                                             [alert setAlertCompletionBlock:nil];
                                         }
                                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [alert addAction:action];
        }
    }
    return alert;
}

+ (__nonnull instancetype)showWithTitle:(nullable NSString *)title
                                message:(nullable NSString *)message
                          preferedStyle:(UIAlertControllerStyle)preferredStyle
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
                               tapBlock:(nullable UIAlertCompletionBlock)tapBlock {
    
    
    UIAlertController * alert=   [self alertControllerWithTitle:title message:message preferedStyle:preferredStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    return alert;
}

-(void)show {
    UIViewController *topVC =  [UIViewController topViewController:nil];
    [topVC presentViewController:self animated:YES completion:NULL];
}

-(UIAlertCompletionBlock)alertCompletionBlock{
    return objc_getAssociatedObject(self, AlertCompletionKey);
}

-(void)setAlertCompletionBlock:(UIAlertCompletionBlock)completionBlock{
    objc_setAssociatedObject(self, AlertCompletionKey, completionBlock, OBJC_ASSOCIATION_COPY);
}

@end;
