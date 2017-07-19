#import "KeystrokeLoggingExerciseController.h"

@interface KeystrokeLoggingExerciseController ()

@end

@implementation KeystrokeLoggingExerciseController

@synthesize subjectField, messageField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
 
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end

//******************************************************************************
// SOLUTION
// 
// In the viewDidLoad function override set the Autocorrection on both
// textfields to NO, like this:
//
// [subjectField setAutocorrectionType: UITextAutocorrectionTypeNo];
// [messageField setAutocorrectionType:UITextAutocorrectionTypeNo];
//
// You have to do it there specifically, if you do it earlier, in for example
// the initWithNibName function, it cannot affect the view since it is not done
// loading yet.
//
// Another possible solution is to set the Autocorrection to NO in the Interface
// Builder. To do this, select the each UITextField in the
// KeystrokeLoggingExercise XIBs and go to the attibutes inspector. In here you
// can select the value for 'Correction'.
//
// NOTE: This is only a partial solution to the problem! Did you notice not all
// the typed information is protected from being logged? We've found some
// workarounds to this behavior, but there is always some information leakage
// via the keylogging mechanism. The good news is that on a real device, the
// keylogging is outside of the sandbox, and (more importantly), there's no
// clear context to the information stored in the log. It's far from perfect,
// however.
//
//******************************************************************************

//******************************************************************************
//
// KeystrokeLoggingExerciseController.m
// Created by rutger_i on 5/23/12.
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
