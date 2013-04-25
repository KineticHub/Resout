//
//  MeritBadgeSelectionViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "MeritBadgeSelectionViewController.h"
#import "MeritBadgeDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MeritBadgeSelectionViewController ()
@property (nonatomic) int areaId;
@property (nonatomic, strong) NSMutableArray *badges;
@end

@implementation MeritBadgeSelectionViewController

-(id)initWithArea:(NSDictionary *)area
{
    self = [super init];
    if (self)
    {
        self.areaId = 0;
        if (area)
        {
            self.areaId = [[area objectForKey:@"id"] intValue];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.badges = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadCampMeritBadges:^(NSMutableArray *objects) {
            
            if (self.areaId != 0)
            {
                self.badges = [[NSMutableArray alloc] init];
                for (NSDictionary *badge in objects) {
                    if (self.areaId == [[badge objectForKey:@"area_id"] intValue]) {
                        [self.badges addObject:badge];
                    }
                }
            }
            else
            {
                self.badges = [NSMutableArray arrayWithArray:objects];
            }
            
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

#pragma mark - UITableView Override Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.badges count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = (BasicCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *badge = [self.badges objectAtIndex:[indexPath section]];
    cell.textLabel.text = [badge objectForKey:@"name"];
    cell.detailTextLabel.text = [badge objectForKey:@"area"];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:[badge objectForKey:@"thumbnail"]]];
    [cell setCellImage:[NSURLRequest requestWithURL:[NSURL URLWithString:[badge objectForKey:@"thumbnail"]]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    MeritBadgeDetailsViewController *badgeDetailsVC = [[MeritBadgeDetailsViewController alloc] initWithMeritBadge:[self.badges objectAtIndex:indexPath.section]];
    [self.navigationController pushViewController:badgeDetailsVC animated:YES];
}

@end
