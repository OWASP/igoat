//
//  KeychainAnalyzerViewController.m
//  iGoat
//
//  Created by heefan on 30/7/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "KeychainAnalyzerViewController.h"
#import "KeychainDumper.h"

@interface KeychainAnalyzerViewController ()
{
    KeychainDumper * _keychainDumper;
}
@end

@implementation KeychainAnalyzerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"../../../../../Library/Keychains/keychain-2-debug.db"];
    
    BOOL isOk = [[NSFileManager defaultManager] fileExistsAtPath:sourcePath];
    if (isOk) {
        _textView.text = sourcePath;
        
        _keychainDumper = [[KeychainDumper alloc] initWithSimulator:sourcePath];
    } else {
        _textView.text = @"Keychain file not exist";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)analysisButtonClicked:(id)sender
{
    [_keychainDumper dumpKeychainEntitlements];
}

- (IBAction)cleanButtonClicked:(id)sender {
}
@end
