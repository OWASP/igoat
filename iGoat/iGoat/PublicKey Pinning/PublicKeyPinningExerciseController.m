#import "PublicKeyPinningExerciseController.h"
#import "JSON.h"

@implementation PublicKeyPinningExerciseController

NSString * const PUBLICKEYPINNING_USER_URL = @"https://localhost:8442/igoat/exercise/certificatePinning";
bool identityVerificationEnforced = false;

@synthesize firstNameField, lastNameField, ssnField;

- (IBAction)submit:(id) sender {
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    jsonWriter.humanReadable = YES;
    jsonWriter.sortKeys = YES;
    
    NSDictionary *accountInfo = [[NSDictionary alloc] initWithObjectsAndKeys:firstNameField.text, @"firstName", lastNameField.text, @"lastName", ssnField.text, @"socialSecurityNumber", nil];
    
    NSString *jsonString = [[NSString alloc] initWithString:[jsonWriter stringWithObject:accountInfo]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:PUBLICKEYPINNING_USER_URL]];
    responseData = [NSMutableData data];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"close" forHTTPHeaderField:@"Connection"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    // offending line of code goes here
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#pragma clang diagnostic pop
    // This line only exists to avoid a compiler warning (Unused Entity Issue).
    if (conn) {}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
    
    
    UIAlertController* alert;
    UIAlertAction* defaultAction;
        
    
    NSDictionary *headers = [(NSHTTPURLResponse *) response allHeaderFields];
    NSString *legitimateServer = [headers objectForKey:@"X-Goat-LegitimateServer"];
    if (legitimateServer == nil)
        legitimateServer = @"true";
    
    NSString *sslEnabled = [headers objectForKey:@"X-Goat-Secure"];
    if (sslEnabled == nil)
        sslEnabled = @"false";
    
    if ([legitimateServer boolValue]) {
        if (!identityVerificationEnforced) {
            
            alert = [UIAlertController alertControllerWithTitle:@"Verification Required"
                                                        message:@"In this exercise, the app must verify the server's identity."
                                                 preferredStyle:UIAlertControllerStyleAlert];
            defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
            
            
            
        }
        else {
            
            alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                        message:@"The app appears to be verifying the server's identity."
                                                 preferredStyle:UIAlertControllerStyleAlert];
            defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
            
            
        }
    } else {
        
        alert = [UIAlertController alertControllerWithTitle:@"Owned"
                                                    message:@"The user's account info was transitted to a malicious SSL server."
                                             preferredStyle:UIAlertControllerStyleAlert];
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {}];
        
        
    }
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Server reqest failed; see log for details."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"Request failed: %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    identityVerificationEnforced = false;
}


//******************************************************************************
// SOLUTION
//
// The legitimate iGoat SSL server listens on port: 8443 (SSL)
// The malicious SSL server listens on port: 8442 (SSL)
// In this simulation, the default implementation connects to 8442
// to illustrate a redirection to the malicious server
//
// To secure the POST to the /igoat/exercise/certificatePinning endpoint, change
// the PUBLICKEYPINNING_USER_URL constant at the top of the file to...
//
// "https://localhost:8442/igoat/exercise/certificatePinning"
//
// The NSURLConnection class will automatically wrap the connection in an SSL
// channel and the communication between client and server will be secure.
//
// See the documentation in igoat_server.rb for additional info.
//
// Here is how to get the certificate and public key and store it locally:
//
// 1. Connect to the legitimate SSL source and grab its certificate
// during the SSL handshake
//
// Use the following to fetch the cert. It will be in PEM format.
// PEM format is (--BEGIN CERTIFICATE--, --END CERTIFICATE--).
//   $ echo "Get HTTP/1.0" | openssl s_client -showcerts -connect localhost:8443
//
// Save the certifcate of interest to a file (for example, "iGoatSSLServer.pem").
// Convert the certifcate to DER format.
//
//   $ openssl x509 -in "iGoatSSLServer.pem" -inform PEM -out "iGoatSSLServer.der" -outform DER
//
// 2. Store that DER file as an embedded resource within the mobile app. In this solution,
// the iGoatSSLServer.der file contains the legitimate server's certifiate file.  You can find it
// as part of the 'Resources' logical folder contained within the root iGoat logical folder of the source tree.
//
// When it the app is deployed onto the iDevice, the DER file will sit within the app's sandbox
// at ./iGoat.app/iGoatSSLServer.der location
//
// 3. Replace the original authentication challenge delegate method "didReceiveAuthenticationChallenge"
// with the implementation below
//
// NOTE: the real tricky part is pulling out the public key from the certificate
// and comparing it against the locally stored ceritificate.
// The solution's delegate method uses a method, getPublicBitsFromKey, to extract this key
// from the DER. It's not pretty but this was the only solution I could find.
//
// Be sure to include that method getPublicBitsFromKey declared below too..
//
// 4. Extra credit: How do you protect the original DER file in the app from
// substitution?
//
// TIP: Verify your code is successfully identitying the legitimate server by switching
// between connections to port 8442 (malicious) and port 8443 (legitimate).
// Can your code tell the difference in the exposed public keys?
//
//******************************************************************************

