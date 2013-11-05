//
//  AuthenticationManager.h
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationReceiver.h"

@interface AuthenticationManager : NSObject

@property NSUserDefaults *prefs;

@property id <AuthenticationReceiver> callback;
- (NSString *) getBarcodeFromID:(NSString *)idNumber;
- (void) authenticateUser:(NSString *)user withPassword:(NSString *)password delegate:(id <AuthenticationReceiver>)delegate;

@end
