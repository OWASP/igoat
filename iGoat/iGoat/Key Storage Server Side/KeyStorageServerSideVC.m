

#import "KeyStorageServerSideVC.h"
#import "NSData+AESEncryption.h"
#import "UIAlertController+EasyBlock.h"


@interface KeyStorageServerSideVC ()
@property (nonatomic, strong) NSString *encryptionKey;
@end

static NSString *const SecretMessage = @"SecretPass";


@implementation KeyStorageServerSideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self fetchKeyFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) fetchKeyFromServer {
    NSString *urlString = @"http://localhost:8081/cryptoKey.php";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    urlRequest.HTTPBody = [@"token=key" dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPMethod = @"POST";

    
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",
                               @"accept": @"text/html,application/xhtml+xml,application/xml" };
    
    [urlRequest setAllHTTPHeaderFields:headers];
    
    [NSURLConnection sendAsynchronousRequest: urlRequest
                                       queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                           if (!connectionError && [httpResponse statusCode] == 200) {
                                               
                                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                               [self encryptUsingResponseString:responseString];
                                           } else {
                                               [UIAlertController showWithTitle:@"iGoat" message:@"Check Internet." preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock: nil];
                                           }
                                       }];
}

-(void) encryptUsingResponseString:(NSString *)responseString {
    self.encryptionKey = [self keyFromResponseString:responseString];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *encryptedData = [[SecretMessage dataUsingEncoding:NSUTF8StringEncoding] dataUsingAES256EncryptionWithKey:self.encryptionKey];
        NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSASCIIStringEncoding];
        self.encryptedMessageLabel.text = encryptedString;
    });
}

-(NSString *) keyFromResponseString:(NSString *)responseString {
    NSRange searchFromRange = [responseString rangeOfString:@"<td>key</td><td>"];
    NSRange searchToRange = [responseString rangeOfString:@"</td></tr></table>"];
    NSString *substring = [responseString substringWithRange:NSMakeRange(searchFromRange.location+searchFromRange.length, searchToRange.location-searchFromRange.location-searchFromRange.length)];
    
    return  substring;
}

-(IBAction) verifyItemPressed:(id)sender {
    NSString *message = @"Try Harder!!..";
    if ([self.encryptionTextField.text isEqualToString:self.encryptionKey]) {
        message = @"Success!!";
    }
    [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:nil];
}

@end
