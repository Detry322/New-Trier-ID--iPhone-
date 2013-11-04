//
//  AuthenticationManager.m
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import "AuthenticationManager.h"

@implementation AuthenticationManager

- (void) authenticateUser:(NSString *)user withPassword:(NSString *)password delegate:(id<AuthenticationReceiver>)delegate
{
    [delegate finishedAuthentication:YES withErrorOrNil:nil];
    return;
}


@end
