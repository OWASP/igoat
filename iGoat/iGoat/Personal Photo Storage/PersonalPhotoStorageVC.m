//
//  PersonalPhotoStorageVC.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/06/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "PersonalPhotoStorageVC.h"
#import "PhotoViewerVC.h"
#import <CommonCrypto/CommonDigest.h>

@interface PersonalPhotoStorageVC ()

@property (weak, nonatomic) IBOutlet UILabel *Hint;
@property (weak, nonatomic) IBOutlet UITextField *theTextField;
@property (weak, nonatomic) IBOutlet UIButton *bVerify;

@end

@implementation PersonalPhotoStorageVC{
    NSString *_pw;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.Hint.numberOfLines = 1;
    self.Hint.adjustsFontSizeToFitWidth = true;
    [self.Hint sizeToFit];
    
    _pw = [self thePw];
}

- (IBAction)buttonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (![self.theTextField.text isEqualToString:_pw]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Password"
                                                                       message:@"Enter the correct password"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIViewController *vc = [[PhotoViewerVC alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.navigationBar.barStyle = UIBarStyleBlack;
    nc.navigationBar.translucent = YES;
    [self presentViewController:nc animated:YES completion:nil];
}

- (NSString *)thePw
{
    char xored[] = {0x5e, 0x42, 0x56, 0x5a, 0x46, 0x53, 0x44, 0x59, 0x54, 0x55};
    char key[] = "1234567890";
    char pw[20] = {0};
    
    for (int i = 0; i < sizeof(xored); i++) {
        pw[i] = xored[i] ^ key[i%sizeof(key)];
    }
    
    return [NSString stringWithUTF8String:pw]; // "opensesame"
}

@end
