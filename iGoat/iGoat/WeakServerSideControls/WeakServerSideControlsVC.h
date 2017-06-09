//
//  WeakServerSideControlsVC.h
//  iGoat
//
//  Created by Anthony G on 6/8/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "ExerciseViewController.h"

@interface WeakServerSideControlsVC : ExerciseViewController
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
