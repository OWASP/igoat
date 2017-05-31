#import "Asset.h"

NSString * const HTML_BODY_TEMPLATE =
    @"<html>"
    "<head>"
    "  <link href=\"igoat.css\" rel=\"stylesheet\" type=\"text/css\">"
    "</head>"
    "<body>"
    "%@"
    "</body>"
    "</html>";

@implementation Asset

@synthesize name, longDescription;

- (id)initWithName:(NSString *)assetName {
    if ((self = [super init])) {
        self.name = assetName;
    }

    return self;
}

- (id)initWithName:(NSString *)assetName longDescription:(NSString *)desc {
    if ((self = [self initWithName:assetName])) {
        self.longDescription = desc;
    }

    return self;
}

- (NSString *)description {
    return self.name;
}

- (NSString *)htmlDescription {
    // Convert paragraph breaks to <br/><br/>.
    NSString *paraRegex = @"\n *\n";
    NSString *desc = [self.longDescription
                      stringByReplacingOccurrencesOfString:paraRegex withString:@"<br/><br/>"
                      options:NSRegularExpressionSearch | NSCaseInsensitiveSearch
                      range:NSMakeRange(0, [self.longDescription length])];

    // Insert the description into the context of a body tag and return full HTML.
    return [NSString stringWithFormat:HTML_BODY_TEMPLATE, [NSString stringWithFormat:@"<h1>%@</h1>%@", self.name, desc]];
}

@end

//******************************************************************************
//
// Asset.m
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