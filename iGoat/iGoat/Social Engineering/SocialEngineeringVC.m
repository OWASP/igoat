
#import "SocialEngineeringVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UIAlertController+EasyBlock.h"

@interface SocialEngineeringVC () {
    LAContext *context;
}

@end

@implementation SocialEngineeringVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addShowHideButton];
}

-(void)addShowHideButton {
    CGSize hideShowSize = CGSizeMake(32, 32);
    UIButton *hideShow = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, hideShowSize.width, self.passwordTxtField.frame.size.height)];
    [hideShow setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    self.passwordTxtField.rightView = hideShow;
    self.passwordTxtField.rightViewMode = UITextFieldViewModeAlways;
    [hideShow addTarget:self action:@selector(hideShow:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)hideShow:(id)sender {
    UIButton *hideShow = (UIButton *)self.passwordTxtField.rightView;
    if (!self.passwordTxtField.secureTextEntry) {
        self.passwordTxtField.secureTextEntry = YES;
        [hideShow setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }
    else {
        self.passwordTxtField.secureTextEntry = NO;
        [hideShow setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
    [self.passwordTxtField becomeFirstResponder];
}

-(IBAction)loginItemPressed:(id)sender {
    NSString *name = self.nameTxtField.text;
    NSString *password = self.passwordTxtField.text;
    
    BOOL isVerified = [self verifyUserName:name password:password];
    NSString *message = (isVerified) ?  @"You have successfully logged In!!!" : @"Authentication Failed!!";
    [self showMessage:message];
}

-(BOOL)verifyUserName:(NSString *)userName password:(NSString *)password {
    NSString *credentialsPath = [[NSBundle mainBundle]pathForResource:@"Credentials" ofType:@"plist"];
    NSDictionary *credentialsInfo = [NSDictionary dictionaryWithContentsOfFile:credentialsPath];
    NSString *validUserName = credentialsInfo[@"User"];
    NSString *validPassword = credentialsInfo[@"Password"];
    
    return ([userName isEqualToString:validUserName] &&
            [password isEqualToString:validPassword]) ? YES : FALSE;
}

-(IBAction)authenticateViaTouchID {
    context = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *localizedReasonString = @"Touch ID Test to show Touch ID working in a custom app";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:localizedReasonString
                          reply:^(BOOL success, NSError *error) {
                              if (success) {
                                  [self showMessage:@"You have successfully logged In!!"];
                              } else {
                                  [self showMessage:error.description];
                                  NSLog(@"Switch to fall back authentication - ie, display a keypad or password entry box");
                              }
                          }];
    } else {
        [self showMessage:authError.description];
    }
}

-(void)showMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:nil];
    });
}

@end
