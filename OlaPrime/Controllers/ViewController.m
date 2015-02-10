//
//  ViewController.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "ViewController.h"
#import "OlaConstants.h"
#import "OlaUtilities.h"
#import "SWRevealViewController.h"
#import "InvitedFriendsTableViewCell.h"


static CGFloat kOverlayHeight = 140.0f;


@interface ViewController ()

@property (strong, nonatomic) UIBarButtonItem* menuButton;
@property (nonatomic, strong) NSMutableArray *friendsListArray;
@property (nonatomic, strong) NSMutableArray *olaFriendsListArray;
@property (nonatomic, strong) NSMutableArray *otherFriendsListArray;
@property (nonatomic, assign) BOOL didDrawGeoFence;
@property (nonatomic, assign) CLLocationCoordinate2D lastUpdatedLocation;
@property (nonatomic, assign) CLLocationCoordinate2D midPointLocation;
@property (nonatomic, assign) double radiusAllowed;

@end

@implementation ViewController{
    CLLocationManager *manager_;
    GMSMapView        *mapView_;
    GMSMarker         *locationMarker_;
    GMSGeocoder *geocoder_;
    GMSCircle *circle_;
    UIView *overlay_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ride Now";
    self.navigationItem.titleView = [self navigationItemTitleLabel];
    self.navigationController.navigationBar.barTintColor = Menu_Cell_Selected_Color;
    self.navigationController.navigationBar.translucent = NO;
    
    geocoder_ = [[GMSGeocoder alloc] init];
    
    self.didDrawGeoFence = NO;
    
    self.rideMenuView.hidden = YES;
    self.shareOptionSelection.hidden = YES;
    self.inviteFriendsView.hidden = YES;
    self.inviteSuccessView.hidden = YES;
    self.driverDetailsView.hidden = YES;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FriendsList" ofType:@"plist"];
    self.friendsListArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.olaFriendsListArray = [NSMutableArray new];
    self.otherFriendsListArray = [NSMutableArray new];
    
    for (NSDictionary *dictObj in self.friendsListArray) {
        if ([[dictObj objectForKey:@"isOlaFriend"] boolValue] == YES ) {
            [self.olaFriendsListArray addObject:dictObj];
        }else{
            [self.otherFriendsListArray addObject:dictObj];
        }
    }
    
    
    [self createMenuBarButton];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self showGoogleMap];
    [self showCategoryView];
    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)showGoogleMap
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:12.956929
                                                            longitude:77.701256
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    
    // Enable my location button to show more UI components updating.
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    mapView_.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:mapView_];
    
    //[self showCurrentLocation];
    
   /* CGRect overlayFrame = CGRectMake(0, -kOverlayHeight, 0, kOverlayHeight);
    overlay_ = [[UIView alloc] initWithFrame:overlayFrame];
    overlay_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    overlay_.backgroundColor = [UIColor colorWithHue:0.0 saturation:1.0 brightness:1.0 alpha:0.5];
    [self.view addSubview:overlay_];*/
}


-(void)showCurrentLocation
{
    [mapView_ clear];
    // Setup location services
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Please enable location services");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    manager_ = [[CLLocationManager alloc] init];
    manager_.delegate = self;
    manager_.desiredAccuracy = kCLLocationAccuracyBest;
    manager_.distanceFilter = 5.0f;
    if ([manager_ respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [manager_ requestWhenInUseAuthorization];
    }

    [manager_ startUpdatingLocation];
    
    /*GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
    sydneyMarker.title = @"Source";
    sydneyMarker.icon = [UIImage imageNamed:@"places"];
    sydneyMarker.position = CLLocationCoordinate2DMake(12.956929, 77.701256);
    sydneyMarker.map = mapView_;*/
    
}


#pragma mark - Maps Delegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    // On a long press, reverse geocode this location.
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *address = response.firstResult;
        if (address) {
            NSLog(@"Geocoder result: %@", address);
            [self verifyGeoFenceForLocation:address.coordinate];
            GMSMarker *marker = [GMSMarker markerWithPosition:address.coordinate];
            
            marker.title = [[address lines] firstObject];
            if ([[address lines] count] > 1) {
                marker.snippet = [[address lines] objectAtIndex:1];
            }
            
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.map = mapView_;
            
            
            
        } else {
            NSLog(@"Could not reverse geocode point (%f,%f): %@",
                  coordinate.latitude, coordinate.longitude, error);
        }
    };
    [geocoder_ reverseGeocodeCoordinate:coordinate completionHandler:handler];
}



