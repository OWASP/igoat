//
//  WebkitCacheExerciseViewController
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/08/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebkitCacheExerciseViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonKeyDerivation.h>


#define kURL    @"http://localhost:8081/webkit.php"


const char cipher[] = {
    0xCF, 0x05, 0xCF, 0x7E, 0x09, 0x4D, 0x72, 0x5B,
    0x1D, 0x1E, 0xB5, 0x3F, 0xF0, 0x6F, 0x06, 0xF1};

const char salt[] = "0123456789";

const char sha2[] = {
    0x7E, 0x32, 0xA7, 0x29, 0xB1, 0x22, 0x6E, 0xD1,
    0x27, 0x0F, 0x28, 0x2A, 0x8C, 0x63, 0x05, 0x4D,
    0x09, 0xB2, 0x6B, 0xC9, 0xEC, 0x53, 0xEA, 0x69,
    0x77, 0x1C, 0xE3, 0x81, 0x58, 0xDF, 0xAD, 0xE8};

@interface WebkitCacheExerciseViewController ()


@property (weak, nonatomic) IBOutlet UILabel *encryptedLabel;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;


@end

@implementation WebkitCacheExerciseViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadRequest:nil];
}


-(void)loadRequest:(id)sender {

    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:kURL]];
    
    NSDictionary *headers = @{
                              @"Content-Type":@"application/x-www-form-urlencoded",
                              @"Accept":@"text/html,application/xhtml+xml,application/xml",
                              };
    
    request.HTTPBody = [@"token=key" dataUsingEncoding:NSUTF8StringEncoding];
    request.allHTTPHeaderFields = headers;
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"You need an internet connection to perform this task" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                                        
                                                    } else {
                                                        dispatch_async( dispatch_get_main_queue(), ^{
                                                            self.encryptedLabel.text = [[NSData dataWithBytes:cipher length:sizeof(cipher)] description];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}

- (IBAction)verify:(id)sender {
    
    const size_t dataOutLength = 500;
    char dataOut[dataOutLength] = {0};

    BOOL decrypt(NSString *key,
                 char *dataOut,
                 size_t *dataOutLength,
                 char *sha2digest);
    
    if(decrypt(self.keyTextField.text,
               dataOut,
               (size_t *)&dataOutLength,
               (char *)sha2)){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Congratulations"
                                                                       message:[NSString stringWithFormat:@"The secret pass is \"%@\"", [NSString stringWithUTF8String:dataOut]]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Key"
                                                                       message:@"Please try again!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


static BOOL decrypt(NSString *key,
                    char *dataOut,
                    size_t *dataOutLength,
                    char *sha2digest)
{
    // Key derivation
    const size_t keySize = 32; //sha256
    char keyBytes[keySize] = {0};
    char ivBytes[keySize] = {0};

    
    CCKeyDerivationPBKDF(kCCPBKDF2,
                         key.UTF8String,
                         key.length,
                         (uint8_t *)salt,
                         strlen(salt),
                         kCCPRFHmacAlgSHA256,
                         1000,
                         (uint8_t *)keyBytes,
                         keySize);
    
    // Decrypt the secret
    CCOperation mode =  kCCDecrypt;
    CCAlgorithm algo = kCCAlgorithmAES128;
    CCOptions padding = kCCOptionPKCS7Padding;
    
    size_t dataOutMoved  = 0;
    
    CCCrypt(mode,
            algo,
            padding,
            keyBytes,
            keySize,
            ivBytes,
            cipher,//inputBytes,
            sizeof(cipher),
            dataOut,
            *dataOutLength,
            &dataOutMoved
            );
    
    uint8_t digest[32] = {0};
    CC_SHA256(dataOut, (CC_LONG)dataOutMoved, digest);
    
    
    *dataOutLength = dataOutMoved;
    
    /* Validate hash */
    return memcmp(digest, sha2digest, 32) == 0;
}


@end
