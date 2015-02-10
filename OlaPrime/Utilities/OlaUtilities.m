//
//  OlaUtilities.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "OlaUtilities.h"


@implementation OlaUtilities

+(AppDelegate *)sharedAppDelegate
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

+(float)getOSVersion
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    return [version floatValue];
}

+(void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", "Ok Button") otherButtonTitles:nil];
    [alert show];
}


@end
