//
//  LoginViewController.m
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    _credentialView.layer.cornerRadius = 5;
    _credentialView.layer.masksToBounds = YES;
     self.passwordField.delegate = self;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
     
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    self.credentialView.hidden = true;
    [self.statusIndicator startAnimating];
    AuthenticationManager *manager = [[AuthenticationManager alloc] init];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager authenticateUser:self.IDField.text withPassword:self.passwordField.text delegate:self];
    //});
    return NO;
}

- (void) finishedAuthentication:(BOOL)authenticated withErrorOrNil:(NSString *)error
{
    if (authenticated)
    {
        UIViewController *idView = [[IDViewController alloc] init];
        [self setWantsFullScreenLayout:YES];
        [self.navigationController pushViewController:idView animated:YES];
        self.label.text = @"Log in to access your New Trier ID";
        self.label.textColor = [UIColor whiteColor];
    }
    else
    {
        if (error == nil)
            {self.IDField.textColor = [UIColor redColor];
            [self.passwordField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            [self.IDField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            [self.passwordField setText:@""];
            [self.IDField setTextColor:[UIColor blackColor]];
            self.label.text = @"Incorrect Username or Password";
            self.label.textColor = [UIColor redColor];
        }
        else
        {
            self.label.text = error;
            self.label.textColor = [UIColor redColor];
        }
    }
    [self.statusIndicator stopAnimating];
    [self.credentialView setHidden:NO];
}

@end
