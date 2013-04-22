//
//  BasicSelectionTableViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "BasicSelectionTableViewController.h"

@interface BasicSelectionTableViewController ()

@end

@implementation BasicSelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *background = [[UIView alloc] init];
    [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"trees_bg"]]];
    background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.view addSubview:background];
	
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setRowHeight:90.0];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView Data and Delegate Methods

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
	if (cell == nil) {
		cell = [[BasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
	}
    
    cell.textLabel.text = @"default text";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