-(void)verifyGeoFenceForLocation:(CLLocationCoordinate2D)markedLocation
{
    [mapView_ clear];
    self.didDrawGeoFence = NO;
    [self plotPathBetweenPoints:self.lastUpdatedLocation];
    CLLocationDistance distance = GMSGeometryDistance (markedLocation,self.midPointLocation);
    if (distance> self.radiusAllowed) {
        circle_.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
    }
    else{
        circle_.fillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0 alpha:0.2];
    }
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"Please authorize location services");
        return;
    }
    
    NSLog(@"CLLocationManager error: %@", error.localizedFailureReason);
    return;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (locationMarker_ == nil) {
        locationMarker_ = [[GMSMarker alloc] init];
        locationMarker_.position = CLLocationCoordinate2DMake(-33.86, 151.20);
        locationMarker_.icon = [UIImage imageNamed:@"redCar.png"];
        locationMarker_.groundAnchor = CGPointMake(0.5f, 0.97f);
        locationMarker_.map = mapView_;
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.0];
        locationMarker_.position = location.coordinate;
        [CATransaction commit];
    }
    
    GMSCameraUpdate *move = [GMSCameraUpdate setTarget:location.coordinate zoom:12];
    NSLog(@"Coordinate - %f, %f", location.coordinate.latitude,location.coordinate.longitude );
    [mapView_ animateWithCameraUpdate:move];
    
    if(location.coordinate.latitude)
    {
        [self plotPathBetweenPoints:location.coordinate];
    }
}


-(void)plotPathBetweenPoints:(CLLocationCoordinate2D )currentLoc
{
    /*GMSMutablePath *path = [GMSMutablePath path];
     [path addCoordinate:CLLocationCoordinate2DMake(currentLoc.coordinate.latitude,currentLoc.coordinate.longitude)];
     [path addCoordinate:CLLocationCoordinate2DMake(@(12.958956).doubleValue,@(77.648163).doubleValue)];*/
    
    GMSMarker *marker=[[GMSMarker alloc]init];
    marker.position=CLLocationCoordinate2DMake(MARATHHALLI_LATITUDE,MARATHHALLI_LONGITUDE);
    marker.icon=[UIImage imageNamed:@"places"] ;
    marker.groundAnchor=CGPointMake(0.5,0.5);
    marker.map=mapView_;
    
    /*GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(currentLoc.coordinate.latitude,currentLoc.coordinate.longitude)];
    [path addCoordinate:CLLocationCoordinate2DMake(@(12.956868).doubleValue,@(77.701192).doubleValue)];
    
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeWidth = 2.f;
    rectangle.map = mapView_;
    self.view=mapView_;*/
    self.lastUpdatedLocation = currentLoc;
    if (self.didDrawGeoFence == NO) {
        
        [self plotCircle:currentLoc];
        self.didDrawGeoFence = YES;
    }
    
    
}


