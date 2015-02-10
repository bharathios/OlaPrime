//
//  AppDelegate.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


//Menu Item selection tracker. By default set it to 1 (Places) for the first time
@property (nonatomic, assign) NSInteger selectedMenuItem;

@end

