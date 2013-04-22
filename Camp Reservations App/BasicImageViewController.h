//
//  BasicImageViewController.h
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicImageViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *imgView;
-(id)initWithImageLink:(NSString *)imgLinkString;
@end
