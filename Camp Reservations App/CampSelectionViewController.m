//
//  CampSelectionViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "CampSelectionViewController.h"
#import "DataHandler.h"
#import "PKRevealController.h"
#import "MainMenuViewController.h"
#import "CampInfoViewController.h"

@interface CampSelectionViewController ()
@property (nonatomic, strong) NSMutableArray *camps;
@end

@implementation CampSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.camps = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadReservationCamps:^(NSMutableArray *objects) {
            
            self.camps = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

#pragma mark - UITableView Override Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.camps count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = (BasicCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *camp = [self.camps objectAtIndex:[indexPath section]];
    cell.textLabel.text = [camp objectForKey:@"name"];
//    cell.detailTextLabel.text = @"PRIDE";
    [cell setCellImage:[NSURLRequest requestWithURL:[NSURL URLWithString:[camp objectForKey:@"icon"]]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSDictionary *camp = [self.camps objectAtIndex:[indexPath section]];
    [[DataHandler sharedInstance] setCampId:[[camp objectForKey:@"id"] intValue]];
    [[DataHandler sharedInstance] setCampInfo:camp];
    
    MainMenuViewController *menuVC = (MainMenuViewController *)self.revealController.leftViewController;
    [menuVC setupCampMenu];
    
    CampInfoViewController *campInfoVC = [[CampInfoViewController alloc] initWithCampInfo:camp];
    [self.revealController setFrontViewController:campInfoVC];
}

@end
