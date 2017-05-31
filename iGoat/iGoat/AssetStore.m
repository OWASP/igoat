#import "AssetStore.h"
#import "Category.h"
#import "Exercise.h"

// TODO: Document the format of the Assets.plist file.
@implementation AssetStore

@synthesize categories;

- (id)init {
    categories = [[NSMutableArray alloc] init];

    // Load the assets from the Assets.plist file.
    NSString *assetsListPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Assets.plist"];
    NSDictionary *assets = [NSDictionary dictionaryWithContentsOfFile:assetsListPath];
    NSArray *exercisesArray;
    NSDictionary *categoryDict;
    
    for (id categoryName in assets) {
        categoryDict = [assets objectForKey:categoryName];
        exercisesArray = [categoryDict objectForKey:@"exercises"];

        ExerciseCategory *category = [[ExerciseCategory alloc] initWithName:categoryName longDescription:[categoryDict objectForKey:@"description"]];

        for (NSDictionary *exerciseDict in exercisesArray) {
            Exercise *exercise = [[Exercise alloc] initWithName:[exerciseDict objectForKey:@"name"]
                                                longDescription:[exerciseDict objectForKey:@"description"]
                                                    creditsFile:[exerciseDict objectForKey:@"creditsFile"]
                                                          hints:[exerciseDict objectForKey:@"hints"]
                                                       solution:[exerciseDict objectForKey:@"solution"]
                                          initialViewController:[exerciseDict objectForKey:@"initialViewController"]];

            [category.exercises addObject:exercise];
        }
        
        [categories addObject:category];
    }

    return self;
}

@end

//******************************************************************************
//
// AssetStore.m
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