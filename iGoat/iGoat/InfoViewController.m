#import "RootViewController.h"
#import "InfoViewController.h"

@implementation InfoViewController

@synthesize infoWebView;
@synthesize infoText;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil infoText:(NSString *)text {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.infoText = text;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHtmlString:infoText];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.infoWebView = nil;
}

- (void)loadHtmlString:(NSString *)text {
    // Render the HTML string in the associated UIWebView.
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    [self.infoWebView loadHTMLString:[self formatAsHtml:text] baseURL:baseURL];
    [baseURL release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissDialog:(id)sender {
    [delegate didDismissInfoDialog];
}

// TODO: This is kinda hacky.
- (NSString *)formatAsHtml:(NSString *)text {
    if ([text hasPrefix:@"<html>"]) {
        return text;
    } else {
        return [NSString stringWithFormat:@"<html><head>"
                "<link href=\"igoat.css\" rel=\"stylesheet\" type=\"text/css\">"
                "<head><body>%@</body></html>", text];
    }
}

- (void)dealloc {
    [infoWebView release];
    [infoText release];
    [super dealloc];
}

@end

//******************************************************************************
//
// InfoViewController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2011 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC
// Project Leader, Kenneth R. van Wyk (ken@krvw.com)
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
// Getting Source
//
// The source for iGoat is maintained at http://code.google.com/p/owasp-igoat/
//
// For project details, please see https://www.owasp.org/index.php/OWASP_iGoat_Project
//
//******************************************************************************