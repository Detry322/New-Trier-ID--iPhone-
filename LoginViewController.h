//
//  LoginViewController.h
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *credentialView;
@property (strong, nonatomic) IBOutlet UITextField *IDField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;


@end
