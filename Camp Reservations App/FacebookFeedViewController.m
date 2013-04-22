//
//  FacebookFeedViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 4/2/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "FacebookFeedViewController.h"
#import "TwitterFeedCell.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FacebookFeedViewController ()
@property (nonatomic, strong) NSString *fbPageName;
@property (nonatomic, strong) NSURL *fbPagePicture;
@property (nonatomic, strong) NSMutableArray *feed;
@end

@implementation FacebookFeedViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithPage:(NSString *)pageId {
    self = [super init];
    if (self)
    {
		[self setFeed:[[NSMutableArray alloc] init]];

        NSString *appID = @"500275656687463";
        NSString *appSecret = @"a76faf5da3b89e0f72ae4c6336176a01";
        NSDictionary *params = [NSDictionary dictionaryWithObjects:@[appID, appSecret, @"client_credentials", @"http://www.resoutreach.com"] forKeys:@[@"client_id", @"client_secret", @"grant_type", @"redirect_uri"]];
        
        FBRequest *genTokenRequest = [FBRequest requestWithGraphPath:@"oauth/access_token" parameters:params HTTPMethod:@"GET"];
        FBRequestConnection *conn = [[FBRequestConnection alloc] init];
        [conn addRequest:genTokenRequest completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
        {
            if (result)
            {
                NSString *token = [result objectForKey:@"FACEBOOK_NON_JSON_RESULT"];
                NSLog(@"result:%@", [result objectForKey:@"FACEBOOK_NON_JSON_RESULT"]);
                [self getFBInfoForPage:pageId];
//                [self getFBPictureForPage:pageId];
                NSString *picCallString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", pageId];
                self.fbPagePicture = [NSURL URLWithString:picCallString];
                [self getFBFeedForPageWithToken:token andPageId:pageId];
            }
            else if (error)
            {
                NSLog(@"error: %@", error);
            }
        }];
        
        [conn start];
    }
    return self;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self feed] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TwitterFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *feedItem = [[self feed] objectAtIndex:[indexPath row]];
	
	[[cell textLabel] setText:self.fbPageName];
	[[cell detailTextLabel] setText:[feedItem objectForKey:@"message"]];
	[[cell imageView] setImageWithURLRequest:[NSURLRequest requestWithURL:self.fbPagePicture] placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
            [cell.imageView setImage:image];
            [cell layoutSubviews];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
        {
            NSLog(@"cell pic error: %@", error);
        }];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *feedItem = [[self feed] objectAtIndex:[indexPath row]];
	
	float height = [[feedItem objectForKey:@"message"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(300.0 - 58.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
	
	if (height == 18.0) {
		height += 5.0;
	}
	
	return 5.0 + 22.0 + height + 5.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] init];	
	NSDictionary *feedItem = [[self feed] objectAtIndex:[indexPath row]];
	[detailViewController setText:[feedItem objectForKey:@"message"]];
	[[self navigationController] pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark FB Data Methods

-(void)getFBInfoForPage:(NSString *)pageId
{
    NSString *pageFeedPath = [[NSString stringWithFormat:@"%@/", pageId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"page feed path: %@", pageFeedPath);
    FBRequest *getPageFeed = [FBRequest requestWithGraphPath:pageFeedPath parameters:nil HTTPMethod:@"GET"];
    FBRequestConnection *conn2 = [[FBRequestConnection alloc] init];
    [conn2 addRequest:getPageFeed completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Info: %@", result);
        if (result) {
            self.fbPageName = [result objectForKey:@"name"];
        }
        if (error) {
            NSLog(@"feed error: %@", error);
        }
    }];
    [conn2 start];
}

-(void)getFBPictureForPage:(NSString *)pageId
{
    NSString *pageFeedPath = [[NSString stringWithFormat:@"%@/picture", pageId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"page feed path: %@", pageFeedPath);
    FBRequest *getPageFeed = [FBRequest requestWithGraphPath:pageFeedPath parameters:nil HTTPMethod:@"GET"];
    FBRequestConnection *conn2 = [[FBRequestConnection alloc] init];
    [conn2 addRequest:getPageFeed completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Picture Result: %@", result);
        if (result) {
            self.fbPagePicture = [NSURL URLWithString:[[result objectForKey:@"data"] objectForKey:@"url"]];
        }
        if (error) {
            NSLog(@"feed error: %@", error);
        }
    }];
    [conn2 start];
}

-(void)getFBFeedForPageWithToken:(NSString *)token andPageId:(NSString *)pageId
{
    NSString *pageFeedPath = [[NSString stringWithFormat:@"%@/feed?%@", pageId, token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"page feed path: %@", pageFeedPath);
    FBRequest *getPageFeed = [FBRequest requestWithGraphPath:pageFeedPath parameters:nil HTTPMethod:@"GET"];
    FBRequestConnection *conn2 = [[FBRequestConnection alloc] init];
    [conn2 addRequest:getPageFeed completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Feed: %@", result);
        if (result) {
            for (id item in [result objectForKey:@"data"]) {
                NSLog(@"item: %@", item);
                if ([item objectForKey:@"message"] != nil) {
                    [self.feed addObject:item];
                }
            }
            [self.tableView reloadData];
        }
        if (error) {
            NSLog(@"feed error: %@", error);
        }
    }];
    [conn2 start];
}

@end
