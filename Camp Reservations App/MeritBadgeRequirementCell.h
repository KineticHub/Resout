//
//  MeritBadgeRequirementCell.h
//  Camp Reservations App
//
//  Created by Kinetic on 4/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBFlatButton.h"

@interface MeritBadgeRequirementCell : UITableViewCell
@property (nonatomic, strong) QBFlatButton *showSubsButton;
-(void)shouldShowSubrequirementsButton:(bool)show;
-(void)showHideText:(bool)hideText;
@end
