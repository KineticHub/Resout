//
//  karTableViewController.m
//  TableProject
//
//  Created by Kinetic on 6/20/12.
//  Copyright (c) 2012 Kinetic. All rights reserved.
//

#import "karTableViewController.h"

@interface karTableViewController ()
@property BOOL isSearchable;
@end

@implementation karTableViewController

@synthesize searchDisplayController;
@synthesize delegate = _delegate;
@synthesize isSearchable = _isSearchable;

#pragma mark -
#pragma mark Lifecycle methods

-(id)initWithStyle:(UITableViewStyle)style isSearchable:(BOOL)searchable {
    
    if (self = [super init]) {
        self.isSearchable = searchable;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        [self.view addSubview:self.tableView];
    }
    
    return self;
}

- (void)viewDidLoad {
	
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:NULL];
    
    if (self.isSearchable) {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                        target:self
                                                                                        action:@selector(searchBar:)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
	
    
    if (self.isSearchable) {
	
        UISearchBar *mySearchBar = [[UISearchBar alloc] init];
        [mySearchBar setBarStyle:UIBarStyleBlackTranslucent];
    //	[mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"All",@"Device",@"Desktop",@"Portable",nil]];
        mySearchBar.delegate = self;
        [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [mySearchBar sizeToFit];
        self.tableView.tableHeaderView = mySearchBar;

        if (UIInterfaceOrientationLandscapeRight == [[UIDevice currentDevice] orientation] ||
            UIInterfaceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation])
        {
            self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 480.f, 44.f);
        }
        else
        {
            self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);
        }

        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
        [self setSearchDisplayController:searchDisplayController];
        [searchDisplayController setDelegate:self];
        [searchDisplayController setSearchResultsDataSource:self];
        
        [self.tableView setContentOffset:CGPointMake(0, 44.0f) animated:NO];
    }
    
	self.tableView.dataSource = self;
    self.tableView.delegate = self;
	self.tableView.scrollEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	/*
	 Hide the search bar
	 */
    if (self.isSearchable) {
        [self.tableView setContentOffset:CGPointMake(0, 44.f) animated:NO];
    }
	
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [_delegate numberOfSections:YES];
    }
	else
	{
        return [_delegate numberOfSections:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [_delegate numberOfRowsInSection:section isSearching:YES];
    }
	else
	{
        return [_delegate numberOfRowsInSection:section isSearching:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [_delegate cellForRowAtIndexPath:indexPath isSearching:YES tableView:tableView];
    }
	else
	{
        return [_delegate cellForRowAtIndexPath:indexPath isSearching:NO tableView:tableView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        [_delegate selectedCell:indexPath isSearching:YES];
    }
	else
	{
        [_delegate selectedCell:indexPath isSearching:NO];
    }
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_delegate searchWithText:searchText andScope:scope];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
	/*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	/*
	 Hide the search bar
	 */
	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
}

-(void)searchBar:(id)sender
{
	[searchDisplayController setActive:YES animated:YES];
}

#pragma mark
#pragma mark - Text Height Calculation

+(CGFloat)calculateTextHeight:(NSString *)text withWidth:(CGFloat)constraintWidth {
    return [karTableViewController calculateTextHeight:text withWidth:constraintWidth andFont:nil];
}

+ (CGFloat)calculateTextHeight:(NSString *)text withWidth:(CGFloat)constraintWidth andFont:(UIFont*)fontUsed
{
//    CGSize constraint = CGSizeMake(constraintWidth, 30000.0f);
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    CGFloat height = MAX(size.height, 40.0);
//    return height;
    
    // 30 is the minimum height
    UITextView *aSampleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, constraintWidth, 30)];
    aSampleTextView.text = text;
    aSampleTextView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    if (fontUsed) {
        aSampleTextView.font = fontUsed;
    }
    
    aSampleTextView.alpha = 0;
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectZero];
    [test addSubview:aSampleTextView];
    float textViewHeight = aSampleTextView.contentSize.height;
    return  textViewHeight;
}

@end
