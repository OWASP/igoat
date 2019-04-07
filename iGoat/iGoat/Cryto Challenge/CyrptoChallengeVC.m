

#import "CyrptoChallengeVC.h"
#import "UIAlertController+EasyBlock.h"

@interface CyrptoChallengeVC ()

@end

static NSString *successMessage = @"You bought iPhone in ZERO";
static NSString *failureMessage = @"Fail! You didn't purchase iPhone for $0";

@implementation CyrptoChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)buyItemPressed:(id)sender {
    NSDictionary *postInfo = @{@"msg":@"iPhone%7Cbuy%7C1000",
                               @"checksum": @"014a347fa0f1cac1baaaf1618481b22a1efeedf88fd1f294b2d69f72a45e6caa"};
    
    NSMutableArray *postArray = [@[] mutableCopy];
    for (NSString *key in postInfo.allKeys) {
        [postArray addObject:[NSString stringWithFormat:@"%@=%@",key,postInfo[key]]];
    }
    NSString *postString = [postArray componentsJoinedByString:@"&"];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081/checkout/"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:1000.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
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
        flagString = [flagString substringToIndex:[flagString rangeOfString:@"}  \n"].location];
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
