
#import "MemoryManagementVC.h"

#import "UIAlertController+EasyBlock.h"

NSString *ccvString;

@interface MemoryManagementVC ()

@property (nonatomic, strong) NSString *cardNumberString;

@property (nonatomic, strong) IBOutlet UITextField *cardNoTextField;
@property (nonatomic, strong) IBOutlet UITextField *cardCCVTextField;
@end

@implementation MemoryManagementVC

-(IBAction) payItemPressed:(id) sender {
    if (self.cardNoTextField.text.length == 0) {
        [UIAlertController showWithTitle:@"iGoat" message:@"Enter card number" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    else if (self.cardCCVTextField.text.length == 0) {
        [UIAlertController showWithTitle:@"iGoat" message:@"Enter cvv number" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
        return;
    }
    
    
    self.cardNumberString = self.cardNoTextField.text;
    ccvString = self.cardCCVTextField.text;
    
    [UIAlertController showWithTitle:@"iGoat" message:@"Thanks for purchase!! Do you think card details are safe. Check out memory :)" preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:nil];
}

@end
