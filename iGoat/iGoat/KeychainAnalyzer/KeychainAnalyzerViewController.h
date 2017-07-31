//
//  KeychainAnalyzerViewController.h
//  iGoat
//
//  Created by heefan on 30/7/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"


@interface KeychainAnalyzerViewController : ExerciseViewController
- (IBAction)analysisButtonClicked:(id)sender;
- (IBAction)cleanButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