/*
 static NSString *const CONSTANT_CERTIFICATE_FILE = @"iGoatSSLServer";
 
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 {
 if (connection == nil)
 {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: connection=nil");
 return;
 }
 
 if (challenge == nil)
 {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: challenge=nil");
 return;
 }
 
 if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust])
 {
 SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
 if(!(nil != serverTrust)) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: serverTrust=nil");
 return;
 }
 
 // Validate the trust
 OSStatus status = SecTrustEvaluate(serverTrust, NULL);
 if(errSecSuccess != status) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: errSecSuccess != status");
 return;
 }
 
 // Exract received public key from server trust
 SecKeyRef receivedPublicKeyRef = SecTrustCopyPublicKey(serverTrust);
 if(receivedPublicKeyRef == nil) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: receivedPublicKeyRef=nil");
 return;
 }
 
 NSData* receivedKeyData = [self getPublicKeyBitsFromKey:receivedPublicKeyRef];
 
 // Load stored public key
 NSString *file1 = [[NSBundle mainBundle] pathForResource:CONSTANT_CERTIFICATE_FILE ofType:@"der"];
 if(file1 == nil) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: file1=nil");
 return;
 }
 
 // Extract the data from the file resources
 NSData* cert1 = [NSData dataWithContentsOfFile:file1];
 if(cert1 == nil) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: cert1=nil");
 return;
 }
 
 // Create the certificate based on the DER representation
 SecCertificateRef certificate1Ref = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cert1);
 
 // Create trust based on the certificates
 SecPolicyRef policy1Ref = SecPolicyCreateBasicX509();
 SecTrustRef trust1Ref;
 status = SecTrustCreateWithCertificates(certificate1Ref, policy1Ref, &trust1Ref);
 if(errSecSuccess != status) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: errSecSuccess != status");
 return;
 }
 
 // Evaluate the trusts for validity
 status = SecTrustEvaluate(trust1Ref, NULL);
 if(errSecSuccess != status) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: errSecSuccess != status");
 return;
 }
 
 // Load key data from trust
 SecKeyRef calculatedPublicKey1Ref = SecTrustCopyPublicKey(trust1Ref);
 if(calculatedPublicKey1Ref == nil) {
 NSLog(@"PublicKetPinningExerciseController: didReceiveAuthenticationChallenge: calculatedPublicKey1Ref=nil");
 return;
 }
 NSData* calculatedKey1Data = [self getPublicKeyBitsFromKey:calculatedPublicKey1Ref];
 
 BOOL isEqualKey1Data = [receivedKeyData isEqualToData:calculatedKey1Data];
 identityVerificationEnforced = true;
 if (isEqualKey1Data)
 return [[challenge sender] useCredential: [NSURLCredential credentialForTrust: serverTrust]forAuthenticationChallenge: challenge];
 else
 {
 // Client successfully detected that the server is not the one it expects
 // You can do something additional here if you like
 }
 }
 
 return [[challenge sender] cancelAuthenticationChallenge: challenge];
 }
 
 - (NSData *)getPublicKeyBitsFromKey:(SecKeyRef)givenKey {
 
 static const uint8_t publicKeyIdentifier[] = "com.your.company.publickey";
 NSData *publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
 
 OSStatus sanityCheck = noErr;
 NSData * publicKeyBits = nil;
 
 NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
 [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
 [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
 [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
 
 // Temporarily add key to the Keychain, return as data:
 NSMutableDictionary * attributes = [queryPublicKey mutableCopy];
 [attributes setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
 [attributes setObject:@YES forKey:(__bridge id)kSecReturnData];
 CFTypeRef result;
 sanityCheck = SecItemAdd((__bridge CFDictionaryRef) attributes, &result);
 if (sanityCheck == errSecSuccess) {
 publicKeyBits = CFBridgingRelease(result);
 
 // Remove from Keychain again:
 (void)SecItemDelete((__bridge CFDictionaryRef) queryPublicKey);
 }
 
 return publicKeyBits;
 }
 */

@end

//******************************************************************************
//
// PublicKeyPinningExerciseController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2013 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC; Arxan Technologies
// Project Leader: Kenneth R. van Wyk (ken@krvw.com)
// Lead Developer: Jonathan Carter (jcarter@arxan.com)
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
