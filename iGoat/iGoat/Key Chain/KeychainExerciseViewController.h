//
//  KeychainExerciseViewController.h
//  iGoat
//
//  Created by Mansi Sheth on 1/29/12.
//  Copyright (c) 2012 KRvW Associates, LLC. All rights reserved.
//

#import "ExerciseViewController.h"

@interface KeychainExerciseViewController : ExerciseViewController {

}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISwitch *switch_userDefault;
@property (weak, nonatomic) IBOutlet UISwitch *switch_keychain;

- (IBAction)storeButtonPressed:(id)sender;
- (IBAction)userDefaultSwitchDidClick:(UISwitch *)sender;
- (IBAction)keychainSwitchDidClick:(UISwitch *)sender;

@end

//******************************************************************************
//
// KeychainExerciseViewController.h
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
