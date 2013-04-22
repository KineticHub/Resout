//
//  MeritBadgeDetailsViewController.h
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeritBadgeDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (id)initWithMeritBadge:(NSDictionary *)badge;
@end
