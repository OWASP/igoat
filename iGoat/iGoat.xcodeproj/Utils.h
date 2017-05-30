#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iGoatAppDelegate.h"

#define UIColorFromHex(hexValue) [UIColor \
    colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define AssetStore \
    ((iGoatAppDelegate *)[UIApplication sharedApplication].delegate).assetStore

@interface Utils : NSObject {
    
}

@end

//******************************************************************************
//
// Utils.h
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
