//
//  AreaSelectViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "AreaViewController.h"
#import "MeritBadgeSelectionViewController.h"
#import "StaffViewController.h"

@interface AreaSelectViewController ()
@property (nonatomic, strong) NSMutableArray *areas;
@end

@implementation AreaSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.areas = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadCampAreas:^(NSMutableArray *objects) {
            
            self.areas = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

#pragma mark - UITableView Override Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.areas count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = (BasicCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *area = [self.areas objectAtIndex:[indexPath section]];
    cell.textLabel.text = [area objectForKey:@"name"];
//    cell.detailTextLabel.text = @"PRIDE";
    [cell setCellImage:[NSURLRequest requestWithURL:[NSURL URLWithString:[area objectForKey:@"icon"]]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSDictionary *area = [self.areas objectAtIndex:[indexPath section]];
    
//    CGRect frame;
    
    AreaViewController *areaVC = [[AreaViewController alloc] initWithAreaInfo:area];
    areaVC.title  = @"Information";
    areaVC.tabBarItem.image = [UIImage imageNamed:@"info_bar"];
    
    MeritBadgeSelectionViewController *badgesVC = [[MeritBadgeSelectionViewController alloc] initWithArea:area];
//    frame = dsvc.tableView.frame;
//    frame.size.height -= 60.0;
//    [dsvc.tableView setFrame:frame];
    badgesVC.title  = @"Badges";
    badgesVC.tabBarItem.image = [UIImage imageNamed:@"badges_bar"];
    
    StaffViewController *staffVC = [[StaffViewController alloc] initWithArea:area];
//    frame = csvc2.tableView.frame;
//    frame.size.height -= 60.0;
//    [csvc2.tableView setFrame:frame];
    staffVC.title  = @"Staff";
    staffVC.tabBarItem.image = [UIImage imageNamed:@"staff_bar"];
    
    UITabBarController *tbvc = [[UITabBarController alloc] init];
    [tbvc addChildViewController:areaVC];
    [tbvc addChildViewController:badgesVC];
    [tbvc addChildViewController:staffVC];
    
    [self.navigationController pushViewController:tbvc animated:YES];
    
    
    ////////////////////////////////////
//    NSDictionary *area = [self.areas objectAtIndex:[indexPath section]];
//    AreaViewController *areaVC = [[AreaViewController alloc] initWithAreaInfo:area];
//    [self.navigationController pushViewController:areaVC animated:YES];
}
@end
