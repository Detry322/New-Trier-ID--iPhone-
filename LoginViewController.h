//
//  LoginViewController.h
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "AuthenticationManager.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, AuthenticationReceiver>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *credentialView;
@property (strong, nonatomic) IBOutlet UITextField *IDField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *statusIndicator;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void) finishedAuthentication:(BOOL)authenticated withErrorOrNil:(NSString *)error;

@end
