//
//  ViewController.h
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate,GMSMapViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *rideMenuView;



@property (weak, nonatomic) IBOutlet UIButton *shareOptionSelection;
@property (weak, nonatomic) IBOutlet UIButton *shareOptionTransparent;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UIView *inviteFriendsView;
@property (weak, nonatomic) IBOutlet UIView *inviteSuccessView;
@property (weak, nonatomic) IBOutlet UIView *inviteSuccessContainerView;

//Driver Details Screen

@property (weak, nonatomic) IBOutlet UIView *driverDetailsView;
@property (weak, nonatomic) IBOutlet UIImageView *driverImage;
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UILabel *vehicleNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRatings;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRides;
@property (weak, nonatomic) IBOutlet UIImageView *pullImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutContraintofDriverDetailsView;
@property (nonatomic, assign) BOOL isDriverProfileOpen;



- (IBAction)didTapRideNow:(id)sender;
- (IBAction)didTapShareOption:(id)sender;
- (IBAction)didTapMiniCab:(id)sender;
- (IBAction)didCancelInvite:(id)sender;
- (IBAction)didSelectInvite:(id)sender;
- (IBAction)didTapDoneButton:(id)sender;
- (IBAction)handleTapGesture:(id)sender;
- (IBAction)didCancelDriverDetails:(id)sender;



@end

