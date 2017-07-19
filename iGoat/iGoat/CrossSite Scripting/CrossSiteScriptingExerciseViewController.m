//
//  CrossSiteScriptingExerciseViewController.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "CrossSiteScriptingExerciseViewController.h"

@interface CrossSiteScriptingExerciseViewController ()

@end

@implementation CrossSiteScriptingExerciseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _txtField.delegate=self;
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)loadButton:(id)sender {
    [self.webview loadHTMLString:[NSString stringWithFormat:@"Welcome to XSS Exercise !!! \n Here is UIWebView ! %@",_txtField.text] baseURL:nil];
    
}
@end
