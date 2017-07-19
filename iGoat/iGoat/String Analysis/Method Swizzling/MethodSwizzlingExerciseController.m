#import "MethodSwizzlingExerciseController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation MethodSwizzlingExerciseController

@synthesize m_fetchedLabel, m_fetchButton, m_fakeJailbrokenEnvironmentSwitch, m_JailbreakEvasionSwitch;
Method originalMethod = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayStatusMessage:(NSString*)msg
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Status"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

static IMP __original_Method_Imp;
int _replacement_Method(id self, SEL _cmd, NSString* path)
{
    // Intercepted Method
    assert([NSStringFromSelector(_cmd) isEqualToString:@"fileExistsAtPath:"]);
    // Check for if this is a check for standard jailbreak detection files
    if ([path hasSuffix:@"Cydia.app"] ||
        [path hasSuffix:@"bash"] ||
        [path hasSuffix:@"MobileSubstrate.dylib"] ||
        [path hasSuffix:@"sshd"] ||
        [path hasSuffix:@"apt"])
    {
        // These files do exist in a jailbroken environment
        // However, we're going to tell the app these files do not exist
        return FALSE;
    }
    
    // Execute the normal method instead
    // and pass its results back to the app
    return ((int(*)(id,SEL,NSString*))__original_Method_Imp)(self, _cmd, path);
}

#pragma mark UI interactions
-(IBAction)jailbreakEvasionSwitchFlipped:(id)sender
{
    if (m_JailbreakEvasionSwitch.on)
    {
        // Perform in-code method swizzling
        // This would normally be done by an attacker via
        // third-party tools like iOS Mobile Substrate
        
        originalMethod = class_getInstanceMethod([NSFileManager class], @selector(fileExistsAtPath:));
        __original_Method_Imp = method_setImplementation(originalMethod, (IMP)_replacement_Method);
    }
    else
    {
        // Turn off method swizzling
        
        if (__original_Method_Imp != nil)
        {
            method_setImplementation(originalMethod, __original_Method_Imp);
            __original_Method_Imp = nil;
        }
    }
}

-(IBAction)fetchButtonTapped:(id)sender
{
    // Determine whether this is a jailbroken phone or not
    BOOL fileExists = FALSE;
    
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
    
    if (!fileExists && m_fakeJailbrokenEnvironmentSwitch.on)
    {
        // This is for that wierd scenario where the user
        // wants to run this just in an emualtor
        if (m_JailbreakEvasionSwitch.on)
            fileExists = FALSE;
        else
            fileExists = TRUE;
    }
    
    if (fileExists)
        [self displayStatusMessage:@"This app is running on a jailbroken device"];
    else
        [self displayStatusMessage:@"This app is not running on a jailbroken device"];
}

//******************************************************************************
// SOLUTION
//
// Quite a few hacker tools in the wild leverage method swizzling
// to intercept Objective C method calls (selectors) and perform code subtitution.
// In doing so, the hacker is able to intercept filesystem inspection methods
// and mislead the app about its filesystem environment.
//
// There are a number of different strategies you can employ to prevent a hacker
// from performing method swizzling against your app. The most ideal solution
// is to examine each message selector's method implementation and compare
// the address of eacg method implementation against what the app
// sees at compile time. While this solution is the most
// complete and accurate, it is difficult for a Software Engineer to implement
// this from scratch.  There are commercial products that will provide this level
// of sophistication in method swizzling prevention.
//
// To raise the bar and make it harder to perform method swizzling, switch the code from
// using upon an Objective C method to a C equivalent. In doing so, the hacker will no
// longer be able to exploit method swizzling because the app will not be passing
// Objective C selectors (that can be redirected via method swizzling) when executing the code.
//
// 1. Replace the fetchButtonTapped: implementation above with the implementation below.
//    In the implementation below, the application no longer relies upon NSFileManager
//    to inspect its filesystem. Instead, it uses C library calls to perform the same
//    operations. It is now immune to method swizzling attack vectors.
//
//    NOTE: To verify that the hacker can no longer swizzle and mislead the app,
//          you should run this solution on a truly jailbroken device.  Otherwise,
//          the switches will force the output to a particular value.
//
// 2. Extra credit: How do you prevent a hacker from taking that next step of hooking C methods?
//******************************************************************************

/*
 -(IBAction)fetchButtonTapped:(id)sender
 {
 // Note: To verify this is really working,
 // you must run this on an actual jailbroken device.
 // Here, the delegate method no longer takes into account
 // user preferences for 'faking jailbreak status' in an emulator environment.
 // If it did, the app will never report what it truly thinks is the
 // state of the environment and the correctness of this solution cannot be verified.
 //
 
 // Determine whether this is a jailbroken phone or not
 BOOL fileExists = FALSE;
 
 FILE* cydiaFileHandle = fopen("/Applications/Cydia.app", "r");
 fileExists = (cydiaFileHandle != NULL);
 if (cydiaFileHandle != NULL)
 {
 fclose(cydiaFileHandle);
 cydiaFileHandle = NULL;
 }
 
 if (fileExists)
 [self displayStatusMessage:@"This app is running on a jailbroken device"];
 else
 [self displayStatusMessage:@"This app is not running on a jailbroken device"];
 }
 */

@end

//******************************************************************************
//
// MethodSwizzlingExerciseController.m
// iGoat
//
// This file is part of iGoat, an Open Web Application Security
// Project tool. For details, please see http://www.owasp.org
//
// Copyright(c) 2013 KRvW Associates, LLC (http://www.krvw.com)
// The iGoat project is principally sponsored by KRvW Associates, LLC; Arxan Technologies
// Project Leader: Kenneth R. van Wyk (ken@krvw.com)
// Lead Developer: Jonathan Carter (jcarter@arxan.com)
//
// iGoat is free software; you may redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation; version 3.
//
// iGoat is distributed in the hope it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
// License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc. 59 Temple Place, suite 330, Boston, MA 02111-1307
// USA.
//
// Source Code: http://code.google.com/p/owasp-igoat/
// Project Home: https://www.owasp.org/index.php/OWASP_iGoat_Project
//
//******************************************************************************
