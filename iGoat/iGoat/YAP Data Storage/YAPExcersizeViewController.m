#import "YAPExcersizeViewController.h"
#import "UIAlertController+EasyBlock.h"
#import "YapDatabase.h"

static NSString *const YapValueEmail = @"JohnDoe@yap.com";
static NSString *const YapValuePassword = @"TheUnknown";

static NSString *const YapKeyEmail = @"YapKeyEmail";
static NSString *const YapKeyPassword = @"YapKeyPassword";



@implementation YAPExcersizeViewController
    
    -(void)saveData {
        NSString *databaseName = @"YapDatabase.sqlite";
        NSURL *baseURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                inDomain:NSUserDomainMask
                                                       appropriateForURL:nil
                                                                  create:YES
                                                                   error:NULL];
        NSURL *databaseURL = [baseURL URLByAppendingPathComponent:databaseName isDirectory:NO];
        NSString *databasePath = databaseURL.filePathURL.path;
        
        YapDatabase *database = [[YapDatabase alloc] initWithPath:databasePath];
        YapDatabaseConnection *connection = [database newConnection];
        [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction setObject:YapValueEmail forKey:YapKeyEmail inCollection:@"iGoat"];
            [transaction setObject:YapValuePassword forKey:YapKeyPassword inCollection:@"iGoat"];
        }];
    }
    
    - (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
        [self saveData];
    }

    -(IBAction)verifyItemPressed:(id)sender {
        BOOL isVerified = [self verifyName:self.emailTextField.text
                                  password:self.passwordTextField.text];
        NSString *message = (isVerified) ?  @"Success!!" : @"Failed";
        [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        
    }
    
    -(NSString *)getYAPDatabasePath {
        NSString *databaseName = @"YapDatabase.sqlite";
        NSURL *baseURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                inDomain:NSUserDomainMask
                                                       appropriateForURL:nil
                                                                  create:YES
                                                                   error:NULL];
        NSURL *databaseURL = [baseURL URLByAppendingPathComponent:databaseName isDirectory:NO];
        NSString *databasePath = databaseURL.filePathURL.path;
        return databasePath;
    }
    
    -(BOOL)verifyName:(NSString *)enteredName password:(NSString *)enteredPassword {
        YapDatabase *database = [[YapDatabase alloc] initWithPath:self.getYAPDatabasePath];
        YapDatabaseConnection *connection = [database newConnection];
        __block BOOL isVerified = false;
        [connection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
            NSString *email = [transaction objectForKey:YapKeyEmail inCollection:@"iGoat"];
            NSString *password = [transaction objectForKey:YapKeyPassword inCollection:@"iGoat"];
            
            isVerified = ([email isEqualToString:enteredName] &&
                          [password isEqualToString:enteredPassword]) ? true : false;
        }];

        return isVerified;
    }
    
@end

