//
//  MeritBadgeDetailsViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "MeritBadgeDetailsViewController.h"
#import "MBProgressHUD.h"
#import "BasicCell.h"
#import "DataHandler.h"
#import "MeritBadgeRequirementCell.h"

@interface MeritBadgeDetailsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *meritBadge;
@property (nonatomic, strong) NSMutableArray *requirements;
@property (nonatomic, strong) NSMutableArray *expanded_requirements;
@end

@implementation MeritBadgeDetailsViewController

- (id)initWithMeritBadge:(NSDictionary *)badge {
    self = [super init];
    if (self) {
        NSLog(@"badge rec details: %@", badge);
        self.meritBadge = [NSMutableDictionary dictionaryWithDictionary:badge];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.expanded_requirements = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadMeritBadgeRequirementsForBadge:[[self.meritBadge objectForKey:@"id"] intValue] withCompletion:^(NSMutableArray *objects) {
            
            self.requirements = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *description = [[NSString alloc] init];
    
    bool is_expanded = NO;
    for (NSNumber *req in self.expanded_requirements)
    {
        int count = 0;
        
        if ([req intValue] == indexPath.section)
        {
            is_expanded = YES;
            
            if (count == indexPath.row) {
                description = [[self.requirements objectAtIndex:indexPath.section] objectForKey:@"description"];
            }
            
            for (NSDictionary *sub1req in [[self.requirements objectAtIndex:indexPath.section] objectForKey:@"subrequirements"])
            {
                count++;
                
                if (count == indexPath.row) {
                    description = [sub1req objectForKey:@"description"];
                }
                
                for (NSDictionary *sub2req in [sub1req objectForKey:@"subrequirements"])
                {
                    count++;
                    
                    if (count == indexPath.row) {
                        description = [sub2req objectForKey:@"description"];
                    }
                    
                    for (NSDictionary *sub3req in [sub2req objectForKey:@"subrequirements"])
                    {
                        count++;
                        
                        if (count == indexPath.row) {
                            description = [sub3req objectForKey:@"description"];
                        }
                    }
                }
            }
        }
    }
    
    if (!is_expanded) {
        description = [[self.requirements objectAtIndex:indexPath.section] objectForKey:@"description"];
    }
	
	float height = [description sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(300.0 - 58.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
	
	if (height == 18.0) {
		height += 5.0;
	}
	
	return 5.0 + 22.0 + height + 5.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Requirement %i", section + 1 ];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.requirements count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    for (NSNumber *req in self.expanded_requirements)
    {
        int subs1 = 0;
        int subs2 = 0;
        int subs3 = 0;
        
        if ([req intValue] == section)
        {
            subs1 = [[[self.requirements objectAtIndex:section] objectForKey:@"subrequirements"] count];
            
            for (NSDictionary *sub1req in [[self.requirements objectAtIndex:section] objectForKey:@"subrequirements"])
            {
                subs2 += [[sub1req objectForKey:@"subrequirements"] count];
                
                for (NSDictionary *sub2req in [sub1req objectForKey:@"subrequirements"]) {
                    subs3 += [[sub2req objectForKey:@"subrequirements"] count];
                }
            }
            
            return subs1 + subs2 + subs3 + 1;
            break;
        }
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeritBadgeRequirementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
	if (cell == nil) {
		cell = [[MeritBadgeRequirementCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
	}
    
    if (indexPath.row != 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setUserInteractionEnabled:NO];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setUserInteractionEnabled:YES];
    }
    
    bool is_expanded = NO;
    NSString *title;
    for (NSNumber *req in self.expanded_requirements)
    {
        int count = 0;
        
        if ([req intValue] == indexPath.section)
        {
            is_expanded = YES;
            
            int requirementNumber = [[[self.requirements objectAtIndex:indexPath.section] objectForKey:@"requirement_number"] intValue];
            
            if (count == indexPath.row) {
                title = [NSString stringWithFormat:@"Requirement %i", requirementNumber];
                [cell.textLabel setText:title];
                cell.detailTextLabel.text = [[self.requirements objectAtIndex:indexPath.section] objectForKey:@"description"];
            }
            
            for (NSDictionary *sub1req in [[self.requirements objectAtIndex:indexPath.section] objectForKey:@"subrequirements"])
            {
                count++;
                
                if (count == indexPath.row) {
                    title = [NSString stringWithFormat:@"Requirement %i / %@", requirementNumber, [sub1req objectForKey:@"subrequirement_letter"]];
                    [cell.textLabel setText:title];
                    cell.detailTextLabel.text = [sub1req objectForKey:@"description"];
                }
                
                for (NSDictionary *sub2req in [sub1req objectForKey:@"subrequirements"])
                {
                    count++;
                    
                    if (count == indexPath.row) {
                        title = [NSString stringWithFormat:@"Requirement %i / %@ / %i", requirementNumber, [sub1req objectForKey:@"subrequirement_letter"],[[sub2req objectForKey:@"subrequirement_number"] intValue]];
                        [cell.textLabel setText:title];
                        cell.detailTextLabel.text = [sub2req objectForKey:@"description"];
                    }
                    
                    for (NSDictionary *sub3req in [sub2req objectForKey:@"subrequirements"])
                    {
                        count++;
                        
                        if (count == indexPath.row) {
                            title = [NSString stringWithFormat:@"Requirement %i / %@ / %i / %@", requirementNumber, [sub1req objectForKey:@"subrequirement_letter"],[[sub2req objectForKey:@"subrequirement_number"] intValue], [sub3req objectForKey:@"subrequirement_letter"]];
                            [cell.textLabel setText:title];
                            cell.detailTextLabel.text = [sub3req objectForKey:@"description"];
                        }
                    }
                }
            }
        }
    }
    
    if (!is_expanded) {
        title = [NSString stringWithFormat:@"Requirement %i", [[[self.requirements objectAtIndex:indexPath.section] objectForKey:@"requirement_number"] intValue]];
        [cell.textLabel setText:title];
        cell.detailTextLabel.text = [[self.requirements objectAtIndex:indexPath.section] objectForKey:@"description"];
    }
    
//    [[cell imageView] setImage:[self drawText:@"1" inImage:[UIImage imageNamed:@""] atPoint:cell.imageView.center]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    bool found = NO;
    for (NSNumber *req in self.expanded_requirements)
    {
        if ([req intValue] == indexPath.section) {
            [self.expanded_requirements removeObject:req];
            found = YES;
            [self.tableView reloadData];
            break;
        }
    }
    
    if (!found)
    {
        [self.expanded_requirements addObject:[NSNumber numberWithInt:indexPath.section]];
        [self.tableView reloadData];
    }
}

- (UIImage*)drawText:(NSString*)string inImage:(UIImage*)image atPoint:(CGPoint)point {
    
    UIFont *font = [UIFont boldSystemFontOfSize:26];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor blackColor] set];
    [string drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
