//
//  FriendsViewController.m
//  OlaPrime
//
//  Created by Bharath Nagaraj Rao on 06/02/15.
//  Copyright (c) 2015 Bharath Nagaraj Rao. All rights reserved.
//

#import "FriendsViewController.h"
#import "OlaConstants.h"
#import "OlaUtilities.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "FriendsTableViewCell.h"

@interface FriendsViewController ()

@property (nonatomic, strong) NSMutableArray *friendsListArray;
@property (nonatomic, strong) NSMutableArray *olaFriendsListArray;
@property (nonatomic, strong) NSMutableArray *otherFriendsListArray;
@property (strong, nonatomic) UIBarButtonItem* menuButton;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [self navigationItemTitleLabel];
    self.navigationController.navigationBar.barTintColor = Menu_Cell_Selected_Color;
    self.navigationController.navigationBar.translucent = NO;
    
    self.friendsTableView.backgroundColor = Menu_View_Background_Color;
    self.friendsTableView.separatorColor = Menu_Cell_Seperator_Color;
    self.friendsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = Menu_View_Background_Color;
    
    
    
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
    NSLog(@"COUNT 1 - %ld, %ld",[self.olaFriendsListArray count],[self.otherFriendsListArray count]);
    
    [self createMenuBarButton];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    NSString *string = (section==0?@"OLA Friends":@"Others");
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
    FriendsTableViewCell *cell = [self.friendsTableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    
    NSDictionary *userDictionary = nil;

    if (indexPath.section == 0) {
        userDictionary = [self.olaFriendsListArray objectAtIndex:indexPath.row];
    }else{
        userDictionary = [self.otherFriendsListArray objectAtIndex:indexPath.row];
    }
    
    cell.friendImageView.image = [UIImage imageNamed:[userDictionary objectForKey:@"imageName"]];
    cell.friendNameLabel.text = [userDictionary objectForKey:@"friendName"];
    cell.friendAddButton.tag = indexPath.row;
    [cell.friendAddButton addTarget:self action:@selector(didSelectFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    // Display recipe in the table cell
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
   
    
}


- (void)didSelectFriend:(id)sender {
    
    NSLog(@"Button Tapped - %ld",[sender tag]);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Items




#pragma mark - Navigation Bar Methods

-(UILabel *)navigationItemTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    titleLabel.textColor = Places_Title_Color;
    titleLabel.font = Places_Title_Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
   /* switch ([[OlaUtilities sharedAppDelegate] selectedMenuItem]) {
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
    }
    */
    titleLabel.text = @"";
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
