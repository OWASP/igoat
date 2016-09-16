#import "CutAndPasteExerciseController.h"

@implementation CutAndPasteExerciseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

//******************************************************************************
// SOLUTION
//
// There are several ways of handling this situation. What we've chosen here is
// to store the cut and paste buffer contents into a local instance variable 
// (pastboardContents) prior to backgrounding the app. Then, on return, we put
// those stored contents back into the buffer. That way, the feature can
// still be used within the application.
//
// NOTE: Using this approach will also overwrite any buffer contents from other
// apps that the user may want to use inside of ours. It may be best to verify
// the buffer is empty before overwriting it upon returning to the app. We have
// NOT done that here, however. If you choose to do so, look at the
// didBecomeActive method below.
//
// TODO: Presently, there's no guarantee that the contents of the local
// instance variable won't be cleared while the app is in the background.
// Therefore, when the app is backgrounded, the contents of the pasteboard
// are simply overwritten with an empty string. We should find a secure way to
// reliably persist the contents and restore them when the app is brought back
// into the foreground.
//
// Register to listen for background notifications in the initWithNibName()
// override...
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
    // TODO: Find reliable way to persist the contents of the pasteboard when
    // entering the background. For now, simply clear it.
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // self.pasteboardContents = pasteboard.string;
    pasteboard.string = @"";
}
 
- (void)didBecomeActive:(NSNotification *)notification {
    // TODO: Find reliable way to restore the contents of the pasteboard when
    // entering the background. For now, don't bother.
}
*/

@end

//******************************************************************************
//
// CutAndPasteExerciseController.m
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