//
//  karTableViewController.h
//  TableProject
//
//  Created by Kinetic on 6/20/12.
//  Copyright (c) 2012 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class karTableViewController;
@protocol karTableViewControllerDelegate <NSObject>

@required
-(NSInteger)numberOfSections:(BOOL)isSearching;
-(NSInteger)numberOfRowsInSection:(NSInteger)section isSearching:(BOOL)isSearching;
-(UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath isSearching:(BOOL)isSearching tableView:(UITableView *)tableView;
-(void)selectedCell:(NSIndexPath *)indexPath isSearching:(BOOL)isSearching;
-(void)searchWithText:(NSString *)searchText andScope:(NSString *)scope;
@end

@interface karTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    id _delegate;
}

-(id)initWithStyle:(UITableViewStyle)style isSearchable:(BOOL)searchable;
+(CGFloat)calculateTextHeight:(NSString *)text withWidth:(CGFloat)constraintWidth;
+ (CGFloat)calculateTextHeight:(NSString *)text withWidth:(CGFloat)constraintWidth andFont:(UIFont*)fontUsed;

@property (nonatomic, strong) id <karTableViewControllerDelegate> delegate;
@property (nonatomic, retain) UISearchDisplayController	*searchDisplayController;
@property (nonatomic, strong) UITableView *tableView;

@end
