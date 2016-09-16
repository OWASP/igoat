#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Asset.h"
#import "Category.h"

@interface Exercise : Asset {

}

@property (strong, nonatomic) NSString *creditsFile;
@property (strong, nonatomic) NSMutableArray *hints;
@property (nonatomic) NSInteger hintIndex;
@property (nonatomic) NSInteger totalHints;
@property (strong, nonatomic) NSString *solution;
@property (strong, nonatomic) ExerciseCategory *category;
@property (strong, nonatomic) NSString *initialViewController;

- (id)initWithName:(NSString *)assetName longDescription:(NSString *)desc creditsFile:(NSString *)filename hints:(NSMutableArray *)hintsArray solution:(NSString *)solutionText initialViewController:(NSString *)viewControllerName;
- (NSString *)htmlCredits;
- (NSString *)htmlSolution;

@end

//******************************************************************************
//
// Exercise.h
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