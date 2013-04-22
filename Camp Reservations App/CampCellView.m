//
//  CampCellView.m
//  Goshen Scout Reservation App
//
//  Created by Kinetic on 12/7/12.
//  Copyright (c) 2012 BSA. All rights reserved.
//

#import "CampCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface CampCellView ()
@end

@implementation CampCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSelectable:(BOOL)isSelectableCell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        UIImage *cellBackgroundImage;
        if (isSelectableCell) {
            cellBackgroundImage = [[UIImage imageNamed:@"pointing_arrow_2"] stretchableImageWithLeftCapWidth:100.0 topCapHeight:33.0];
        } else {
            cellBackgroundImage = [[UIImage imageNamed:@"wood"] stretchableImageWithLeftCapWidth:100.0 topCapHeight:46.0];
        }
        
//        UIImage *cellBackgroundImage = [[UIImage imageNamed:@"wood"] stretchableImageWithLeftCapWidth:100.0 topCapHeight:46.0];
//        UIImage *cellBackgroundImage = [[UIImage imageNamed:@"pointing_arrow_2"] stretchableImageWithLeftCapWidth:100.0 topCapHeight:33.0];
        
        UIImageView *callBackgroundViewImageView = [[UIImageView alloc] initWithImage:cellBackgroundImage];
        [callBackgroundViewImageView setFrame:CGRectMake(0, 0, self.frame.size.width - 20.0, self.frame.size.height)];
//        [callBackgroundViewImageView setAlpha:0.9];
        [self setBackgroundView:callBackgroundViewImageView];
        [self setBackgroundColor:[UIColor clearColor]];
        
//        [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.8]];
//        [self.layer setBorderWidth:2];
//        [self.layer setBorderColor:[UIColor blackColor].CGColor];
        
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setFont:DEFAULT_CELL_TITLE_FONT]; //[UIFont boldSystemFontOfSize:20.0]];
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel setNumberOfLines:0];
        
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailTextLabel setTextColor:[UIColor whiteColor]];
//        [self.detailTextLabel setTextColor:[UIColor colorWithRed:(164/255.0) green:(244/255.0) blue:(164/255.0) alpha:1.0]];
        [self.detailTextLabel setFont:DEFAULT_CELL_DESCRIPTION_FONT];
        [self.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.detailTextLabel setNumberOfLines:2];
        [self.detailTextLabel setAlpha:0.75];
        
        self.customImageView = [[UIImageView alloc] init];
        [self addSubview: self.customImageView];
        
        UIImageView *callBackgroundViewImageViewSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointing_arrow_2_dark"]];
        [self setSelectedBackgroundView:callBackgroundViewImageViewSelected];
    }
    
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (!self.customImageView.image) {
        [self.customImageView setHidden:YES];
    } else {
        self.customImageView.frame = CGRectMake(self.contentView.frame.origin.x + 3.0, self.imageView.frame.origin.y, 45, 45);
        self.customImageView.center = CGPointMake(self.customImageView.center.x, self.contentView.center.y);
    }
}

-(void)setCellImage:(NSURLRequest *)imageURLRequest {
    
    [self.customImageView setBackgroundColor:[UIColor clearColor]];
    [self.customImageView.layer setCornerRadius:8.0];
    self.customImageView.layer.masksToBounds = YES;
    self.customImageView.autoresizesSubviews = NO;
    self.customImageView.autoresizingMask = NO;
    
    [self.customImageView setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        self.customImageView.image = image;
        
        const float colorMasking[6] = {222, 255, 222, 255, 222, 255};
        self.customImageView.image = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(self.customImageView.image.CGImage, colorMasking)];
        
        [self.customImageView setHidden:NO];
        self.customImageView.frame = CGRectMake(self.contentView.frame.origin.x + 2.0, self.imageView.frame.origin.y, 45, 45);
        self.customImageView.center = CGPointMake(self.customImageView.center.x, self.contentView.center.y);
        
        [self.customImageView layoutSubviews];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
}

@end
