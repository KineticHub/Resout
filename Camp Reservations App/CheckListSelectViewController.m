//
//  CheckListSelectViewController.m
//  Goshen Scout Reservation App
//
//  Created by Kinetic on 11/18/12.
//  Copyright (c) 2012 BSA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CheckListSelectViewController.h"
#import "ChecklistDetailsViewController.h"
#import "CampCellView.h"
#import "PKRevealController.h"

@interface CheckListSelectViewController ()
@property (nonatomic, strong) NSMutableArray *checklistArray;
@end

@implementation CheckListSelectViewController

//-(id)init {
//    self = [self initWithStyle:UITableViewStylePlain isSearchable:YES];
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.delegate = self;
    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tableView setRowHeight:70.0];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(51.0/255.0) alpha:0.8]];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    
    self.navigationItem.title = @"Checklist";
    
	self.checklistArray = [[NSMutableArray alloc] init];
    
    // Instantiate a New button to invoke the addTask: method when tapped.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"New"
                                  style:UIBarButtonItemStylePlain
                                  target:self action:@selector(addTask:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Checklist.plist"];
    self.checklistArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    if (!self.checklistArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Checklist" ofType:@"plist"];
        self.checklistArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        [self.checklistArray writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    }
    [self.tableView reloadData];
}

#pragma mark - Add Task Method

// The addCity: method is invoked when the user taps the Add button created at run time.
- (void)addTask:(id)sender
{
    ChecklistDetailsViewController *cdvc = [[ChecklistDetailsViewController alloc] initWithChecklist:self.checklistArray];
    [self.navigationController pushViewController:cdvc animated:YES];
}

#pragma mark - Table methods

-(NSInteger)numberOfSections:(BOOL)isSearching {
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section isSearching:(BOOL)isSearching {
    return [self.checklistArray count];
}

-(UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath isSearching:(BOOL)isSearching tableView:(UITableView *)tableView{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        
        UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [accessoryButton setImage:[UIImage imageNamed:@"black_indicator"] forState:UIControlStateNormal];
        [accessoryButton addTarget:self action:@selector(showChecklistDetails:event:) forControlEvents:UIControlEventTouchUpInside];
        [accessoryButton setFrame:CGRectMake(0, 0, 30, 30)];
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cell.detailTextLabel setNumberOfLines:2];
        [cell setAccessoryView:accessoryButton];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5]];
//        cell.accessoryView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
	}
    
    cell.textLabel.text = [[self.checklistArray objectAtIndex:[indexPath row]] objectForKey:@"title"];
//    cell.detailTextLabel.text = [[self.checklistArray objectAtIndex:[indexPath row]] objectForKey:@"description"];
    
    NSLog(@"Chceklist: %@", self.checklistArray);
    
    if ([[[self.checklistArray objectAtIndex:[indexPath row]] objectForKey:@"completed"] boolValue]) {
        [cell.imageView setImage:[UIImage imageNamed:@"black_checked_box"]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"black_unchecked_box"]];
    }
    
    cell.imageView.tag = indexPath.row;
    cell.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateCheckmark:)];
    tapped.numberOfTapsRequired = 1;
    [cell.imageView addGestureRecognizer:tapped];
    
    return cell;
}

-(void)selectedCell:(NSIndexPath *)indexPath isSearching:(BOOL)isSearching {
//    ChecklistDetailsViewController *detailVC = [[ChecklistDetailsViewController alloc] initWithChecklistItem:[indexPath row] fromList:self.checklistArray];
////    ChecklistDetailsViewController *detailVC = [[ChecklistDetailsViewController alloc] initWithChecklistItem:NULL];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"accessory tapped");
//    ChecklistDetailsViewController *detailVC = [[ChecklistDetailsViewController alloc] initWithChecklistItem:[indexPath row] fromList:self.checklistArray];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
//        [self loadFromFile];
        
        NSUInteger rowNumber = [indexPath row];
        
        [self.checklistArray removeObjectAtIndex:rowNumber];
//        self.toDoTitles = [[self.toDoList allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        //obtain user document directory and instantiate dictionary
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Checklist.plist"];
        [self.checklistArray writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
        
        [self.tableView reloadData];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //Unused
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)updateCheckmark :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
//    NSLog(@"Tag = %d", gesture.view.tag);
    
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    //obtain user document directory and instantiate dictionary
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Checklist.plist"];
    
    if ([[[self.checklistArray objectAtIndex:imageView.tag] objectForKey:@"completed"] boolValue]) {
        [[self.checklistArray objectAtIndex:imageView.tag] setObject:@NO forKey:@"completed"];
        [imageView setImage:[UIImage imageNamed:@"black_unchecked_box"]];
    } else {
        [[self.checklistArray objectAtIndex:imageView.tag] setObject:@YES forKey:@"completed"];
        [imageView setImage:[UIImage imageNamed:@"black_checked_box"]];
    }
    
    [imageView layoutSubviews];
    
    //save the new information to the plist in the user documents directory
    [self.checklistArray writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
}

-(void)showChecklistDetails:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    NSLog(@"accessory tapped");
    if (indexPath) {
        ChecklistDetailsViewController *detailVC = [[ChecklistDetailsViewController alloc] initWithChecklistItem:[indexPath row] fromList:self.checklistArray];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

-(void)searchWithText:(NSString *)searchText andScope:(NSString *)scope {
    NSLog(@"Searching: %@", searchText);
}


@end
