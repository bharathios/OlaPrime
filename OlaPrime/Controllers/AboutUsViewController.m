//
//  AboutUsViewController.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "AboutUsViewController.h"
#import "OlaConstants.h"
#import "OlaUtilities.h"
#import "SWRevealViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize snapBehavior;
@synthesize animator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = Menu_Cell_Selected_Color;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = [self navigationItemTitleLabel];
    
    self.view.backgroundColor = AboutUs_View_Background_Color;
    
    [self createMenuBarButton];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PanGesture Methods


-(void)viewDidLayoutSubviews
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Create a snap behavior for the contentView.
    // The view will snap to the center of the view.
    CGPoint originalCenter = self.animatedImage.center;
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.animatedImage
                                                 snapToPoint:CGPointMake(originalCenter.x,originalCenter.y)];
    
}


- (IBAction)handlePan:(UIPanGestureRecognizer *)gestureRecognizer;
{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        // Remove previously added snap behavior (if any).
        [self.animator removeBehavior:self.snapBehavior];
        if ([OlaUtilities getOSVersion]<8.0) {
            if (self.contentViewCenterConstraints)
            {
                [self.view removeConstraints:self.contentViewCenterConstraints];
            }
        }
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        // Calculate new center of the view based on the gesture recognizer's
        // translation.
        CGPoint newCenter = self.animatedImage.center;
        newCenter.x += [gestureRecognizer translationInView:self.view].x;
        newCenter.y += [gestureRecognizer translationInView:self.view].y;
        
        // Set the new center of the view.
        self.animatedImage.center = newCenter;
        
        // Reset the translation of the recognizer.
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // Dragging has ended.
        // Add snap behavior to the animator to move the view to it's starting
        // position with a nice snap movement.
        [self.animator addBehavior:self.snapBehavior];
    }
    
    
}




#pragma mark - Navigation Items

-(UILabel *)navigationItemTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-40, 0, self.view.bounds.size.width, 30)];
    titleLabel.textColor = AboutUs_Title_Color;
    titleLabel.font = AboutUs_Title_Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"";//NSLocalizedString(@"ABOUT_US",@"About Us");
    titleLabel.text = @"OLA";
    return titleLabel;
}

-(void)createMenuBarButton
{
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    menuButton.tintColor = AboutUs_Menu_Color;
    self.navigationItem.leftBarButtonItem = menuButton;
 
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    searchButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = searchButton;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
