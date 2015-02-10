//
//  OlaUtilities.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface OlaUtilities : NSObject

+(AppDelegate *)sharedAppDelegate;
+(void)showAlertWithMessage:(NSString *)message;
+(float)getOSVersion;

@end
