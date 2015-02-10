//
//  FriendsViewController.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 06/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@end
