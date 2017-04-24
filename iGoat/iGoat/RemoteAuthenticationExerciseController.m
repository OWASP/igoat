#import "RemoteAuthenticationExerciseController.h"

@implementation RemoteAuthenticationExerciseController

NSString * const TOKEN_URL = @"http://localhost:8080/igoat/token?username=%@&password=%@";

@synthesize usernameField, passwordField;

- (IBAction)submit:(id)sender {
    NSString *urlWithParams = [NSString stringWithFormat:TOKEN_URL, usernameField.text, passwordField.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlWithParams]];
    
    [request setHTTPMethod:@"GET"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    // offending line of code goes here
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#pragma clang diagnostic pop
    
    // This line only exists to avoid a compiler warning (Unused Entity Issue).
    if (conn) {}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    UIAlertController* alert;
    UIAlertAction* defaultAction;
    
    NSDictionary *headers = [(NSHTTPURLResponse *) response allHeaderFields];
    NSString *sslEnabled = [headers objectForKey:@"X-Goat-Secure"];
    
    if ([sslEnabled boolValue]) {
        
        alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                    message:@"The user's authentication credentials were protected in transit."
                                             preferredStyle:UIAlertControllerStyleAlert];
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {}];
        
        
    } else {
        
        alert = [UIAlertController alertControllerWithTitle:@"Owned"
                                                    message:@"The user's authentication credentials were stolen by someone on your Wi-Fi!"
                                             preferredStyle:UIAlertControllerStyleAlert];
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {}];
    }
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Server reqest failed; see log for details."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"Request failed: %@ %@", [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

//******************************************************************************
// SOLUTION
//
// The iGoat server listens on two separate ports simultaneously; 8443 (SSL)
// and 8080 (non-SSL). To secure the GET to the /igoat/token endpoint, change
// the TOKEN_URL constant at the top of the file to...
//
// "https://localhost:8443/igoat/token?username=%@&password=%@"
//
// The NSURLConnection class will automatically wrap the connection in an SSL
// channel and the communication between client and server will be secure.
//
// This includes GET parameters, which this exercise uses to submit the
// username and password to the server (for the sake demonstration). In general,
// it's best not to use GET parameters for sensitive data because, although
// they're encrypted in-transit with SSL, they often show up in server logs in
// plaintext.
//
// See the documentation in igoat_server.rb for additional info.
//
// Additionally, uncomment the two methods defined below to instruct the
// NSURLConnection to ignore the fact that the iGoat server is using a
// self-signed certificate. Normally you would NOT want to do this in a
// production environment.
//******************************************************************************

/*
 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
 return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
 }
 */

@end

//******************************************************************************
//
// RemoteAuthenticationExerciseController.m
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
