#import "StringAnalysisExerciseController.h"

@implementation StringAnalysisExerciseController

@synthesize answerField;

// Before jumping to the variable defintion and getting the answer,
// try to do a proper string analysis of the binary and determine the
// answer correctly.

- (NSString*) retrieveStringTableEntry {
    return StringAnalysisExercise;
}

- (BOOL) isPlaintextStringTableEntry {
    NSString* stringTableEntry = [self retrieveStringTableEntry];
    return ([stringTableEntry rangeOfString:@"plaintext" options:NSCaseInsensitiveSearch].location != NSNotFound);
}

- (IBAction)submit:(id)sender {
    
    if ([self isValidResponse:answerField.text]) {
        if ([self isPlaintextStringTableEntry]) {
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Almost there..."
                                                                           message:@"How can you change the string table entry to not store the plaintext answer?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        else {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Congratulations!"
                                                                           message:@"You appear to have protected the answer against string analysis"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Incorrect!"
                                                                       message:@"Look at the hints if you're having trouble analyzing the binary for the answer"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
}

// To use the solution coded below, begin cutting off and repalcing here

NSString* StringAnalysisExercise = @"secret plaintext riddle answer: To prove it was not chicken";

- (BOOL) isValidResponse:(NSString*)proposedResponse {
    NSString* stringTableEntry = [self retrieveStringTableEntry];
    return ([stringTableEntry rangeOfString:proposedResponse options:NSCaseInsensitiveSearch].location != NSNotFound);
}

//******************************************************************************
// SOLUTION
//
// There are a number of different strategies you could employ to solve this problem.
// In the solution below, we use a hardcoded BASE64 encoded string that represents an
// encrypted form of the string that is encrypted using a simple XOR algorithm with the
// hardcoded key "iGoat"
//
// Replace the hardcoded string 'StringAnalysisExercise' with its equivalent below
// Replace the isValidResponse method with the implementation below
// Add the new transform method below to perform basic XOR encryption / decryption
//
// There are a number of other things to think about with this solution to make
// things harder to reverse. For instance, you could move the string out of the string table entirely
// and represent it as an array of hardcoded bytes.  Then, apply an XOR
// encryption to the array of byes and store that within the binary instead.
//
// You'd also want to think about method names, preventing swizzling, etc.
// Other exercises will help you tackle those issues too...
//******************************************************************************


// In real life, you'd want to avoid having this method exposed to a hacker. If it
// must be exposed, give it a name that will not attract attention from someone doing
// basic static analysis

/*
 NSString* StringAnalysisExercise = @"EhEKNQoVVBsuCwUYDGcfDRUAKRsEDB1nDg8HHiIdW1Q9KE8RBgYxCkEdHWcYAAcHYBtBFwEuDAoRBw==";
 
 - (void)transform:(NSData *)input
 {
 NSString* key = @"iGoat";
 unsigned char* pBytesInput = (unsigned char*)[input bytes];
 unsigned char* pBytesKey = (unsigned char*)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
 unsigned int vlen = [input length];
 unsigned int klen = [key length];
 unsigned int v = 0;
 unsigned int k = vlen % klen;
 unsigned char c;
 for (v; v < vlen; v++) {
 c = pBytesInput[v] ^ pBytesKey[k];
 pBytesInput[v] = c;
 k = (++k < klen ? k : 0);
 }
 }
 
 - (BOOL) isValidResponse:(NSString *)proposedResponse {
 NSString* stringTableEntryInput = [self retrieveStringTableEntry];
 NSData *data = [[NSData alloc] initWithBase64EncodedString:stringTableEntryInput options:0];
 
 // Try to 'decrypt' the buffer, transformation happens in-place.
 [self transform:data];
 
 // See if it got transformed back ok.
 NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 
 return ([result rangeOfString:proposedResponse options:NSCaseInsensitiveSearch].location != NSNotFound);
 }
 */

@end

//******************************************************************************
//
// StringAnalysisExerciseController.m
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
