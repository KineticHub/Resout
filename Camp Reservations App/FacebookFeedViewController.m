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
#import "DEFacebookComposeViewController.h"
#import "PKRevealController.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>

@interface FacebookFeedViewController ()
@property (nonatomic, strong) NSString *fbPageId;
@property (nonatomic, strong) NSString *fbToken;
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
        self.fbPageId = pageId;

        NSString *appID = @"500275656687463";
        NSString *appSecret = @"a76faf5da3b89e0f72ae4c6336176a01";
        NSDictionary *params = [NSDictionary dictionaryWithObjects:@[appID, appSecret, @"client_credentials", @"http://www.resoutreach.com"] forKeys:@[@"client_id", @"client_secret", @"grant_type", @"redirect_uri"]];
        
        // Set up the Add custom button on the right of the navigation bar
        self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"POST" style:UIBarButtonItemStyleBordered target:self action:@selector(showFacebookPostComposer)];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        FBRequest *genTokenRequest = [FBRequest requestWithGraphPath:@"oauth/access_token" parameters:params HTTPMethod:@"GET"];
        FBRequestConnection *conn = [[FBRequestConnection alloc] init];
        [conn addRequest:genTokenRequest completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
        {
            NSLog(@"connection done");
            
            if (result)
            {
                NSString *token = [result objectForKey:@"FACEBOOK_NON_JSON_RESULT"];
//                NSLog(@"result:%@", [result objectForKey:@"FACEBOOK_NON_JSON_RESULT"]);
                self.fbToken = token;
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
        
        NSLog(@"connection started");
        [conn start];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Instantiate a Save button to invoke the saveTask: method when tapped
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"POST MESSAGE TO PAGE" style:UIBarButtonItemStyleDone target:self action:@selector(showFacebookPostComposer)];
    
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.rootNavigationItem.rightBarButtonItem = postButton;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.rootNavigationItem.rightBarButtonItem = nil;
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
    [[cell imageView] setImageWithURL:self.fbPagePicture];

//    UIImageView *imageViewRetriever = [[UIImageView alloc] init];
	[[cell imageView] setImageWithURLRequest:[NSURLRequest requestWithURL:self.fbPagePicture] placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
        {
//            [cell.imageView setImage:image];
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
//    NSLog(@"page feed path: %@", pageFeedPath);
    FBRequest *getPageFeed = [FBRequest requestWithGraphPath:pageFeedPath parameters:nil HTTPMethod:@"GET"];
    FBRequestConnection *conn2 = [[FBRequestConnection alloc] init];
    [conn2 addRequest:getPageFeed completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        NSLog(@"Info: %@", result);
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
//        NSLog(@"Picture Result: %@", result);
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
//        NSLog(@"Feed: %@", result);
        if (result) {
            for (id item in [result objectForKey:@"data"]) {
//                NSLog(@"item: %@", item);
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

#pragma mark - Post to FB Delegate
-(void)showFacebookPostComposer
{
    DEFacebookComposeViewController *facebookViewComposer = [[DEFacebookComposeViewController alloc] initForceUseCustomController:YES];
    [facebookViewComposer setCompletionHandlerWithMessage:^(DEFacebookComposeViewControllerResult result, NSString *message)
    {
        switch (result) {
            case DEFacebookComposeViewControllerResultCancelled:
                NSLog(@"Facebook Result: Cancelled");
                break;
            case DEFacebookComposeViewControllerResultDone:
                NSLog(@"Facebook Result: Sent");
                [self requestPermissionsAndPostWithMessage:message];
                break;
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    [self presentViewController:facebookViewComposer animated:YES completion:^{ }];
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        
//        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        
////        [mySLComposerSheet setInitialText:@"iOS 6 Social Framework test!"];
//        
////        [mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
//        
////        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
//        
//        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
//            
//            switch (result) {
//                case SLComposeViewControllerResultCancelled:
//                    NSLog(@"Post Canceled");
//                    break;
//                case SLComposeViewControllerResultDone:
//                    NSLog(@"Post Sucessful");
//                    break;
//                    
//                default:
//                    break;
//            }
//        }];
//        
//        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
//    }
}

-(void)requestPermissionsAndPostWithMessage:(NSString *)message
{
    
    __block bool _readPermissionsGranted = NO;
    __block bool _publishPermissionsGranted = NO;
    // Specify the Facebook App ID.
    NSString *_facebookAppID = @"500275656687463"; // Create a Facebook app on developers.facebook.com
    
    // Submit the first "read" request.
    // Note the format of the facebookOptions dictionary. You are required to pass these three keys: ACFacebookAppIdKey, ACFacebookAudienceKey, and ACFacebookPermissionsKey
    // Specify the read permission
    __block NSArray *_facebookPermissions = @[@"read_stream", @"email"];
    
    // Create & populate the dictionary the dictionary
    __block NSDictionary *_facebookOptions = @{   ACFacebookAppIdKey : _facebookAppID,
                            ACFacebookAudienceKey : ACFacebookAudienceFriends,
                            ACFacebookPermissionsKey : _facebookPermissions};
    
    ACAccountStore *_facebookAccountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *_facebookAccountType = [_facebookAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [_facebookAccountStore requestAccessToAccountsWithType:_facebookAccountType options:_facebookOptions completion:^(BOOL granted, NSError *error)
     {
         // If read permission are granted, we then ask for write permissions
         if (granted) {
             
             _readPermissionsGranted = YES;
             
             // We change the _facebookOptions dictionary to have a publish permission request
             _facebookPermissions =  @[@"publish_stream"];
             
             _facebookOptions = @{         ACFacebookAppIdKey : _facebookAppID,
                                           ACFacebookAudienceKey : ACFacebookAudienceFriends,
                                           ACFacebookPermissionsKey : _facebookPermissions};
             
             [_facebookAccountStore requestAccessToAccountsWithType:_facebookAccountType options:_facebookOptions completion:^(BOOL granted2, NSError *error)
              {
                  if (granted2)
                  {
                      _publishPermissionsGranted = YES;
                      // Create the facebook account
                      ACAccount *_facebookAccount = [[ACAccount alloc] initWithAccountType:_facebookAccountType];
                      NSArray *_arrayOfAccounts = [_facebookAccountStore accountsWithAccountType:_facebookAccountType];
                      _facebookAccount = [_arrayOfAccounts lastObject];
                      
                      [self postMessageWithAccount:_facebookAccount andMessage:message];
                  }
                  
                  // If permissions are not granted to publish.
                  if (!granted2)
                  {
                      NSLog(@"Publish permission error: %@", [error localizedDescription]);
                      _publishPermissionsGranted = NO;
                  }
                  
              }];
         }
         
         // If permission are not granted to read.
         if (!granted)
         {
             NSLog(@"Read permission error: %@", [error localizedDescription]);
             _readPermissionsGranted = NO;
             
             if ([[error localizedDescription] isEqualToString:@"The operation couldn’t be completed. (com.apple.accounts error 6.)"])
             {
                 [self performSelectorOnMainThread:@selector(showError) withObject:error waitUntilDone:NO];
             }
         }
         
     }];
}

-(void)showError
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Account Required" message:@"You need to setup a Facebook account within the Settings app." delegate:nil cancelButtonTitle:@"Ok." otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}

-(void)postMessageWithAccount:(ACAccount *)fbAccount andMessage:(NSString *)message
{
    ACAccount *_facebookAccount = fbAccount;
    NSString *pageGraph = [NSString stringWithFormat:@"https://graph.facebook.com/%@/feed", self.fbPageId];
    // Create the URL to the end point
    NSURL *postURL = [NSURL URLWithString:pageGraph];//@"https://graph.facebook.com/me/feed"];
    
    NSString *link = [[NSString alloc] init];
//    NSString *message = [[NSString alloc] init];
    NSString *picture = [[NSString alloc] init];
    NSString *name = [[NSString alloc] init];
    NSString *caption = [[NSString alloc] init];
    NSString *description = [[NSString alloc] init];
    
    link = @"http://developer.apple.com/library/ios/#documentation/Social/Reference/Social_Framework/_index.html%23//apple_ref/doc/uid/TP40012233";
//    message = @"Testing Social Framework";
    picture = @"http://www.stuarticus.com/wp-content/uploads/2012/08/SDKsmall.png";
    name = @"Social Framework";
    caption = @"Reference Documentation";
    description = @"The Social framework lets you integrate your app with supported social networking services. On iOS and OS X, this framework provides a template for creating HTTP requests. On iOS only, the Social framework provides a generalized interface for posting requests on behalf of the user.";
    
    NSDictionary *postDict = @{
                               @"link": link,
                               @"message" : message,
                               @"picture" : picture,
                               @"name" : name,
                               @"caption" : caption,
                               @"description" : description
                               };
    
    SLRequest *postToMyWall = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:postURL parameters:postDict];
    
    [postToMyWall setAccount:_facebookAccount];
    
    [postToMyWall performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (error) {
             // If there is an error we populate the error string with error
             NSString *_errorString = [NSString stringWithFormat:@"%@", [error localizedDescription]];
             
             // We then perform the UI update on the main thread. All UI updates must be completed on the main thread.
             [self performSelectorOnMainThread:@selector(updateErrorString) withObject:nil waitUntilDone:NO];
         }
         
         else
         {
             NSLog(@"Post successful");
         }
     }];
    
    // Tidy Up
    link = nil;
    message = nil;
    picture = nil;
    name = nil;
    caption = nil;
    description = nil;
    postDict = nil;
    postToMyWall = nil;
    postURL = nil;
    
}
@end
