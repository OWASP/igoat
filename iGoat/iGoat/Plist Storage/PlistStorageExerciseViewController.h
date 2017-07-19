//
//  PlistStorageExerciseViewController.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 29/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"


@interface PlistStorageExerciseViewController : ExerciseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txt_pwd;
@property (weak, nonatomic) IBOutlet UITextField *txt_user;

- (IBAction)login:(id)sender;

@end
