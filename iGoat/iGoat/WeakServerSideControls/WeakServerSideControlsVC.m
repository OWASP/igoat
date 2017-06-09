//
//  WeakServerSideControlsVC.m
//  iGoat
//
//  Created by Anthony G on 6/8/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "WeakServerSideControlsVC.h"
#import "UIAlertController+EasyBlock.h"

static NSString *const WSSCURL = @"http://ec2-13-58-50-163.us-east-2.compute.amazonaws.com:5000/";

@interface WeakServerSideControlsVC () <UIWebViewDelegate>

@end

@implementation WeakServerSideControlsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WSSCURL]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView;{
    [self.activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;{
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;{
    [self.activityIndicatorView stopAnimating];
    
    [UIAlertController showWithTitle:@"iGoat" message:@"Problem in Internet connection" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles: nil tapBlock: nil];
}
@end
