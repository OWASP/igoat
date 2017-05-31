//
//  DeviceLogsExerciseViewController.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 18/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "DeviceLogsExerciseViewController.h"

@interface DeviceLogsExerciseViewController ()

@end

@implementation DeviceLogsExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ccField.delegate = self;
    _cvvField.delegate =self;
    _pinField.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)submitAction:(id)sender {
    
    NSLog(@"CC value : %@", _ccField.text);
    NSLog(@"CVV value : %@", _cvvField.text);
    NSLog(@"PIN value :  %@", _pinField.text);
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                   message:@"Data Submitted Successfully"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
     [self presentViewController:alert animated:YES completion:nil];
    
}
@end
