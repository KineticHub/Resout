//
//  AppDelegate.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "AppDelegate.h"
#import "PKRevealController.h"
#import "MainMenuViewController.h"
#import "CampSelectionViewController.h"

#import "AreaViewController.h"
#import "MeritBadgeSelectionViewController.h"
#import "DocumentSelectionViewController.h"
#import "ContactDetailsViewController.h"
#import "ReservationLocationViewController.h"
#import "ReservationInfoViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController *rootNavigationController;
@property (nonatomic, strong) UIBarButtonItem *menuButton;
@property (nonatomic, strong) PKRevealController *revealController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.menuButton = [[UIBarButtonItem alloc]
                        initWithImage:[UIImage imageNamed:@"menu_icon"]
                        style:UIBarButtonItemStylePlain
                        target:self action:@selector(showMenu)];
    
//    CampSelectionViewController *basicSelectVC = [[CampSelectionViewController alloc] init];
//    AreaViewController *basicSelectVC = [[AreaViewController alloc] init];
//    MeritBadgeSelectionViewController *basicSelectVC = [[MeritBadgeSelectionViewController alloc] init];
//    DocumentSelectionViewController *basicSelectVC = [[DocumentSelectionViewController alloc] init];
//    ContactDetailsViewController *basicSelectVC = [[ContactDetailsViewController alloc] init];
//    ReservationLocationViewController *basicSelectVC = [[ReservationLocationViewController alloc] init];
    ReservationInfoViewController *basicSelectVC = [[ReservationInfoViewController alloc] init];
    
    
    MainMenuViewController *mainMenuVC = [[MainMenuViewController alloc] init];
    self.revealController = [PKRevealController revealControllerWithFrontViewController:basicSelectVC leftViewController:mainMenuVC options:nil];
    self.revealController.navigationItem.leftBarButtonItem = self.menuButton;
    self.rootNavigationItem = self.revealController.navigationItem;
    
    self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.revealController];
    [self.rootNavigationController.navigationBar setTintColor:darkBrown];

    UIView *background = [[UIView alloc] init];
//    [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"trees_bg"]]];
    [background setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:1.0]];
    background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.revealController.view addSubview:background];
    [self.revealController.view sendSubviewToBack:background];
    [self.revealController.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.rootNavigationController];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"handle open url");
}

#pragma mark - Menu Method
-(void)showMenu {
    
    if (self.revealController.focusedController == self.revealController.leftViewController)
    {
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    else
    {
        [self.revealController showViewController:self.revealController.leftViewController];
    }
}

@end
