

#import "BinaryCookiesExerciseViewController.h"
#import "UIAlertController+EasyBlock.h"

@interface BinaryCookiesExerciseViewController ()

@end

@interface NSArray(Extension)
-(NSInteger)indexOfString:(NSString *)string;
@end

@implementation NSArray (Extension)
-(NSInteger)indexOfString:(NSString *)someString {
    for (int i = 0 ; i < self.count; i++) {
        NSString *string = self[i];
        if ([string isEqualToString:someString]) {
            return i;
        }
    }
    return NSNotFound;
}

@end


static NSString *const GoatEndPoint = @"http://www.github.com/OWASP/iGoat";

static NSString *const GoatSessionTokenValue = @"dfr3kjsdf5jkjk420544kjkll";
static NSString *const GoatSessionTokenKey = @"sessionKey";

static NSString *const GoatCSRFTokenValue = @"fkdjkjxerioxicoxci3434";
static NSString *const GoatCSRFTokenKey = @"CSRFtoken";

static NSString *const GoatUserNameValue = @"Doe321";
static NSString *const GoatUserNameKey = @"username";


@implementation BinaryCookiesExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self saveCookies];
    
//    _nameTxtField.text = GoatUserNameValue;
//    _sessionTxtField.text = GoatSessionTokenValue;
//    _csrfTxtField.text = GoatCSRFTokenValue;
    
}

-(IBAction)verifyItemPressed:(id)sender {

    BOOL isVerified = [self verifyName: self.nameTxtField.text
                          sessionToken: self.sessionTxtField.text
                       csrfToken: self.csrfTxtField.text];
    NSString *message = (isVerified) ?  @"Success!!" : @"Failed";
    [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
    }];
}


/*
 On viewDidLoad, you can store 3 fields in binary cookies format as:
 1. session token: dfr3kjsdf5jkjk420544kjkll
 2. csrf token: fkdjkjxerioxicoxci3434
 3. username: doe321
 */
-(BOOL)verifyName:(NSString *)name sessionToken:(NSString *)sessionToken
        csrfToken:(NSString *)csrfToken {
    NSMutableArray *cookieKeys = [@[GoatUserNameKey, GoatCSRFTokenKey,GoatSessionTokenKey] mutableCopy];
    NSMutableArray *cookieValues = [@[name, csrfToken, sessionToken] mutableCopy];
    NSURL *endPointURL = [NSURL URLWithString:GoatEndPoint];
    
    NSMutableArray *cookies = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:endPointURL]mutableCopy];
    
    while (cookies.count) {
        BOOL found = false;
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            if ([cookieKeys indexOfString:cookie.name] != NSNotFound) {
                found = true; break;
            }
        }
        if (found == false) return false;
        
        NSUInteger index = [cookieKeys indexOfString:cookie.name];
        if (index == NSNotFound) {
            return false;
        }
        
        NSString *cookieValue = cookieValues[index];
        if ([cookie.value isEqualToString:cookieValue] == false) {
            return false;
        }
        [cookieKeys removeObject:cookie.name];
        [cookieValues removeObject:cookieValue];
        [cookies removeObject:cookie];
    }
    return true;
}



-(void)saveCookies{

    NSArray *basicInfoArray = @[@{GoatUserNameKey:GoatUserNameValue},
                                @{GoatCSRFTokenKey:GoatCSRFTokenValue},
                                @{GoatSessionTokenKey:GoatSessionTokenValue}];
    
    NSMutableArray *cookies = [@[]mutableCopy];
    
    for (NSDictionary *cookieInfo in basicInfoArray) {
        NSHTTPCookie *cookie = [self captureCookieWithKey:cookieInfo.allKeys.firstObject value:cookieInfo.allValues.firstObject];
        [cookies addObject:cookie];
    }
    
    NSURL *endPointURL = [NSURL URLWithString:GoatEndPoint];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies.copy forURL:endPointURL mainDocumentURL:nil];
}

-(NSHTTPCookie *)captureCookieWithKey:(NSString *)key value:(NSString *)value {
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
    [components setMonth:components.month + 5];
    NSDate *expireDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
    NSTimeInterval expireInterval = [expireDate timeIntervalSince1970];
    
    NSURL *endPointURL = [NSURL URLWithString:GoatEndPoint];
    NSDictionary *usernameProperties = @{
                                         NSHTTPCookieDomain : endPointURL.host,
                                         NSHTTPCookiePath : endPointURL.path,
                                         NSHTTPCookieName : key,
                                         NSHTTPCookieValue : value,
                                         NSHTTPCookieExpires : @(expireInterval)
                                         };
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:usernameProperties];
    return cookie;
}

@end
