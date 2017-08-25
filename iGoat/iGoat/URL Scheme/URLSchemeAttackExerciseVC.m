
#import "URLSchemeAttackExerciseVC.h"

@interface URLSchemeAttackExerciseVC ()

@end

@implementation URLSchemeAttackExerciseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)sendMessageItemPressed:(id)sender {
    NSString *mobileNumberStr = self.mobileNumberTxtField.text;
    NSString *messageNumberStr = self.messageTxtField.text;
    
    NSString *urlString = [[NSString stringWithFormat:@"iGoat://?contactNumber=%@&message=%@",mobileNumberStr,messageNumberStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}

@end
