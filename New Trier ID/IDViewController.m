//
//  IDViewController.m
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import "IDViewController.h"

@interface IDViewController ()

@end

@implementation IDViewController

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
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIImage *barcodeImage = [[UIImage alloc] initWithData:[prefs dataForKey:@"barcodeImage"]];
    [self.barcode setImage:[[UIImage alloc] initWithCGImage:barcodeImage.CGImage scale:1.0 orientation:UIImageOrientationRight]];
    UIImage *pictureImage = [[UIImage alloc] initWithData:[prefs dataForKey:@"pictureImage"]];
    [self.picture setImage:pictureImage];
    int year = [prefs integerForKey:@"schoolYear"];
    self.year.text = [NSString stringWithFormat:@"%d-%d",year-1,year];
    self.idNumber.text = [prefs stringForKey:@"idNumber"];
    self.name.text = [prefs stringForKey:@"fullName"];
    [[UIScreen mainScreen] setBrightness:1.0];
}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[UIScreen mainScreen] setBrightness:1.0];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popopop:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:NO forKey:@"authenticated"];
    [prefs synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
