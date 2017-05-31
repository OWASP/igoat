#import "SQLInjectionExerciseController.h"
#import "SQLInjectionArticlesViewController.h"
#import <sqlite3.h>

@implementation SQLInjectionExerciseController

@synthesize searchField;

- (IBAction)search:(id)sender {
    // Search the database for articles matching the search string.
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"articles.sqlite"];

    sqlite3 *db;
	const char *path = [dbPath UTF8String];
	
	if (sqlite3_open(path, &db) != SQLITE_OK) {
        [self displayAlertWithTitle:@"Snap!" message:@"Error opening articles database."];
        return;
    }

    NSString *searchString = [self.searchField.text length] > 0 ? [NSString stringWithFormat:@"%@%@%@", @"%", self.searchField.text, @"%"] : @"%";
    NSString *query = [NSString stringWithFormat:@"SELECT title FROM article WHERE title LIKE '%@' AND premium=0", searchString];

    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil);

    NSMutableArray *articleTitles = [[NSMutableArray alloc] init];

    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSString *title = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        [articleTitles addObject:title];
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(db);

    // Create the articles (table) controller.
    SQLInjectionArticlesViewController *articlesController = [[SQLInjectionArticlesViewController alloc] initWithNibName:@"SQLInjectionArticlesViewController" bundle: nil articleTitles:articleTitles];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:articlesController animated:YES];
}

//******************************************************************************
// SOLUTION
//
// To exploit the problem, try entering the following string in the search
// field...
//
// ' OR 1=1 --
//
// All free AND premium articles should show up in the search results.
//
// Rather than using stringWithFormat() to create the query string, use the
// built-in sqlite3_bind_text() method, which automatically sanitizes query
// parameters.
//
// In the search() method above, replace the query definition with...
//
// NSString *query = @"SELECT title FROM article WHERE title LIKE ? AND premium=0";
//
// Then, immediately after calling sqlite3_prepare_v2()...
//
// sqlite3_bind_text(stmt, 1, [searchString UTF8String], -1, SQLITE_TRANSIENT);
//
// This binds the search string to the query in a safe manner.
//******************************************************************************

@end

//******************************************************************************
//
// SQLInjectionExerciseController.m
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