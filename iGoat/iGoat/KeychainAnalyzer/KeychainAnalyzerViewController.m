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

- (void)viewDidLoad
{
    [super viewDidLoad];

#if TARGET_IPHONE_SIMULATOR
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"../../../../../Library/Keychains/keychain-2-debug.db"];
#else
    NSString *sourcePath = @"/var/Keychains/keychain-2.db";
#endif

    NSLog(@"%@", sourcePath);
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
    NSDictionary * keychainItems = [_keychainDumper dumpAllKeychainData];

    NSString * string = [[NSString alloc] initWithFormat:@"%@", keychainItems];
    _textView.text = string;
}

- (IBAction)cleanButtonClicked:(id)sender {
    _textView.text = @"";
}
@end
