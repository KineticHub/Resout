//
//  ReservationInfoViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 4/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "ReservationInfoViewController.h"
#import "PKRevealController.h"
#import "QBFlatButton.h"
#import "MBProgressHUD.h"
#import "DataHandler.h"
#import "UIImageView+AFNetworking.h"

@interface ReservationInfoViewController ()
@property (nonatomic, strong) NSDictionary *reservation;
@end

@implementation ReservationInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(178/255.0) green:(199/255.0) blue:(250/255.0) alpha:1.0];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[DataHandler sharedInstance] loadReservationData:^(NSError *error)
        {
            self.reservation = [DataHandler sharedInstance].reservationInfo;
            [self setupView];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

-(void)setupView
{
    CGFloat y = 10.0;
    CGFloat spacer = 10.0;
    CGFloat edgeInset = 10.0;
    CGFloat fieldWidth = 300.0;
    CGFloat fieldHeight = 40.0;
    
    UIImageView *areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 54.0)];
//    [areaImageView setImage:[UIImage imageNamed:@"goshen_forest.jpg"]];
    [areaImageView setImageWithURL:[NSURL URLWithString:[self.reservation objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"goshen_forest.jpg"]];
    [self.view addSubview:areaImageView];
    
    QBFlatButton *campName = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    campName.faceColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0];
    campName.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    campName.radius = 6.0;
    campName.margin = 4.0;
    campName.depth = 0.0;
    campName.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [campName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [campName setTitle:[self.reservation objectForKey:@"name"] forState:UIControlStateNormal];
    [campName setFrame:CGRectMake(edgeInset, CGRectGetMaxY(areaImageView.frame) - fieldHeight, fieldWidth, fieldHeight + 5.0)];
    [campName setUserInteractionEnabled:NO];
    [self.view addSubview:campName];
    
//    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, fieldWidth + 10.0, fieldHeight*4)];
//    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:0.4]];
    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 15.0, self.view.frame.size.width, fieldHeight*4 + 30.0)];
    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(107/255.0) green:(90/255.0) blue:(68/255.0) alpha:1.0]];
    [self.view addSubview:descriptionBackground];
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 5.0, fieldWidth, fieldHeight*4 - 15.0)];
    [descriptionView setTextColor:[UIColor whiteColor]];
    [descriptionView setBackgroundColor:[UIColor clearColor]];
    [descriptionView setEditable:NO];
    [descriptionView setText:[self.reservation objectForKey:@"description"]];
    [descriptionView setFont:[UIFont systemFontOfSize:18.0]];
    [descriptionBackground addSubview:descriptionView];
}

@end
