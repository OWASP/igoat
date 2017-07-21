#import "BackgroundingExerciseController.h"

@implementation BackgroundingExerciseController

@synthesize cityField, colorField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//******************************************************************************
// SOLUTION
//
// Register to listen for notifications in the initWithNibName() override...
//
// [[NSNotificationCenter defaultCenter] addObserver:self
//  selector:@selector(didEnterBackground:) name:@"didEnterBackground" 
//  object:nil];
//
// [[NSNotificationCenter defaultCenter] addObserver:self
//  selector:@selector(didBecomeActive:) name:@"didBecomeActive" 
//  object:nil];
//
// Don't forget to remove the observers in a dealloc() method, which should look
//  something like:
//      - (void)dealloc:(NSString *)nibNameOrNil 
//          {
//              [[NSNotificationCenter defaultCenter] 
//                  removeObserver:self name:@"didEnterBackground" object:nil];
//              [[NSNotificationCenter defaultCenter] 
//                  removeObserver:self name:@"didBecomeActive" object:nil];
//          }
//
// While this isn't a necessity, it is a good practice.
//
// And uncomment the methods below. These are the observer methods that
// you've defined above.
//
//******************************************************************************

/*
- (void)didEnterBackground:(NSNotification *)notification {
    self.cityField.hidden = YES;
    self.colorField.hidden = YES;
}

- (void)didBecomeActive:(NSNotification *)notification {
    self.cityField.hidden = NO;
    self.colorField.hidden = NO;
}
*/

@end

//******************************************************************************
//
// BackgroundingExerciseController.m
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