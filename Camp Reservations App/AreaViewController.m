//
//  AreaViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "AreaViewController.h"
#import "QBFlatButton.h"
#import "UIImageView+AFNetworking.h"

@interface AreaViewController ()
@property (nonatomic, strong) NSDictionary *area;
@end

@implementation AreaViewController

-(id)initWithAreaInfo:(NSDictionary *)areaInfo {
    self = [super init];
    if (self) {
        self.area = areaInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *background = [[UIView alloc] init];
    [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"trees_bg"]]];
    background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    [self.view addSubview:background];
    
    self.view.backgroundColor = [UIColor colorWithRed:(178/255.0) green:(199/255.0) blue:(250/255.0) alpha:1.0];
    
//    CGFloat y = 10.0;
//    CGFloat spacer = 10.0;
    CGFloat edgeInset = 10.0;
    CGFloat fieldWidth = 300.0;
    CGFloat fieldHeight = 40.0;
    
    UIImageView *areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 54.0)];
//    [areaImageView setImage:[UIImage imageNamed:@"goshen_forest.jpg"]];
    [areaImageView setImageWithURL:[NSURL URLWithString:[self.area objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"goshen_forest.jpg"]];
    [self.view addSubview:areaImageView];
    
    QBFlatButton *areaName = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    areaName.faceColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0];
    areaName.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    areaName.radius = 6.0;
    areaName.margin = 4.0;
    areaName.depth = 0.0;
    areaName.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [areaName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [areaName setTitle:[self.area objectForKey:@"name"] forState:UIControlStateNormal];
    [areaName setFrame:CGRectMake(edgeInset, CGRectGetMaxY(areaImageView.frame) - fieldHeight, fieldWidth, fieldHeight + 5.0)];
    [areaName setUserInteractionEnabled:NO];
    [self.view addSubview:areaName];
    
//    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, fieldWidth + 10.0, fieldHeight*4)];
//    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:0.4]];
    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, self.view.frame.size.width, fieldHeight*4)];
    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(107/255.0) green:(90/255.0) blue:(68/255.0) alpha:1.0]];
    [self.view addSubview:descriptionBackground];
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 5.0, fieldWidth, fieldHeight*4 - 15.0)];
    [descriptionView setTextColor:[UIColor whiteColor]];
    [descriptionView setBackgroundColor:[UIColor clearColor]];
    [descriptionView setEditable:NO];
    [descriptionView setFont:[UIFont systemFontOfSize:18.0]];
    [descriptionView setText:[self.area objectForKey:@"description"]];
    [descriptionBackground addSubview:descriptionView];
}

@end
