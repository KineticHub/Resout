//
//  MainMenuViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "MainMenuViewController.h"
#import "BasicCell.h"
#import "PKRevealController.h"

#import "AreaSelectViewController.h"
#import "CampSelectionViewController.h"
#import "CheckListSelectViewController.h"
#import "ContactSelectionViewController.h"
#import "DocumentSelectionViewController.h"
#import "MeritBadgeSelectionViewController.h"
#import "StaffViewController.h"
#import "ReservationLocationViewController.h"
#import "CampInfoViewController.h"
#import "NLViewController.h"
#import "AFJSONRequestOperation.h"
#import "TwitterFeed.h"
#import "FacebookFeedViewController.h"
#import "ReservationInfoViewController.h"

@interface MainMenuViewController ()
@property bool isCampSelected;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *campSectionOptions;
@property (nonatomic, strong) NSMutableArray *reservationSectionOptions;
@property (nonatomic, strong) NSMutableArray *mySectionOptions;
@property (nonatomic, strong) NSMutableArray *socialSectionOptions;
@property (nonatomic, strong) NSMutableArray *options;
@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isCampSelected = NO;
    
    self.reservationSectionOptions = [NSMutableArray arrayWithObjects:@"Reservation Section", @"Documents", @"Contacts", @"Location", @"Reservation Info", nil];
    self.socialSectionOptions = [NSMutableArray arrayWithObjects:@"Social Section", @"Facebook Feeds", @"Twitter Tweets", @"Photos Wall", nil];
    self.mySectionOptions = [NSMutableArray arrayWithObjects:@"My Section", @"My Checklist", nil];
    
    [self setupCampMenu];
    
    self.options = [NSMutableArray arrayWithObjects:self.campSectionOptions, self.reservationSectionOptions, self.socialSectionOptions, self.mySectionOptions, nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setRowHeight:50.0];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [self.tableView setSectionHeaderHeight:20.0];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - TableView Data and Delegate Methods

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, [tableView sectionHeaderHeight])];
    [sectionLabel setText:[[self.options objectAtIndex:section] objectAtIndex:0]];
    [sectionLabel setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:1.0]];
    [sectionLabel setTextColor:darkBrown];
    return  sectionLabel;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.options objectAtIndex:section] count] - 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.options count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
	if (cell == nil) {
		cell = [[BasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
	}
    
    cell.textLabel.text = [[self.options objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] + 1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    switch ([indexPath section])
    {
        case 0:
        {
            switch ([indexPath row])
            {
                case 0:
                {
                    if (!self.isCampSelected) {
                        [self transitionCampSelection];
                    } else {
                        [self transitionAreaSelection];
                    }
                    break;
                }
                case 1:
                {
                    [self transitionDocumentSelection:0];
                    break;
                }
                case 2:
                {
                    [self transitionStaffSelection];
                    break;
                }
                case 3:
                {
                    [self transitionMeritBadgeSelection];
                    break;
                }
                case 4:
                {
//                    [self transitionCampSelection];
                    [self transitionCampInfo];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch ([indexPath row]) {
                case 0:
                {
                    [self transitionDocumentSelection:1];
                    break;
                }
                case 1:
                {
                    [self transitionContactSelection];
                    break;
                }
                case 2:
                {
                    [self transitionReservationLocation];
                    break;
                }
                case 3:
                {
                    [self transitionReservationInfo];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch ([indexPath row]) {
                case 0:
                {
                    [self transitionFacebookFeed];
                    break;
                }
                case 1:
                {
                    [self transitionTwitterFeed];
                    break;
                }
                case 2:
                {
                    [self transitionImageShowcase];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            [self transitionChecklist];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Setup Methods

-(void)setupCampMenu {
    if ([DataHandler sharedInstance].campId != -1) {
        self.isCampSelected = YES;
        self.campSectionOptions = [NSMutableArray arrayWithObjects:@"Camp Section", @"Areas", @"Documents", @"Staff", @"Badges", @"Camp Info", nil];
    } else {
        self.isCampSelected = NO;
        self.campSectionOptions = [NSMutableArray arrayWithObjects:@"Camp Section", @"Choose Camp", nil];
    }
    
    self.options = [NSMutableArray arrayWithObjects:self.campSectionOptions, self.reservationSectionOptions, self.socialSectionOptions, self.mySectionOptions, nil];
    
    [self.tableView reloadData];
    
}

#pragma mark - Transition Methods
-(void)transitionReservationInfo
{
    ReservationInfoViewController *reservation = [[ReservationInfoViewController alloc] init];
    self.revealController.frontViewController = reservation;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionChecklist
{
    UIView *background = [[UIView alloc] init];
    [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"trees_bg"]]];
    background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CheckListSelectViewController *checklist = [[CheckListSelectViewController alloc] initWithStyle:UITableViewStylePlain isSearchable:NO];
    self.revealController.frontViewController = checklist;
    [checklist.navigationController.view addSubview:background];
    [checklist.navigationController.view sendSubviewToBack:background];
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionAreaSelection
{
    AreaSelectViewController *areas = [[AreaSelectViewController alloc] init];
    self.revealController.frontViewController = areas;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionDocumentSelection:(int)documentsSection
{
    bool reservationDocs = NO;
    if (documentsSection == 1) {
        reservationDocs = YES;
    }
    DocumentSelectionViewController *documents = [[DocumentSelectionViewController alloc] initForReservation:reservationDocs];
    self.revealController.frontViewController = documents;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionMeritBadgeSelection
{
    MeritBadgeSelectionViewController *badges = [[MeritBadgeSelectionViewController alloc] init];
    self.revealController.frontViewController = badges;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionStaffSelection
{
    StaffViewController *staff = [[StaffViewController alloc] init];
    self.revealController.frontViewController = staff;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionContactSelection
{
    ContactSelectionViewController *contacts = [[ContactSelectionViewController alloc] init];
    self.revealController.frontViewController = contacts;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionCampSelection
{
    CampSelectionViewController *camps = [[CampSelectionViewController alloc] init];
    self.revealController.frontViewController = camps;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionReservationLocation
{
    ReservationLocationViewController *resLocation = [[ReservationLocationViewController alloc] init];
    self.revealController.frontViewController = resLocation;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionCampInfo
{
    CampInfoViewController *campInfoVC = [[CampInfoViewController alloc] initWithCampInfo:[DataHandler sharedInstance].campInfo];
    self.revealController.frontViewController = campInfoVC;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionFacebookFeed
{
    FacebookFeedViewController *twitterFeedVC = [[FacebookFeedViewController alloc] initWithPage:@"GOSHENNCAC"];
    self.revealController.frontViewController = twitterFeedVC;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionTwitterFeed
{
    TwitterFeed *twitterFeedVC = [[TwitterFeed alloc] initWithUsername:@"GoshenScoutCamp"];
    self.revealController.frontViewController = twitterFeedVC;
    [self.revealController showViewController:self.revealController.frontViewController];
}

-(void)transitionImageShowcase {
    [self requestImgurAlbumImageLinks];
}

#pragma mark - Image Showcase Specific Methods

-(void)requestImgurAlbumImageLinks {
    
    NSURL *url = [NSURL URLWithString:@"https://api.imgur.com/3/album/zTssd/images"];
    //    NSError * error = nil;
    
    //    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc] init];
    //    [sendDic setObject:@"Client-ID db6c6918bb991a0" forKey:@"Authorization"];
    
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendDic options:0 error:&error];
    //    NSString *myRequestString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request2 = [ [ NSMutableURLRequest alloc ] initWithURL: url ];
    
    [ request2 setHTTPMethod: @"GET" ];
    [ request2 setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [ request2 setValue:@"Client-ID db6c6918bb991a0" forHTTPHeaderField:@"Authorization"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request2 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Response: %@ JSON: %@", response, JSON);
        
        NSMutableArray *links = [[NSMutableArray alloc] init];
        for (NSDictionary *imageData in JSON[@"data"]) {
            [links addObject:[imageData objectForKey:@"link"]];
        }
        NSLog(@"links: %@", links);
        
        NLViewController *imageShowcase = [[NLViewController alloc] init];
        [imageShowcase addImagesFromLinks:links];
        self.revealController.frontViewController = imageShowcase;
        [self.revealController showViewController:self.revealController.frontViewController];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Response: %@ JSON: %@", response, JSON);
    }];
    
    [operation start];
}

@end
