//
//  FacebookFeedViewController.h
//  Camp Reservations App
//
//  Created by Kinetic on 4/2/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BasicSelectionTableViewController.h"

@interface FacebookFeedViewController : BasicSelectionTableViewController
- (id)initWithPage:(NSString *)pageId;
@end
