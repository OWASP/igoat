# UIAlertController-EasyBlock
No need to write a too much of code for setting up UIAlertController.


UIAlertController+EasyBlock
===================

Category on UIAlertController to use inline block callbacks

you can create and configure an type of UIAlertController by setting the preferedStyle(UIAlertControllerStyle) AlertStyle/ActionSheetStyle 

```
[UIAlertController showWithTitle:@"Some title" 
                message:@"Are you sure?" preferedStyle:UIAlertControllerStyleAlert 
                cancelButtonTitle:@"NO" otherButtonTitles:@[@"YES"]
                tapBlock:
                    ^(UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                            if (buttonIndex !=[UIAlertController cancelButtonIndex]) 
                            {
                            }
}];

``