//
//  PlistStorageExerciseViewController.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 29/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "PlistStorageExerciseViewController.h"

@interface PlistStorageExerciseViewController ()

@end

@implementation PlistStorageExerciseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    
    NSString *destinationPath= [doumentDirectoryPath stringByAppendingPathComponent:@"Credentials.plist"];
    
    NSLog(@"plist path %@",destinationPath);
    if ([fileManger fileExistsAtPath:destinationPath]){
        //NSLog(@"database localtion %@",destinationPath);
        return;
    }
    NSString *sourcePath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"Credentials.plist"];
    
    [fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    if ([self.txt_user.text  isEqual: @""] || [self.txt_pwd.text isEqual: @""])
    {
        NSLog(@"blank");
        self.txt_user.text = @"";
        self.txt_pwd.text = @"";
        
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
        NSString *username = self.txt_user.text;
        NSString *password = self.txt_pwd.text;
        
        NSString *plist = [[NSBundle mainBundle]pathForResource:@"Credentials" ofType:@"plist"];
        NSDictionary *myDict = [NSDictionary dictionaryWithContentsOfFile:plist];
        
        if ( [username isEqualToString:[myDict objectForKey:@"User"]] && [ password isEqualToString:[myDict objectForKey:@"Password"]])
        {
            NSLog(@"Login Success");
            self.txt_user.text = @"";
            self.txt_pwd.text = @"";
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                           message:@"Congrats! You're on right track."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

    
            
        }
        
        else{
            NSLog(@"Login Fail");
            self.txt_user.text = @"";
            self.txt_pwd.text = @"";
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid!"
                                                                           message:@"Try little bit."
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
