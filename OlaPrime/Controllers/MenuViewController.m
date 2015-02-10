//
//  MenuViewController.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 07/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "MenuViewController.h"
#import "OlaConstants.h"
#import "OlaUtilities.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "MenuTableViewCell.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationItem.title = @"Bharath";
    
    self.menuNavigationBar.barTintColor = Menu_NavigationBar_Color;
    self.menuNavigationBar.translucent = NO;
    
    self.menuTableView.backgroundColor = Menu_View_Background_Color;
    self.menuTableView.separatorColor = Menu_Cell_Seperator_Color;
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = Menu_View_Background_Color;
    
    
    self.menuItems = @[@"BOOK MY RIDE",@"MY RIDES",@"OLA MONEY",@"OLA FRIENDS",@"RATE CARD",@"EMERGENCY CONTACT",@"REPORT ISSUE",@"CALL SUPPORT"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation Items

-(UILabel *)navigationItemTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    titleLabel.textColor = Menu_Item_Color;
    titleLabel.font = Menu_Title_Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @""; NSLocalizedString(@"MENU_TITLE",@"Menu Title");
    return titleLabel;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Set the title of navigation bar by using the menu items
    
    // Set the photo if it navigates to the PhotoView
    /*if ([segue.identifier isEqualToString:@"showPhoto"]) {
     PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
     NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
     photoController.photoFilename = photoFilename;
     }*/
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, view.frame.size.height-5)];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    NSString *string = @"Bharath Rao";
    /* Section header is in 0th index... */
    [label setText:string];
    label.textColor = [UIColor yellowColor];
    [view addSubview:label];
    [view setBackgroundColor:Menu_NavigationBar_Color]; //your background color...
    return view;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Bharath";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_OF_MENU_TABLE_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [self.menuTableView dequeueReusableCellWithIdentifier:@"menuCell"];
    cell.backgroundColor = Menu_Cell_Color;
        
    cell.menuItem.textColor = Menu_Item_Color;
    cell.menuItemDetail.textColor = Menu_Item_Color;
    cell.menuItem.font = Menu_Item_Font;
    cell.menuItem.highlightedTextColor = [UIColor yellowColor];
        
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = Menu_Cell_Selected_Color;
    [cell setSelectedBackgroundView:bgColorView];
    
    
    cell.menuItem.text = [self.menuItems objectAtIndex:indexPath.row];
    cell = [self setImageForTableViewCell:cell rowIndex:indexPath.row];
    
    return cell;
}


-(MenuTableViewCell *)setImageForTableViewCell:(MenuTableViewCell *)cell rowIndex:(NSInteger)row
{
    switch(row)
    {
        case 0:
        {
            cell.menuImage.image = [UIImage imageNamed:@"taxi1.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"taxi1_select.png"];
        }
            break;
            
        case 1:
        {
            
            cell.menuImage.image = [UIImage imageNamed:@"ride.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"ride_select.png"];
        }
            break;
            
        case 2:
        {
            cell.menuImage.image = [UIImage imageNamed:@"wallet.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"wallet_select.png"];

        }
            break;
            
        case 3:
        {
            cell.menuImage.image = [UIImage imageNamed:@"friends.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"friends_select.png"];
        }
            break;
            
        case 4:
        {
            cell.menuImage.image = [UIImage imageNamed:@"issue.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"issue_select.png"];
        }
            break;
            
            
        case 5:
        {
            cell.menuImage.image = [UIImage imageNamed:@"emergency.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"emergency_select.png"];
        }
            break;
            
            
        case 6:
        {
            cell.menuImage.image = [UIImage imageNamed:@"issue.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"issue_select.png"];
        }
            break;
            
            
        case 7:
        {
            cell.menuImage.image = [UIImage imageNamed:@"call.png"];
            cell.menuImage.highlightedImage = [UIImage imageNamed:@"call_select.png"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AppDelegate *appDelegate = [OlaUtilities sharedAppDelegate];
    appDelegate.selectedMenuItem = indexPath.row;
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"places" sender:self];
    }
    else if (indexPath.row == 4)
        [self performSegueWithIdentifier:@"about_us" sender:self];
    else if (indexPath.row == 3)
        [self performSegueWithIdentifier:@"friends" sender:self];
    else if (indexPath.row == 2)
        [self canEvaluatePolicy];
        
    
}




#pragma mark - Tests

- (void)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    NSError *error;
    BOOL success;
    
    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
    
        NSLog(@"Evaluate Success");
        [self evaluatePolicy];
    } else {
        NSLog(@"Evaluate Failed");
    }
    
    
}

- (void)evaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    
    // show the authentication UI with our reason string
    //context.localizedFallbackTitle = @"Bharath";
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Please authenticate to access your OLA money." reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             msg =[NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_SUCCESS", nil)];
             
             NSLog(@"TouchID Success");
             dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your OLA money is INR 2000." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert show];
             });
             
         } else {
             
             NSLog(@"TouchID failed - %@, %ld",authenticationError.description, authenticationError.code);
             if (authenticationError.code == 3) {
                 [self evaluatePolicy];
             }else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We believe that you are not authorized to access OLA Wallet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [alert show];
                 });
             }
             
             
         }
        
         
     }];
    
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
