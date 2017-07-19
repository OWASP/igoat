//
//  NSUserDefaultsStorageExerciseViewController.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 29/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "NSUserDefaultsStorageExerciseViewController.h"

@interface NSUserDefaultsStorageExerciseViewController ()

@end

@implementation NSUserDefaultsStorageExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *secretDetails = [NSUserDefaults standardUserDefaults];
    
    [secretDetails setObject:@"53cr3tP" forKey:@"PIN"];
    
    [secretDetails synchronize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    
    if ([self.txt_pin.text isEqualToString:@""])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Enter details!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else
    {
        NSUserDefaults *secretDetails = [NSUserDefaults standardUserDefaults];
        
        NSString *pin = [secretDetails objectForKey:@"PIN"];
        if ([self.txt_pin.text isEqualToString:pin]) {
            
            self.txt_pin.text = @"";
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                           message:@"Congrats! You're on right track."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid!"
                                                                           message:@"Try harder!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
