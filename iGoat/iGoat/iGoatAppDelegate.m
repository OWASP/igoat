#import "iGoatAppDelegate.h"
#import "AssetStore.h"

@implementation iGoatAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize assetStore;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize all of the static asset data.
    assetStore = [[AssetStore alloc] init];
    
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Send out a notification that we've been backgrounded.
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"didEnterBackground" object:nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Send out a notification that we've become active (after having been backgrounded).
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"didBecomeActive" object:nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)dealloc {
    [_window release];
    [_navigationController release];
    [assetStore release];
    [super dealloc];
}

@end

//******************************************************************************
//
// iGoatAppDelegate.m
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