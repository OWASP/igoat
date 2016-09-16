#import "ExerciseContainerViewController.h"
#import "ExerciseViewController.h"
#import "HtmlViewController.h"
#import "HintsViewController.h"

@interface ExerciseContainerViewController ()

- (void)switchToViewController:(ExerciseViewController *)newController;

@end

@implementation ExerciseContainerViewController

@synthesize currentVC, hintsButton, container, exercise = _exercise;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    // self.currentVC = self.childViewControllers.lastObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TODO: Cache the view controllers with exercise->controller hash.
- (void)setExercise:(Exercise *)newExercise {
    // Instantiate the associated view controller.
    NSString *initialControllerName = newExercise.initialViewController;
    NSString *nibName;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nibName = [NSString stringWithFormat:@"%@_iPad", initialControllerName];
    } else {
        nibName = [NSString stringWithFormat:@"%@_iPhone", initialControllerName];
    }

    ExerciseViewController *newController = [[NSClassFromString(initialControllerName) alloc] initWithNibName:nibName bundle:nil exercise:newExercise];
    
    if (newController) {
        // Disable the "Hints" button if there aren't any.
        if (newExercise.totalHints <= 0) self.hintsButton.enabled = NO;

        // Switch to the new view controller/exercise.
        _exercise = newExercise;
        [self switchToViewController:newController];

    } else {
        // Something went wrong; display alert dialog.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Snap!" message:@"Error loading view controller." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)switchToViewController:(ExerciseViewController *)newController {
    if (self.currentVC) {
        [self addChildViewController:newController];
        newController.view.frame = self.container.bounds;
        [self.currentVC willMoveToParentViewController:nil];
        [self transitionFromViewController:self.currentVC
                          toViewController:newController
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{}
                                completion:^(BOOL finished) {
                                    [self.currentVC removeFromParentViewController];
                                    [newController didMoveToParentViewController:self];
                                    self.currentVC = newController;
                                }
         ];

    } else {
        [self addChildViewController:newController];
        [self.view addSubview:newController.view];
        [newController didMoveToParentViewController:self];
        self.currentVC = newController;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = [segue identifier];

    if ([identifier isEqualToString:@"showHints"]) {
        HintsViewController *controller = [segue destinationViewController];
        controller.exercise = self.exercise;
    } else if ([identifier isEqualToString:@"showSolution"]) {
        HtmlViewController *controller = [segue destinationViewController];
        controller.content = [self.exercise htmlSolution];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end

//******************************************************************************
//
// ExerciseContainerViewController.m
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