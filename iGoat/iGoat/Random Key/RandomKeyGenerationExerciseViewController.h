//
//  RandomKeyGenerationExerciseViewController.h
//  iGoat
//
//  Created by Swaroop Yermalkar on 18/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"

@interface RandomKeyGenerationExerciseViewController : ExerciseViewController {
    
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *secretKeyField;
@property (weak, nonatomic) IBOutlet UISwitch *credentialStorageSwitch;

- (IBAction)submit:(id)sender;
- (void)storeCredentialsForUsername:(NSString *)username withPassword:(NSString *)password;

@end
