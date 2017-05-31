#import "HintsViewController.h"
#import "Exercise.h"
#import "Utils.h"

@implementation HintsViewController

@synthesize scrollView, pageControl, exercise = _exercise;

- (void)setExercise:(Exercise *)newExercise {
    _exercise = newExercise;

    // Reset the hint index on the exercise.
    _exercise.hintIndex = 0;

    // Set the content to the first hint.
    [self setContent:(NSString *)[_exercise.hints objectAtIndex:_exercise.hintIndex]];
}

- (void)viewDidLoad {
    // Configure the swipe gesture recognizers.
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadPreviousHint)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadNextHint)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:recognizer];

    // Configure the page controller.
    self.pageControl.numberOfPages = self.exercise.totalHints;
    self.pageControl.currentPage = 0;
    self.pageControl.defersCurrentPageDisplay = YES;
    // self.pageControl.backgroundColor = UIColorFromHex(0x262b32);

    [self.pageControl addTarget:self action:@selector(pageDidChangeAction) forControlEvents:UIControlEventValueChanged];

    [super viewDidLoad];
}

- (void)pageDidChangeAction {
    NSInteger page = self.pageControl.currentPage;
    NSInteger idx = self.exercise.hintIndex;

    [self.pageControl updateCurrentPageDisplay];

    if (page > idx) {
        [self loadNextHint];
    } else if (page < idx) {
        [self loadPreviousHint];
    }
}

- (void)loadNextHint {
    NSInteger idx = self.exercise.hintIndex + 1;

    if (idx < self.exercise.totalHints) {
        self.exercise.hintIndex = idx;
        self.pageControl.currentPage = idx;
        [self setContent:(NSString *)[self.exercise.hints objectAtIndex:(idx)]];
    }
}

- (void)loadPreviousHint {
    NSInteger idx = self.exercise.hintIndex - 1;
    
    if (idx >= 0) {
        self.exercise.hintIndex = idx;
        self.pageControl.currentPage = idx;
        [self setContent:(NSString *)[self.exercise.hints objectAtIndex:(idx)]];
    }
}

// TODO: This is kinda hacky.
- (NSString *)formatAsHtml:(NSString *)text {
    if ([text hasPrefix:@"<html>"]) {
        return text;
    } else {
        return [NSString stringWithFormat:@"<html><head>"
                "<link href=\"igoat.css\" rel=\"stylesheet\" type=\"text/css\">"
                "<head><body><h2>%@ (%d/%d)</h2>%@</body></html>",
                self.exercise.name, (int)(self.exercise.hintIndex + 1), (int)self.exercise.totalHints, text];
    }
}

@end

//******************************************************************************
//
// HintsViewController.m
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