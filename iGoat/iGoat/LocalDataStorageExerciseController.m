#import "LocalDataStorageExerciseController.h"
#import <sqlite3.h>

@implementation LocalDataStorageExerciseController

@synthesize usernameField, passwordField, credentialStorageSwitch;

- (IBAction)submit:(id)sender {
    NSString *username = [[NSString alloc] initWithString:usernameField.text];
	NSString *password = [[NSString alloc] initWithString:passwordField.text];
	
	if (credentialStorageSwitch.on) {
        [self storeCredentialsForUsername:username withPassword:password];
	}
	
	usernameField.text = @"";
	passwordField.text = @"";
}

- (void)storeCredentialsForUsername:(NSString *)username withPassword:(NSString *)password {
    // Write the credentials to a SQLite database.
	sqlite3 *credentialsDB;
	const char *path = [[self getPathForFilename:@"credentials.sqlite"] UTF8String];
	
	if (sqlite3_open(path, &credentialsDB) == SQLITE_OK) {
		sqlite3_stmt *compiledStmt;
        
        //sqlite3_exec(credentialsDB, "PRAGMA key = 'secretKey!'", NULL, NULL, NULL);
		// Create the table if it doesn't exist.
		const char *createStmt = 
            "CREATE TABLE IF NOT EXISTS creds (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT);";
        
		sqlite3_exec(credentialsDB, createStmt, NULL, NULL, NULL);
		
		// Check to see if the user exists; update if yes, add if no.
		const char *queryStmt = "SELECT id FROM creds WHERE username=?";
		int userID = -1;
        
		if (sqlite3_prepare_v2(credentialsDB, queryStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			sqlite3_bind_text(compiledStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
			while (sqlite3_step(compiledStmt) == SQLITE_ROW) {
				userID = sqlite3_column_int(compiledStmt, 0);
			}
            
            sqlite3_finalize(compiledStmt);
		}
        
		const char *addUpdateStmt;
        
		if (userID >= 0) {
			addUpdateStmt = "UPDATE creds SET username=?, password=? WHERE id=?";
		} else {
			addUpdateStmt = "INSERT INTO creds(username, password) VALUES(?, ?)";
		}
        
        if (sqlite3_prepare_v2(credentialsDB, addUpdateStmt, -1, &compiledStmt, NULL) == SQLITE_OK) {
			sqlite3_bind_text(compiledStmt, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(compiledStmt, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
            
			if (userID >= 0) sqlite3_bind_int(compiledStmt, 3, userID);
			if (sqlite3_step(compiledStmt) != SQLITE_DONE) {
				NSLog(@"Error storing credentials in SQLite database.");
			}
		}
		
		// Clean things up.
		if (compiledStmt && credentialsDB) {
			if (sqlite3_finalize(compiledStmt) != SQLITE_OK) {				
				NSLog(@"Error finalizing SQLite compiled statement.");
			} else if (sqlite3_close(credentialsDB) != SQLITE_OK) {
                NSLog(@"Error closing SQLite database.");
            }
            
		} else {
			NSLog(@"Error closing SQLite database.");
		}
	}
}

//******************************************************************************
// SOLUTION
//
// First, pull in the necessary external libraries by following the instructions
// outlined in the HOWTO below.
//
// http://code.google.com/p/owasp-igoat/wiki/BuildingiGoatWithSQLcipher
//
// Next, the existing, unencrypted "credentials.sqlite" file must be deleted
// either from the device or the simulator filesystem. If this file isn't
// deleted, it won't be encrypted after implementing the solution. In other
// words, you can't encrypt an existing, unencrypted SQLite database.
//
// Finally, immediately after opening the database and before executing the
// create table statement, make the following call to "key" the database (on
// line 31).
//
// sqlite3_exec(credentialsDB, "PRAGMA key = 'secretKey!'", NULL, NULL, NULL);
//
// Obviously it's not a good idea to hard-code the secret key. Rather, it should
// be acquired out-of-band (user input, for example).
//
// That's pretty much it. Notice that the "credentials.sqlite" file is now
// encrypted and unreadable.
//******************************************************************************

@end

//******************************************************************************
//
// LocalDataStorageExerciseController.m
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
