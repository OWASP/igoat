#import "ExerciseViewController.h"
#import "Exercise.h"

@implementation ExerciseViewController

@synthesize scrollView, exercise, rootExerciseController, activeField, hintsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil exercise:(Exercise *)ex {
    if ((self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Reset the hint index on the exercise.
        ex.hintIndex = 0;

        self.exercise = ex;
        self.rootExerciseController = self;
        [self registerForKeyboardNotifications];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil exercise:(Exercise *)ex rootExerciseController:(ExerciseViewController *)exerciseController {

    if ((self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil exercise:ex])) {
        self.rootExerciseController = exerciseController;
    }
    
    return self;
}

- (NSString *)getPathForFilename:(NSString *)filename {
	// Get the path to the Documents directory belonging to this app.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	// Append the filename to get the full, absolute path.
	NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
	return fullPath;
}

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

   
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender {
    for (UIView *view in [self.view subviews]) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
            break;
        }
    }
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

// Make it known that we care about keyboard notifications.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)notification {
    // Don't bother doing anything if this exercise doesn't have a scroll view.
    if (!scrollView) return;

    if (!keyboardHeight) {
        NSDictionary* info = [notification userInfo];
        CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        keyboardHeight = keyboardSize.height;
    }

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardHeight;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, keyboardHeight + activeField.frame.size.height - activeField.frame.origin.y);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification {
    // Don't bother doing anything if this exercise doesn't have a scroll view.
    if (!scrollView) return;

    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    activeField = nil;
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    if (activeField) {
        activeField = (UITextField *)sender;
        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification object:nil];
    } else {
        activeField = (UITextField *)sender;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations

#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end

//******************************************************************************
//
// ExerciseViewController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2013 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC
// Project Leader: Kenneth R. van Wyk (ken@krvw.com)
// Lead Developer: Sean Eidemiller (sean@krvw.com)
//
// iGoat is free software; you may redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation; version 3.
//
// iGoat is distributed in the hope it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
// License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc. 59 Temple Place, suite 330, Boston, MA 02111-1307
// USA.
//
// Source Code: http://code.google.com/p/owasp-igoat/
// Project Home: https://www.owasp.org/index.php/OWASP_iGoat_Project
//
//******************************************************************************
