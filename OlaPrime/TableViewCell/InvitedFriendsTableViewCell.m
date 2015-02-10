//
//  InvitedFriendsTableViewCell.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "InvitedFriendsTableViewCell.h"

@implementation InvitedFriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.friendImage.layer.cornerRadius = 20.0f;
    self.friendImage.layer.masksToBounds = YES;
    self.friendImage.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
