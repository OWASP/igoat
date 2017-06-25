//
//  RuntimeAnalysisChallengeVC.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/06/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "RuntimeAnalysisChallengeVC.h"
#include "maxpower.h"


@interface RuntimeAnalysisChallengeVC ()
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UILabel *Hint;
@property (weak, nonatomic) IBOutlet UITextField *theTextField;
@property (weak, nonatomic) IBOutlet UIButton *bVerify;


@end

@implementation RuntimeAnalysisChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Hint.numberOfLines = 1;
    self.Hint.adjustsFontSizeToFitWidth = true;
    [self.Hint sizeToFit];
    
    self.theLabel.hidden = true;
    
    NSString *hiddenText = [NSString stringWithCString:do_it() encoding:NSASCIIStringEncoding];
    
    self.theLabel.text = hiddenText;
    
}


- (IBAction)buttonClick:(id)sender {
    
    UIAlertController *alert;
    
    if ([self.theTextField.text isEqualToString:self.theLabel.text]) {
        alert = [UIAlertController alertControllerWithTitle:@"Congratulations!" message:@"You found the secret!!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        
    } else {
        alert = [UIAlertController alertControllerWithTitle:@"Verification Failed." message:@"This is not the string you are looking for. Try again." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
