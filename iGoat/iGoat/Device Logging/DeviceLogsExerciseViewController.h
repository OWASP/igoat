//
//  DeviceLogsExerciseViewController.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 18/04/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"


@interface DeviceLogsExerciseViewController : ExerciseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ccField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *pinField;
- (IBAction)submitAction:(id)sender;

@end
