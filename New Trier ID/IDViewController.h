//
//  IDViewController.h
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface IDViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)popopop:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *barcode;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *idNumber;
@property (strong, nonatomic) IBOutlet UILabel *year;

@end
