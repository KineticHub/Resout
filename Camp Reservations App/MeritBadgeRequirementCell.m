//
//  MeritBadgeRequirementCell.m
//  Camp Reservations App
//
//  Created by Kinetic on 4/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MeritBadgeRequirementCell.h"

@interface MeritBadgeRequirementCell ()
@property bool shouldShowButton;
@end

@implementation MeritBadgeRequirementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.showSubsButton = NO;
        
		[[self detailTextLabel] setLineBreakMode:UILineBreakModeWordWrap];
		[[self detailTextLabel] setNumberOfLines:NSIntegerMax];
		
		[[[self imageView] layer] setMasksToBounds:YES];
		[[[self imageView] layer] setCornerRadius:5.0];
		
		//[self setSelectionStyle:UITableViewCellSelectionStyleNone];
        /////////////////////////////////////////////////////////////
        
        [self.imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [self.imageView.layer setBorderWidth:1.0];
        
        [self setBackgroundColor:[UIColor clearColor]];
        //        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView *cellBackgroundViewImageView = [[UIImageView alloc] init];
        [cellBackgroundViewImageView setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [cellBackgroundViewImageView.layer setBorderColor:[[UIColor colorWithRed:(31/255.0) green:(31/255.0) blue:(31/255.0) alpha:1.0] CGColor]];
        [cellBackgroundViewImageView.layer setBorderWidth:1.0];
        [cellBackgroundViewImageView setBackgroundColor:[UIColor whiteColor]];
        [cellBackgroundViewImageView setAlpha:0.8];
        [self setBackgroundView:cellBackgroundViewImageView];
        
        [self.textLabel setHighlightedTextColor:[UIColor blackColor]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        //        [self.textLabel setTextColor:[UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0]];
        [self.textLabel setTextColor:[UIColor brownColor]];
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel setNumberOfLines:0];
        
        [self.detailTextLabel setHighlightedTextColor:[UIColor blackColor]];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setTextColor:[UIColor blackColor]];
        [self.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.detailTextLabel setNumberOfLines:NSIntegerMax];
        [self.detailTextLabel setAlpha:0.9];
        
        [self setupSubrequirementsButton];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    CGRect rect;
	
//	CGRect rect = [[self imageView] frame];
//	rect.origin.x = 5.0;
//	rect.origin.y = 5.0;
//	[[self imageView] setFrame:rect];
	
	rect = [[self textLabel] frame];
//	rect.origin.x = 68.0;
    rect.origin.x = 5.0;
	rect.origin.y = 5.0;
	[[self textLabel] setFrame:rect];
	
	rect = [[self detailTextLabel] frame];
//	rect.origin.x = 68.0;
    rect.origin.x = 5.0;
	rect.origin.y = 27.0;
	[[self detailTextLabel] setFrame:rect];
    
    if (self.shouldShowButton) {
        [self.showSubsButton setFrame:CGRectMake(5.0, CGRectGetMaxY(rect) + 10.0, 150.0, 30.0)];
    }
}

#pragma mark - Subrequirements
-(void)shouldShowSubrequirementsButton:(bool)show {
    self.shouldShowButton = show;
    if (show) {
        [self.showSubsButton setHidden:NO];
    } else {
        [self.showSubsButton setHidden:YES];
    }
    [self layoutSubviews];
}

-(void)setupSubrequirementsButton
{
    self.showSubsButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    self.showSubsButton.faceColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0];
    self.showSubsButton.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    self.showSubsButton.radius = 6.0;
    self.showSubsButton.margin = 4.0;
    self.showSubsButton.depth = 3.0;
    self.showSubsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.showSubsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showSubsButton setTitle:@"Toggle Subreqs" forState:UIControlStateNormal];
    [self.showSubsButton setFrame:CGRectMake(0, 0, 0, 0)];
    [self.showSubsButton setUserInteractionEnabled:YES];
    [self addSubview:self.showSubsButton];
}

-(void)showHideText:(bool)hideText
{
    if (!hideText) {
        [self.showSubsButton setTitle:@"Toggle Subreqs" forState:UIControlStateNormal];
    } else {
        [self.showSubsButton setTitle:@"Toggle Subreqs" forState:UIControlStateNormal];
    }
}

@end
