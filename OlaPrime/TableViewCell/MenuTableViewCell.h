//
//  MenuTableViewCell.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuImage;
@property (weak, nonatomic) IBOutlet UILabel *menuItem;
@property (weak, nonatomic) IBOutlet UILabel *menuItemDetail;

@end
