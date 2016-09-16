#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface ExerciseViewController : UIViewController {
    float keyboardHeight;
}

@property (strong, nonatomic) Exercise *exercise;
@property (strong, nonatomic) ExerciseViewController *rootExerciseController;
@property (strong, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hintsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil exercise:(Exercise *)ex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil exercise:(Exercise *)ex rootExerciseController:(ExerciseViewController *)exerciseController;
- (NSString *)getPathForFilename:(NSString *)filename;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)registerForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)notification;
- (void)keyboardWillBeHidden:(NSNotification*)notification;
- (IBAction)textFieldDidBeginEditing:(id)sender;

@end

//******************************************************************************
//
// ExerciseViewController.h
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