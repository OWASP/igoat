//
//  BinaryPatchingVC.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/06/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "BinaryPatchingVC.h"
#import "PhotoViewerVC.h"
#import <CommonCrypto/CommonDigest.h>

@interface BinaryPatchingVC ()

@property (weak, nonatomic) IBOutlet UILabel *Hint;
@property (weak, nonatomic) IBOutlet UITextField *theTextField;
@property (weak, nonatomic) IBOutlet UIButton *bVerify;

@end

@implementation BinaryPatchingVC{
    NSString *_pw;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.Hint.numberOfLines = 1;
    self.Hint.adjustsFontSizeToFitWidth = true;
    [self.Hint sizeToFit];
}

- (IBAction)buttonClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (![self.theTextField.text isEqualToString:@"root"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Password"
                                                                       message:@"Enter the correct password"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations"
                                                                   message:@"You have enterred the correct password!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    return;

}
@end
