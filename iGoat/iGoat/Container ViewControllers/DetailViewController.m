#import "DetailViewController.h"
#import "ExerciseContainerViewController.h"
#import "HtmlViewController.h"

@interface DetailViewController ()
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// offending line of code goes here
@property (strong, nonatomic) UIPopoverController *categoriesPopoverController;
#pragma clang diagnostic pop

- (void)configureView;

@end

@implementation DetailViewController

@synthesize webView, startButton, creditsButton, exercise = _exercise;

- (void)setExercise:(Exercise *)newExercise {
    _exercise = newExercise;
    
    // Update the view and dismiss the popover menu.
    [self configureView];

    if (self.categoriesPopoverController != nil) {
        [self.categoriesPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView {
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES];

    if (self.exercise) {
        // Set the title and enable the start/credits buttons.
        [self.navigationItem setTitle:@"Introduction"];
        [self.startButton setEnabled:YES];
        [self.creditsButton setEnabled:YES];

        // Set the HTML on the web view to the intro text.
        [self.webView loadHTMLString:[self.exercise htmlDescription] baseURL:baseURL];

    } else {
        // Show the slash page if no exercise specified.
        [self.navigationItem setTitle:@"About iGoat"];
        [self.startButton setEnabled:NO];
        [self.creditsButton setEnabled:NO];
        
        NSError *error;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"splash.html" ofType: nil];
        NSString *fileContentsAsString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        [self.webView loadHTMLString:[NSString stringWithFormat:fileContentsAsString, version] baseURL:baseURL];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = [segue identifier];
    
    if ([identifier isEqualToString:@"startExercise"]) {
        ExerciseContainerViewController *container = [segue destinationViewController];
        container.exercise = self.exercise;
    } else if ([identifier isEqualToString:@"showCredits"]) {
        HtmlViewController *controller = [segue destinationViewController];
        controller.content = [self.exercise htmlCredits];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// offending line of code goes here
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {

    barButtonItem.title = NSLocalizedString(@"Categories", @"Categories");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.categoriesPopoverController = popoverController;
}

#pragma clang diagnostic pop

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {

    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.categoriesPopoverController = nil;
}

@end

//******************************************************************************
//
// DetailViewController.m
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
