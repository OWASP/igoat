#import "HtmlViewController.h"

@implementation HtmlViewController

@synthesize webView, content = _content;

- (void)viewDidLoad {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];

    if (_content) {
        // Render the existing content in the web view.
        [self.webView loadHTMLString:_content baseURL:baseURL];
    } else {
        // Display the "About iGoat" splash screen as a default.
        NSError *error;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"splash.html" ofType: nil];
        NSString *fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        [self.webView loadHTMLString:[NSString stringWithFormat:fileContents, version] baseURL:baseURL];
    }
    
    [super viewDidLoad];
}

- (void)setContent:(NSString *)newContent {
    // Format the content as HTML if necessary.
    _content = [self formatAsHtml:newContent];

    // Render the content in the web view.
    // TODO: DRY this up (see above).
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    [self.webView loadHTMLString:_content baseURL:baseURL];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations

#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


// TODO: This is kinda hacky.
- (NSString *)formatAsHtml:(NSString *)content {
    if ([content hasPrefix:@"<html>"]) {
        return content;
    } else {
        return [NSString stringWithFormat:@"<html><head>"
                "<link href=\"igoat.css\" rel=\"stylesheet\" type=\"text/css\">"
                "<head><body>%@</body></html>", content];
    }
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