//
//  CrossSiteScriptingExerciseViewController.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"

@interface CrossSiteScriptingExerciseViewController : ExerciseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

- (IBAction)loadButton:(id)sender;

@end
