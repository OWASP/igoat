#import "RootViewController.h"
#import "ExercisesViewController.h"
#import "InfoViewController.h"
#import "Utils.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show splash page on first launch (experimental still, KRvW).
    BOOL firstLaunch = [[[[NSBundle mainBundle] infoDictionary]
                         objectForKey:@"FirstLaunch"] boolValue];

    if (firstLaunch) {
        [self showInfoDialogWithContentFrom:@"splash.html"];

        // TODO: Set the FirstLaunch property to YES.
        // [[[NSBundle mainBundle] infoDictionary]
        //  setObject:[firstLaunch boolValue:"No"] objectForKey:@"FirstLaunch"];
    }

    // Configure the navigation bar at the top.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"Categories";

    // Configure the navigation toolbar at the bottom.
    UIBarButtonItem *flexibleSpaceItem = [[[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil action:nil] autorelease];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoDialog)
          forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *infoButtonItem = [[[UIBarButtonItem alloc]
                                         initWithCustomView:infoButton] autorelease];

    self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceItem, infoButtonItem, nil]; 
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    
    // Configure the table view.
    self.tableView.backgroundColor = UIColorFromHex(0x262b32);
    self.tableView.separatorColor = UIColorFromHex(0x262b32);
}

- (void)showInfoDialogWithContentFrom:(NSString *)filename {
    // Load the file as a string.
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSString *fileContentsAsString = [[NSString alloc]
                                      initWithContentsOfFile:path
                                      encoding:NSUTF8StringEncoding
                                      error:&error];
    
    // Insert the iGoat version number.
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *htmlString = [NSString stringWithFormat:fileContentsAsString, version];
    
    InfoViewController *infoViewController = [[InfoViewController alloc]
                                              initWithNibName:@"InfoViewController"
                                              bundle:nil infoText:htmlString];
    
    infoViewController.delegate = self;
    
    [self presentModalViewController:infoViewController animated:NO];
    [infoViewController release];
    [fileContentsAsString release];
}

- (void)showInfoDialog {
    [self showInfoDialogWithContentFrom:@"about.html"];
}

- (void)didDismissInfoDialog {
    [self dismissModalViewControllerAnimated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AssetStore.categories count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    UIImageView *selectedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320,100)];
    selectedBackground.backgroundColor = UIColorFromHex(0x3366CC);
    [cell setSelectedBackgroundView:selectedBackground];
    [[cell textLabel] setTextColor:UIColorFromHex(0xc3c3c3)];
    [[cell textLabel] setText:[[AssetStore.categories objectAtIndex:indexPath.row] description]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExercisesViewController *exercisesViewController =
        [[ExercisesViewController alloc] initWithNibName:@"ExercisesViewController" bundle:nil
                                                category:[AssetStore.categories
                                                          objectAtIndex:indexPath.row]];

    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:exercisesViewController animated:YES];
    [exercisesViewController release];
}

@end

//******************************************************************************
//
// RootViewController.m
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