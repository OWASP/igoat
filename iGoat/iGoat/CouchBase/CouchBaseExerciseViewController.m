
#import "CouchBaseExerciseViewController.h"
#import "UIAlertController+EasyBlock.h"
#import <CouchbaseLite/CouchbaseLite.h>

static NSString *const CBKeyPatientName = @"CouchKeyPatientName";
static NSString *const CBKeyPatientAge = @"CouchKeyPatientAge";
static NSString *const CBKeyPatientGender = @"CouchKeyPatientGender";
static NSString *const CBKeyPatientDisease = @"CouchKeyPatientDisease";

static NSString *const CBValuePatientName = @"Jane Roe";
static NSString *const CBValuePatientAge = @"52";
static NSString *const CBValuePatientGender = @"Female";
static NSString *const CBValuePatientDisease = @"Cancer";

#define NON_NIL_STRING(str) ((str == nil) ? @"" : str)

@interface CouchBaseExerciseViewController ()

@end

@implementation CouchBaseExerciseViewController {
    CBLDatabase *database;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSError *error = nil;
    database = [[CBLManager sharedInstance] databaseNamed:@"couchbasedb"
                                                                 error:&error];
    [self saveData];
}

-(IBAction)verifyItemPressed:(id)sender {
    NSDictionary *info = @{CBKeyPatientName: NON_NIL_STRING(self.nameTextField.text),
                           CBKeyPatientAge: NON_NIL_STRING(self.ageTextField.text),
                           CBKeyPatientGender:NON_NIL_STRING(self.genderTextField.text),
                           CBKeyPatientDisease:NON_NIL_STRING(self.diseaseTextField.text)
                           };
    BOOL isVerified = [self verifyPatientInfo:info];
    NSString *message = (isVerified) ?  @"Success!!" : @"Failed";
    [UIAlertController showWithTitle:@"iGoat" message:message preferedStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        
    }];
}

-(void)saveData {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"documentID"] == nil) {
        NSDictionary *properties = @{
                                     CBKeyPatientName : CBValuePatientName,
                                     CBKeyPatientAge : CBValuePatientAge,
                                     CBKeyPatientGender : CBValuePatientGender,
                                     CBKeyPatientDisease : CBValuePatientDisease
                                     };
        CBLDocument *newDocument = [database createDocument];
        [newDocument putProperties:properties error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:newDocument.documentID forKey:@"documentID"];
    }
}

-(BOOL)verifyPatientInfo:(NSDictionary *)info {
    NSString *documentID = [[NSUserDefaults standardUserDefaults]objectForKey:@"documentID"];
    if (documentID) {
        CBLDocument *document = [database documentWithID:documentID];
        
        return  ([[document propertyForKey:CBKeyPatientName] isEqualToString:info[CBKeyPatientName]] &&
         [[document propertyForKey:CBKeyPatientAge] isEqualToString:info[CBKeyPatientAge]] &&
         [[document propertyForKey:CBKeyPatientGender] isEqualToString:info[CBKeyPatientGender]] &&
         [[document propertyForKey:CBKeyPatientDisease] isEqualToString:info[CBKeyPatientDisease]]) ? true : false;
    }
    return false;
}


@end
