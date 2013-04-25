//
//  StaffViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "StaffViewController.h"

@interface StaffViewController ()
@property (nonatomic) int areaId;
@property (nonatomic, strong) NSMutableArray *staff;
@end

@implementation StaffViewController

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
    self.staff = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadCampStaff:^(NSMutableArray *objects) {
            
            if (self.areaId != 0)
            {
                self.staff = [[NSMutableArray alloc] init];
                for (NSDictionary *member in objects) {
                    if (self.areaId == [[member objectForKey:@"area_id"] intValue]) {
                        [self.staff addObject:member];
                    }
                }
            }
            else
            {
                self.staff = [NSMutableArray arrayWithArray:objects];
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
    return [self.staff count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = (BasicCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *staff = [self.staff objectAtIndex:[indexPath section]];
    cell.textLabel.text = [staff objectForKey:@"name"];
    NSLog(@"staff: %@", staff);
    NSString *detailString = [NSString stringWithFormat:@"%@ - %@", [staff objectForKey:@"area"], [staff objectForKey:@"rank"]];
    cell.detailTextLabel.text = detailString;
    [cell setCellImage:[NSURLRequest requestWithURL:[NSURL URLWithString:[staff objectForKey:@"icon"]]]];
    
    return cell;
}

@end
