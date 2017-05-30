//
//  BrokenCryptographyExerciseViewController.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 04/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "BrokenCryptographyExerciseViewController.h"
#import "NSData+AESEncryption.h"

@interface BrokenCryptographyExerciseViewController (){
    NSString *encryptionKey;
}
@end


@implementation BrokenCryptographyExerciseViewController

- (NSString *)getPathForFilename:(NSString *)filename {
    // Get the path to the Documents directory belonging to this app.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Append the filename to get the full, absolute path.
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    return fullPath;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    encryptionKey = @"myencrytionkey";
    self.textField.text = @"b@nkP@ssword123";
    
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"plain data is %@", data);
    
    NSData *encrypted_data = [data dataUsingAES256EncryptionWithKey:encryptionKey];
    NSLog(@"encryted data is %@", encrypted_data);
    NSString *encryptedFilePath = [self getPathForFilename:@"encrypted"];
    [encrypted_data writeToFile:encryptedFilePath atomically:YES];


    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Can you identify decryption code?

- (IBAction)showData:(id)sender {
//    NSString *encryptedFilePath = [self getPathForFilename:@"encrypted"];
//    NSData *encryptedData = [NSData dataWithContentsOfFile:encryptedFilePath];
//    NSData *decryptedData = [encryptedData dataUsingAES256DecryptionWithKey:encryptionKey];
//    NSLog(@"decrypted data is %@", decryptedData);
//    NSString *decryptedPassword = [NSString stringWithUTF8String:[decryptedData bytes]];
//    
//    NSLog(@"data is %@", decryptedPassword);
//    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"BrokenCryptography"
//                                                                   message:decryptedPassword
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"BrokenCryptography"
                                                                   message:@"Try Harder!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    

    
}
@end



