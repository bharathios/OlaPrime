//
//  FriendsTableViewCell.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 06/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.friendImageView.layer.cornerRadius = 20.0f;
    self.friendImageView.layer.masksToBounds = YES;
    self.friendImageView.layer.borderWidth = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
