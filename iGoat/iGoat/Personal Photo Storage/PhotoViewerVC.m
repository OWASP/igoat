//
//  PhotoViewerVC.m
//  iGoat
//
//  Created by Swaroop Yermalkar on 20/06/17.
//  Copyright © 2017 KRvW Associates, LLC. All rights reserved.
//

#import "PhotoViewerVC.h"

@interface PhotoViewerVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Private Photo Storage";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    self.imageView.image = [UIImage imageNamed:@"iphone.png"];
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
