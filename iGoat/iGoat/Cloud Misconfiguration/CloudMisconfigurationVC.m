
#import "CloudMisconfigurationVC.h"
#import "UIImage+animatedGIF.h"
#import "SVProgressHUD.h"
#import "UIAlertController+EasyBlock.h"

static NSString *const CMCardDigitRev = @"1634";
static NSString *const CMCardCVVRev = @"926";

@interface NSString(Reverse)
- (NSString *)reverse;
@end

@implementation NSString (Reverse)
- (NSString *)reverse {
    NSMutableString *result = [NSMutableString string];
    for (int i = (int)self.length - 1; i >= 0; i--) {
        [result appendFormat:@"%c", [self characterAtIndex:i]];
    }
    return result.copy;
}
@end

@interface CloudMisconfigurationVC ()
@property (nonatomic, weak) IBOutlet UIImageView *cardImageView;
@property (nonatomic, weak) IBOutlet UITextField *cardNoTxtField;
@property (nonatomic, weak) IBOutlet UITextField *cvvTxtField;
@end

@implementation CloudMisconfigurationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self fetchCardImage];
}

-(void) fetchCardImage {
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://s3.us-east-2.amazonaws.com/igoat774396510/catty.gif"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            self.cardImageView.image = image;
        });
    });
}

-(IBAction)verifyItemPressed :(id)sender {
    if (self.cardNoTxtField.text.length == 0) {
        [UIAlertController showWithTitle:@"iGoat" message:@"Enter card details" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    if (self.cvvTxtField.text.length == 0) {
        [UIAlertController showWithTitle:@"iGoat" message:@"Enter cvv details" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    if ([self.cvvTxtField.text isEqualToString:CMCardCVVRev.reverse] &&
        [self.cardNoTxtField.text isEqualToString:CMCardDigitRev.reverse] ) {
            [UIAlertController showWithTitle:@"iGoat" message:@"Verified!!" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
    } else {
        [UIAlertController showWithTitle:@"iGoat" message:@"Verification failed!!" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
    }
}

@end
