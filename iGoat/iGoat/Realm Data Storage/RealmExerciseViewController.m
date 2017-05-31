#import "RealmExerciseViewController.h"
#import "RCreditInfo.h"
#import "UIAlertController+EasyBlock.h"

static NSString *const RealmCardName = @"John Doe";
static NSString *const RealmCardNumber = @"4444 5555 8888 1111";
static NSString *const RealmCardCVV = @"911";

@interface RealmExerciseViewController ()
@end

@implementation RealmExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self saveData];
}

-(IBAction)verifyItemPressed:(id)sender {
    BOOL isVerified = [self verifyName:self.creditNameTextField.text number:self.creditNumberTextField.text cvv:self.creditCVVTextField.text];
    NSString *message = (isVerified) ?  @"Success!!" : @"Failed";
    [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:NULL];
}

-(void)saveData {
    if ([[RCreditInfo allObjects] count] == 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        RCreditInfo *creditInfo = [RCreditInfo new];
        creditInfo.name = RealmCardName;
        creditInfo.cardNumber = RealmCardNumber;
        creditInfo.cvv = RealmCardCVV;
        [realm transactionWithBlock:^{ [realm addObject:creditInfo];}];
    }
}
    
-(BOOL)verifyName:(NSString *)name number:(NSString *)number cvv:(NSString *)cvv {
    RCreditInfo *creditInfo = [[RCreditInfo allObjects] firstObject];
    if (creditInfo) {
        return ([name isEqualToString:creditInfo.name] &&
                [number isEqualToString:creditInfo.cardNumber] &&
                [cvv isEqualToString:creditInfo.cvv]) ? true : false;
    }
    return false;
}
    
@end

