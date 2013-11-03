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
    self.callback = delegate;
    if ([user isEqualToString:@""])
        user = @" ";
    if ([password isEqualToString:@""])
        password = @" ";
    self.user = user;
    self.password = password;
    self.stage = 0;
    self.authenticationString = [self base64Encode:[NSString stringWithFormat:@"%@:%@", user, password]];
    self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"https://onlinefiles.nths.net/admin/in-openpicture.asp?FileUserID=" stringByAppendingString:self.user]]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:self.request delegate:self];
    
}


@end
