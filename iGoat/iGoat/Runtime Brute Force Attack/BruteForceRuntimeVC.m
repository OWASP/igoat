//
//  BruteForceRuntimeVC.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/06/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "BruteForceRuntimeVC.h"
#import <CommonCrypto/CommonDigest.h>

@interface BruteForceRuntimeVC ()

@property (weak, nonatomic) IBOutlet UILabel *Hint;
@property (weak, nonatomic) IBOutlet UITextField *theTextField;
@property (weak, nonatomic) IBOutlet UIButton *bVerify;

@end

@implementation BruteForceRuntimeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.Hint.numberOfLines = 1;
    self.Hint.adjustsFontSizeToFitWidth = true;
    [self.Hint sizeToFit];
}

- (IBAction)buttonClick:(id)sender {
    
    UIAlertController *alert;
    
    if ([self validatePin:self.theTextField.text]) {
        alert = [UIAlertController alertControllerWithTitle:@"Congratulations!" message:@"You found the correct PIN!!!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        
    } else {
        alert = [UIAlertController alertControllerWithTitle:@"Verification Failed." message:@"Try again with correct PIN" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)validatePin:(NSString *)pin {
    
    uint8_t *data = (uint8_t *)[[pin dataUsingEncoding:NSUTF8StringEncoding] bytes];
    uint16_t length = pin.length;
    
    // 1181
    const uint8_t reference[32] = {
        0x02, 0x52, 0xb0, 0x81, 0xbd, 0xa7, 0x0b, 0x47,
        0x8f, 0x01, 0x31, 0xb3, 0x10, 0xa9, 0x3c, 0xb8,
        0xd7, 0x90, 0x86, 0xd7, 0x85, 0xfb, 0x4a, 0xe3,
        0x92, 0xa8, 0xc5, 0xff, 0xc3, 0xdd, 0xc5, 0xfe};
    
    uint8_t digest[32] = {0};
    CC_SHA256(data, length, digest);
    
    return memcmp(digest, reference, 32) == 0;
}

@end
