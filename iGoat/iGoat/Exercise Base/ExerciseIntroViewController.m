#import "ExerciseIntroViewController.h"
#import "ExerciseViewController.h"
#import "InfoViewController.h"
#import "Exercise.h"
#import "Utils.h"

@implementation ExerciseIntroViewController

@synthesize exercise, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil exercise:(Exercise *)ex {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.exercise = ex;
    }
    
    return self;
}

- (void)dealloc {
    [exercise release];
    [webView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the navigation bar at the top.
    self.navigationItem.title = @"Introduction";

    UIBarButtonItem *homeButton = [[[UIBarButtonItem alloc]
                                    initWithTitle:@"Home" style:UIBarButtonItemStyleBordered
                                    target:self action:@selector(goHome)] autorelease];
    
    self.navigationItem.rightBarButtonItem = homeButton;
    
    // Configure the navigation toolbar at the bottom.
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];

    UIBarButtonItem *creditsButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Credits"
                                      style:UIBarButtonItemStyleBordered
                                      target:self action:@selector(showInfoDialog)];

    UIBarButtonItem *startButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Start Exercise"
                                    style:UIBarButtonItemStyleBordered
                                    target:self action:@selector(startExercise)];

    self.toolbarItems = [NSArray arrayWithObjects:creditsButton, flexibleSpaceItem, startButton, nil]; 
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;

    [startButton release];
    [flexibleSpaceItem release];
    [creditsButton release];

    // Configure the main view.
    self.view.backgroundColor = UIColorFromHex(0x262b32);

    // Configure the web view (with the exercise intro HTML).
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    [self.webView loadHTMLString:exercise.htmlDescription baseURL:baseURL];
    
    [baseURL release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.exercise = nil;
    self.webView = nil;
}

- (void)goHome {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)startExercise {
    // Load the initial view controller for this exercise by name.
    ExerciseViewController *controller = [[NSClassFromString(self.exercise.initialViewController) alloc]
                                          initWithNibName:self.exercise.initialViewController
                                          bundle:nil exercise:self.exercise];

    if (controller) {
        // Push the view controller onto the navigation stack.
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    } else {
        // Display an alert dialog if the controller is nil, which likely means that the exercise
        // hasn't yet been implemented.
        UIAlertView *alert = [[[UIAlertView alloc]
                               initWithTitle:@"Snap!" message:@"Exercise not yet implemented."
                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        [alert release];
    }
}

- (void)showInfoDialog {
    InfoViewController *infoViewController = [[InfoViewController alloc]
                                              initWithNibName:@"InfoViewController"
                                              bundle:nil infoText:exercise.htmlCredits];
    
    infoViewController.delegate = self;
    
    [self presentModalViewController:infoViewController animated:NO];
    [infoViewController release];
}

- (void)didDismissInfoDialog {
    [self dismissModalViewControllerAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//******************************************************************************
//
// ExerciseIntroViewController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2011 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC
// Project Leader, Kenneth R. van Wyk (ken@krvw.com)
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
// Getting Source
//
// The source for iGoat is maintained at http://code.google.com/p/owasp-igoat/
//
// For project details, please see https://www.owasp.org/index.php/OWASP_iGoat_Project
//
//******************************************************************************