-(void)plotCircle:(CLLocationCoordinate2D )currentLoc
{
    NSLog(@"Draw Circle");
    //GMSCircle *cicle = [GMSCircle circleWithPosition:CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude) radius:1000];
    
    double midPointLatitude = (currentLoc.latitude + MARATHHALLI_LATITUDE)/2;
    double midPointLongitude = (currentLoc.longitude + MARATHHALLI_LONGITUDE)/2;
    self.midPointLocation = CLLocationCoordinate2DMake(midPointLatitude, midPointLongitude);
    CLLocationDistance distance = GMSGeometryDistance (currentLoc,CLLocationCoordinate2DMake(MARATHHALLI_LATITUDE,MARATHHALLI_LONGITUDE));
    double distanceInMeters = distance;
    double threshholdDistance = distanceInMeters/2 + 2 * KM_IN_METERS;
    self.radiusAllowed = threshholdDistance;
    NSLog(@"Distance - %f",distance);

    circle_ = [GMSCircle circleWithPosition:CLLocationCoordinate2DMake(midPointLatitude,midPointLongitude) radius:threshholdDistance];
    circle_.fillColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.2];
    
    circle_.map = mapView_;
    //self.view=mapView_;
    
   
    
    
}






#pragma mark - Custom Methods

-(void)showCategoryView
{
    self.categoryView.hidden = NO;
    //self.categoryView.backgroundColor = [UIColor clearColor];
    mapView_.frame = CGRectMake(mapView_.frame.origin.x, mapView_.frame.origin.y, mapView_.frame.size.width, mapView_.frame.size.height - HEIGHT_OF_CATEGORY_VIEW);
    //mapView_.padding = UIEdgeInsetsMake(0, 0, 200, 0);
}



-(void)showRideMenuView
{
    self.categoryView.hidden = YES;
    self.rideMenuView.hidden = NO;
    
    mapView_.frame = self.view.bounds;
    mapView_.frame = CGRectMake(mapView_.frame.origin.x, mapView_.frame.origin.y, mapView_.frame.size.width, mapView_.frame.size.height - HEIGHT_OF_RIDE_MENU_VIEW);
    
}



-(void)showFriendsList
{
    self.categoryView.hidden = YES;
    self.rideMenuView.hidden = YES;
    self.inviteFriendsView.hidden = NO;
    mapView_.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.inviteFriendsView];
//    self.inviteFriendsView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}


-(void)showInvitedFriendsList
{
    self.categoryView.hidden = YES;
    self.rideMenuView.hidden = YES;
    self.inviteFriendsView.hidden = YES;
    self.inviteSuccessView.hidden = NO;
    
    self.inviteSuccessContainerView.layer.cornerRadius = 10.0;
    self.inviteSuccessContainerView.layer.masksToBounds = YES;
    self.inviteSuccessContainerView.layer.borderWidth = 2;
    self.inviteSuccessContainerView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    
    
    [self.view bringSubviewToFront:self.inviteSuccessView];
}


