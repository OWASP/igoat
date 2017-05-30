//
//  CoreDataExerciseViewController.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 19/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"




@interface CoreDataExerciseViewController : ExerciseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)saveCoreData:(id)sender;


@end
