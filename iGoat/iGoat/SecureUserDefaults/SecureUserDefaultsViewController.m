//
//  SecureUserDefaultsViewController.m
//  iGoat
//
//  Created by tilak kumar on 8/23/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "SecureUserDefaultsViewController.h"
#import "NSUserDefaults+SecureAdditions.h"
#import "Utils.h"

@interface SecureUserDefaultsViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *fNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *genderTextField;
@property (nonatomic, weak) IBOutlet UITextField *mobileTextField;
@property (nonatomic, weak) IBOutlet UITextField *locationTextField;
@property (nonatomic, weak) IBOutlet UIButton *saveBtn;

- (IBAction)saveClicked;

@end

@implementation SecureUserDefaultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveClicked{
    
    [self.view resignFirstResponder];
    
    NSString *firstName = self.fNameTextField.text;
    NSString *fNameKey = self.fNameTextField.placeholder;
    
    NSString *lastName = self.lNameTextField.text;
    NSString *lNameKey = self.lNameTextField.placeholder;

    NSString *gender = self.genderTextField.text;
    NSString *genderKey = self.genderTextField.placeholder;
    
    NSString *mobile = self.mobileTextField.text;
    NSString *mobileKey = self.mobileTextField.placeholder;
    
    NSString *location = self.locationTextField.text;
    NSString *locationKey = self.locationTextField.placeholder;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *encryptionKey = [Utils generateRandomString];
    
    NSLog(@"*******************NSUserDefaults+SecureAdditions*******************");
    
    NSLog(@"Encryption key: %@",encryptionKey);
    
    [defaults setSecret:encryptionKey];
    
    if (firstName.length) {
        [defaults setSecretObject:firstName forKey:fNameKey];
        [self.fNameTextField setText:@""];
    }
    
    if (lastName.length) {
        [defaults setSecretObject:lastName forKey:lNameKey];
        [self.lNameTextField setText:@""];
    }
    
    if (gender.length) {
        [defaults setSecretObject:gender forKey:genderKey];
        [self.genderTextField setText:@""];
    }
    
    if (mobile.length) {
        [defaults setSecretObject:mobile forKey:mobileKey];
        [self.mobileTextField setText:@""];
    }
    
    if (location.length) {
        [defaults setSecretObject:location forKey:locationKey];
        [self.locationTextField setText:@""];
    }
    
    NSLog(@"*********************************************************************");
}

@end
