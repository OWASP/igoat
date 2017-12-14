#import "StringAnalysisExerciseController.h"

@implementation StringAnalysisExerciseController

@synthesize answerField;

// Before jumping to the variable defintion and getting the answer,
// try to do a proper string analysis of the binary and determine the
// answer correctly.

__obfuscated NSString* StringAnalysisExercise = @"secret plaintext riddle answer: To prove it wasn't chicken";


- (IBAction)submit:(id)sender {
    
    if ([Deobfuscate(StringAnalysisExercise) rangeOfString:answerField.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                                       message:@"You appear to have protected the answer against string analysis"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Incorrect!"
                                                                       message:@"Look at the hints if you're having trouble analyzing the binary for the answer"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end

//******************************************************************************
//
// StringAnalysisExerciseController.m
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
