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

@property (nonatomic, weak) IBOutlet UILabel *fNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *lNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *genderLbl;
@property (nonatomic, weak) IBOutlet UILabel *mobileLbl;
@property (nonatomic, weak) IBOutlet UILabel *locationLbl;

@property (nonatomic, weak) IBOutlet UITextField *fNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lNameTextField;
@property (nonatomic, weak) IBOutlet UISegmentedControl *genderSegmentControl;
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
    NSString *fNameKey = self.fNameLbl.text;
    
    NSString *lastName = self.lNameTextField.text;
    NSString *lNameKey = self.lNameLbl.text;
    
    NSString *gender = self.genderSegmentControl.selectedSegmentIndex == 0 ? @"Male" : @"Female";
    NSString *genderKey = self.genderLbl.text;
    
    NSString *mobile = self.mobileTextField.text;
    NSString *mobileKey = self.mobileLbl.text;
    
    NSString *location = self.locationTextField.text;
    NSString *locationKey = self.locationLbl.text;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *encryptionKey = [Utils generateRandomString];
    
    NSLog(@"*******************SecureUserDefaults*******************");
    
    NSLog(@"Encryption key: %@",encryptionKey);
    
    [defaults setSecret:encryptionKey];
    
    if (firstName.length) {
        [defaults setSecretObject:firstName forKey:fNameKey];
        NSLog(@"\n%@:%@",fNameKey,[defaults objectForKey:fNameKey]);
        [self.fNameTextField setText:@""];
    }
    
    if (lastName.length) {
        [defaults setSecretObject:lastName forKey:lNameKey];
        NSLog(@"\n%@:%@",lNameKey,[defaults objectForKey:lNameKey]);
        [self.lNameTextField setText:@""];
    }
    
    if (gender.length) {
        [defaults setSecretObject:gender forKey:genderKey];
        NSLog(@"\n%@:%@",genderKey,[defaults objectForKey:genderKey]);
    }
    
    if (mobile.length) {
        [defaults setSecretObject:mobile forKey:mobileKey];
        [self.mobileTextField setText:@""];
        NSLog(@"\n%@:%@",mobileKey,[defaults objectForKey:mobileKey]);
    }
    
    if (location.length) {
        [defaults setSecretObject:location forKey:locationKey];
        [self.locationTextField setText:@""];
        NSLog(@"\n%@:%@",locationKey,[defaults objectForKey:locationKey]);
    }
    
    NSLog(@"*********************************************************************");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SecureUserDefaults" message:@"Successfully Saved!" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
