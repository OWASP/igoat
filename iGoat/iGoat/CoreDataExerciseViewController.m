//
//  CoreDataExerciseViewController.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 19/05/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "CoreDataExerciseViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "User+CoreDataClass.h"




static NSString *const CoreDataEmail = @"john@test.com";
static NSString *const CoreDataPassword = @"coredbpassword";

@interface CoreDataExerciseViewController ()
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@end

@implementation CoreDataExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self storeDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)saveInCoreDataTapped:(id)sender{

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)saveCoreData:(id)sender {
    User *user = [self fetchUser];
    
    NSString* message = ([self.email.text isEqualToString:user.email] &&
                         [self.password.text isEqualToString:user.password]) ? @"Success!!" : @"Failed";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"iGoat"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)storeDetails {
    AppDelegate * appDelegate = (AppDelegate *)(UIApplication.sharedApplication.delegate);
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    User *user = [self fetchUser];
    if (user) {
        return;
    }
    user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:context];
    user.email = CoreDataEmail;
    user.password = CoreDataPassword;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error in saving data: %@", [error localizedDescription]);
        
    }else{
        NSLog(@"data stored in core data");
    }
}

-(User *)fetchUser {
    AppDelegate * appDelegate = (AppDelegate *)(UIApplication.sharedApplication.delegate);
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    //[context executeRequest:fetchRequest error:nil];
    NSArray *users = [context executeFetchRequest:fetchRequest error:nil];
    
    if (users.count !=0 ) {
        return users.firstObject;
    }
    
    return nil;
}

@end

