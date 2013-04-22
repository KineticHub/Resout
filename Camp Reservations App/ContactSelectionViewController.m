//
//  ContactSelectionViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "ContactSelectionViewController.h"
#import "ContactDetailsViewController.h"

@interface ContactSelectionViewController ()
@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation ContactSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contacts = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadReservationContacts:^(NSMutableArray *objects) {
            
            self.contacts = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

#pragma mark - UITableView Override Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.contacts count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = (BasicCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *contact = [self.contacts objectAtIndex:[indexPath section]];
    cell.textLabel.text = [contact objectForKey:@"name"];
    cell.detailTextLabel.text = [contact objectForKey:@"position"];
    [cell setCellImage:[NSURLRequest requestWithURL:[NSURL URLWithString:[contact objectForKey:@"icon"]]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSDictionary *contact = [self.contacts objectAtIndex:[indexPath section]];
    
    ContactDetailsViewController *contactDetailsVC = [[ContactDetailsViewController alloc] initWithContactInfo:contact];
    [self.navigationController pushViewController:contactDetailsVC animated:YES];
}

@end
