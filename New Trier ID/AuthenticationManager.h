//
//  AuthenticationManager.h
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationReceiver.h"
#import "Base64.h"
#import "curl/curl.h"

@interface AuthenticationManager : NSObject

- (void) authenticateUser:(NSString *)user withPassword:(NSString *)password delegate:(id <AuthenticationReceiver>)delegate;

@end
