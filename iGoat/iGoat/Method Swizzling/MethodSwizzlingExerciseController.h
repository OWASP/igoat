#import <UIKit/UIKit.h>
#import "ExerciseViewController.h"

@interface MethodSwizzlingExerciseController : ExerciseViewController {
    // UI Widgets
    UILabel* m_fetchedLabel;
    UIButton* m_fetchButton;
}

@property (nonatomic, retain) IBOutlet UISwitch* m_JailbreakEvasionSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* m_fakeJailbrokenEnvironmentSwitch;
@property (nonatomic, retain) IBOutlet UILabel* m_fetchedLabel;
@property (nonatomic, retain) IBOutlet UIButton* m_fetchButton;

-(IBAction)fetchButtonTapped:(id)sender;

@end

//******************************************************************************
//
// MethodSwizzlingExerciseController.h
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2013 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC
// Project Leader: Kenneth R. van Wyk (ken@krvw.com)
// Lead Developer: Jonathan Carter (jcarter@arxan.com)
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