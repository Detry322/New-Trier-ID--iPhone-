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

@interface AuthenticationManager : NSObject <NSURLConnectionDelegate>

@property id <AuthenticationReceiver> callback;
@property int stage;
@property NSMutableData *responseData;
@property NSMutableURLRequest *request;
@property NSString *user;
@property NSString *password;
@property NSString *authenticationString;

- (void) authenticateUser:(NSString *)user withPassword:(NSString *)password delegate:(id <AuthenticationReceiver>)delegate;
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data;
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (NSString *)base64Encode:(NSString *)plainText;

@end