-(void)showDriverDetailsView
{
    self.categoryView.hidden = YES;
    self.rideMenuView.hidden = YES;
    self.inviteFriendsView.hidden = YES;
    self.inviteSuccessView.hidden = YES;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.driverDetailsView.hidden = NO;
    self.topLayoutContraintofDriverDetailsView.constant = HEIGHT_OF_DRIVER_DETAILS_VIEW;
    
    mapView_.frame = self.view.bounds;
    mapView_.frame = CGRectMake(mapView_.frame.origin.x, mapView_.frame.origin.y, mapView_.frame.size.width, mapView_.frame.size.height);
    
    [self.view bringSubviewToFront:self.driverDetailsView];
    
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section==0?@"Ola Friends":@"Others");

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 44.0;

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, view.frame.size.height-5)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    NSString *string = (section==0?@"Ola Friends":@"Others");
    /* Section header is in 0th index... */
    [label setText:string];
    label.textColor = [UIColor yellowColor];
    [view addSubview:label];
    [view setBackgroundColor:Menu_NavigationBar_Color]; //your background color...
    return view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (section==0?[self.olaFriendsListArray count]:[self.otherFriendsListArray count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvitedFriendsTableViewCell *cell = [self.friendsTableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    NSDictionary *userDictionary = nil;
    if (indexPath.section == 0) {
        userDictionary = [self.olaFriendsListArray objectAtIndex:indexPath.row];
    }else{
        userDictionary = [self.otherFriendsListArray objectAtIndex:indexPath.row];
    }
    
    cell.friendImage.image = [UIImage imageNamed:[userDictionary objectForKey:@"imageName"]];
    cell.friendName.text = [userDictionary objectForKey:@"friendName"];
    cell.addFriendImage.tag = indexPath.row;
    [cell.addFriendImage addTarget:self action:@selector(didSelectFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    // Display recipe in the table cell
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
}


- (void)didSelectFriend:(id)sender {
    
    NSLog(@"Button Tapped - %ld",[sender tag]);
    UIButton *selectedButton = (UIButton *)sender;
    [selectedButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    
    
}



#pragma mark - Navigation Bar Methods

-(UILabel *)navigationItemTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    titleLabel.textColor = [UIColor yellowColor];
    titleLabel.font = Places_Title_Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    /*switch ([[OlaUtilities sharedAppDelegate] selectedMenuItem]) {
        case 0:
            titleLabel.text = NSLocalizedString(@"PLACES",@"Places");
            break;
            
        case 1:
            titleLabel.text = NSLocalizedString(@"NEAR_BY",@"Near By");
            break;
            
        case 2:
            titleLabel.text = NSLocalizedString(@"FAVOURITES",@"Favourites");
            break;
            
        default:
            break;
    }*/
    titleLabel.text = @"OLA";
    
    return titleLabel;
}



-(void)createMenuBarButton
{
    if (self.menuButton!=nil) {
        
        self.menuButton = nil;
    }
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.menuButton.tintColor = Places_Menu_Color;
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fence.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showCurrentLocation)];
    searchButton.enabled = NO;
    searchButton.tintColor = Places_Menu_Color;
    self.navigationItem.rightBarButtonItem = searchButton;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapMiniCab:(id)sender {
    
    
}

- (IBAction)didCancelInvite:(id)sender {
}

- (IBAction)didSelectInvite:(id)sender {
    
    [self showInvitedFriendsList];
}

- (IBAction)didTapDoneButton:(id)sender {
    
    [self showDriverDetailsView];
    
    
}

- (IBAction)handleTapGesture:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (self.isDriverProfileOpen) {
            
            self.topLayoutContraintofDriverDetailsView.constant = 0;
            
        }
        else{
            self.topLayoutContraintofDriverDetailsView.constant = HEIGHT_OF_DRIVER_DETAILS_VIEW;
            
        }
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        
        if (self.isDriverProfileOpen) {
            self.isDriverProfileOpen = NO;
            self.pullImageView.image = [UIImage imageNamed:@"pullDown.png"];
            
        }else{
            self.isDriverProfileOpen = YES;
            self.pullImageView.image = [UIImage imageNamed:@"pullUp.png"];
        }
        
        
    }];
}

- (IBAction)didCancelDriverDetails:(id)sender {
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
            
            self.topLayoutContraintofDriverDetailsView.constant = self.view.bounds.size.height;
       
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        
        mapView_.frame = self.view.bounds;
        
    }];
}
- (IBAction)didTapRideNow:(id)sender {
    
    [self showRideMenuView];
    
    
    
}

- (IBAction)didTapConfirmRide:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your booking has been confirmed. Driver will pick you in 2 minute(s). Till then you can add driver's profile and reviews. You can also add your friends to share your ride" delegate:self cancelButtonTitle:@"Ride Alone" otherButtonTitles:@"Add Friends", nil];
    [alert show];
    
}


- (IBAction)didTapShareOption:(id)sender {

    if ([sender tag] == 0)
    {
        self.shareOptionSelection.hidden = NO;
        self.shareOptionTransparent.hidden = YES;
    }else{
        self.shareOptionSelection.hidden = YES;
        self.shareOptionTransparent.hidden = NO;
    }

}




#pragma mark - UIAlertView Delegates


// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"Ride Alone Tapped");
            
        }
            break;
            
        case 1:
        {
            NSLog(@"Add Friends Tapped");
            [self showFriendsList];
            
        }
            break;
            
        default:
            break;
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex // before animation and hiding view
{
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    
}





@end
