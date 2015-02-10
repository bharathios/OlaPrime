//
//  AboutUsViewController.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController


// Snap behavior responsible for the snap movement of the contentView after the
// dragging gesture has ended.
@property(nonatomic, strong) UISnapBehavior *snapBehavior;

// Dynamic animator that will take care of animating the snap movement.
@property(nonatomic, strong) UIDynamicAnimator *animator;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *contentViewCenterConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *animatedImage;


-(UILabel *)navigationItemTitleLabel;
-(void)createMenuBarButton;
- (IBAction)handlePan:(UIPanGestureRecognizer *)gestureRecognizer;

@end
