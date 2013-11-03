//
//  AuthenticationReceiver.h
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticationReceiver <NSObject>

- (void) finishedAuthentication:(BOOL)authenticated withErrorOrNil:(NSString *)error;

@end
