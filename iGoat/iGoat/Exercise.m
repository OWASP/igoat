#import "Exercise.h"

@implementation Exercise

@synthesize creditsFile, hints, hintIndex, totalHints, solution, category, initialViewController;

- (id)initWithName:(NSString *)assetName longDescription:(NSString *)desc creditsFile:(NSString *)filename hints:(NSMutableArray *)hintsArray solution:(NSString *)solutionText initialViewController:(NSString *)viewControllerName {

    if ((self = [self initWithName:assetName longDescription:desc])) {
        self.creditsFile = filename;
        self.hints = hintsArray;
        self.initialViewController = viewControllerName;
        self.hintIndex = 0;
        self.totalHints = [hintsArray count];
        self.solution = solutionText;
    }
    
    return self;
}

- (NSString *)htmlCredits {
    // Load the credits file as a string.
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:self.creditsFile ofType:nil];
    NSString *fileContentsAsString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    return fileContentsAsString;
}

// TODO: This duplicates code in Asset.htmlDescription(); try to refactor.
- (NSString *)htmlSolution {
    // Convert paragraph breaks to <br/><br/>.
    NSString *paraRegex = @"\n *\n";
    NSString *sol = [self.solution
                     stringByReplacingOccurrencesOfString:paraRegex withString:@"<br/><br/>"
                     options:NSRegularExpressionSearch | NSCaseInsensitiveSearch
                     range:NSMakeRange(0, [self.solution length])];
    
    // Insert the description into the context of a body tag and return full HTML.
    return [NSString stringWithFormat:HTML_BODY_TEMPLATE,
            [NSString stringWithFormat:@"<h2>%@ Solution</h2>%@", self.name, sol ? sol : @""]];

}

@end

//******************************************************************************
//
// Exercise.m
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
