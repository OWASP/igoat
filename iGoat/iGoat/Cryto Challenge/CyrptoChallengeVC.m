

#import "CyrptoChallengeVC.h"
#import "UIAlertController+EasyBlock.h"

@interface CyrptoChallengeVC ()

@end

static NSString *successMessage = @"You bought iPhone in ZERO";
static NSString *failureMessage = @"Fail! Checksum doen't match.";

@implementation CyrptoChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)buyItemPressed:(id)sender {

    NSURL *url = [NSURL URLWithString:@"http://13.59.35.177/crypto1/checkout.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                    timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        [self failedWithError:error];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                        BOOL success = [self isSuccessfulResponseString:responseString];
                                                        [self showMessageFromResponseString:responseString isSuccessful:success];
                                                    }
                                                }];
    [dataTask resume];
}

-(BOOL)isSuccessfulResponseString:(NSString *)responseString {
    if ([responseString rangeOfString:failureMessage].location != NSNotFound) {
        return false;
    }
    else if ([responseString rangeOfString:successMessage].location != NSNotFound) {
        return true;
    }
    else {
        return false;
    }
}

-(void)showMessageFromResponseString:(NSString *)responseString isSuccessful:(BOOL)success {
    NSString *message = nil;
    if (success) {
        NSRange prefixRange = [responseString rangeOfString:@"dollar!"];
        NSString *flagString = [responseString substringFromIndex:prefixRange.location+prefixRange.length];
        flagString = [flagString substringToIndex:[flagString rangeOfString:@"</bab>"].location];
        message = flagString;
    } else {
        message = failureMessage;
    }
    [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert
                   cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:nil];
}

-(void)failedWithError:(NSError *)error {
    NSString *message = error.localizedDescription;
    [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert
                   cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:nil];
}

@end
