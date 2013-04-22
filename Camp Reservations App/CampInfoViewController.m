//
//  CampInfoViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 4/1/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "CampInfoViewController.h"
#import "QBFlatButton.h"
#import "PKRevealController.h"
#import "CampSelectionViewController.h"

@interface CampInfoViewController ()
@property (nonatomic, strong) NSDictionary *camp;
@end

@implementation CampInfoViewController

-(id)initWithCampInfo:(NSDictionary *)campInfo {
    self = [super init];
    if (self) {
        self.camp = campInfo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat y = 10.0;
    CGFloat spacer = 10.0;
    CGFloat edgeInset = 10.0;
    CGFloat fieldWidth = 300.0;
    CGFloat fieldHeight = 40.0;
    
    UIImageView *areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 54.0)];
    [areaImageView setImage:[UIImage imageNamed:@"goshen_forest.jpg"]];
    [self.view addSubview:areaImageView];
    
    QBFlatButton *campName = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    campName.faceColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0];
    campName.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    campName.radius = 6.0;
    campName.margin = 4.0;
    campName.depth = 0.0;
    campName.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [campName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [campName setTitle:[self.camp objectForKey:@"name"] forState:UIControlStateNormal];
    [campName setFrame:CGRectMake(edgeInset, CGRectGetMaxY(areaImageView.frame) - fieldHeight, fieldWidth, fieldHeight + 5.0)];
    [campName setUserInteractionEnabled:NO];
    [self.view addSubview:campName];
    
    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, fieldWidth + 10.0, fieldHeight*4)];
    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:0.4]];
    [self.view addSubview:descriptionBackground];
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 5.0, fieldWidth, fieldHeight*4 - 15.0)];
    [descriptionView setTextColor:[UIColor whiteColor]];
    [descriptionView setBackgroundColor:[UIColor clearColor]];
    [descriptionView setEditable:NO];
    [descriptionView setText:@"This is the area description. It can be made up of many lines of text and therefore should be tested as such. I am starting to run out of ideas so now I am just mnidlessly typing some things out. This is the area description. It can be made up of many lines of text and therefore should be tested as such. I am starting to run out of ideas so now I am just mnidlessly typing some things out. This is the area description. It can be made up of many lines of text and therefore should be tested as such. I am starting to run out of ideas so now I am just mnidlessly typing some things out. This is the area description. It can be made up of many lines of text and therefore should be tested as such. I am starting to run out of ideas so now I am just mnidlessly typing some things out."];
    [descriptionBackground addSubview:descriptionView];
    
    CGFloat bottomHeight = 55.0;
    UIView *bottomChangeCampBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - bottomHeight, self.view.frame.size.width, bottomHeight)];
    [bottomChangeCampBackground setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:0.4]];
    [self.view addSubview:bottomChangeCampBackground];
    
    QBFlatButton *changeCampButton = [[QBFlatButton alloc] initWithFrame:CGRectMake(0.0, 5.0, bottomChangeCampBackground.frame.size.width/2, bottomHeight - 10.0)];
    [changeCampButton setCenter:CGPointMake(bottomChangeCampBackground.frame.size.width/2, changeCampButton.center.y)];
    changeCampButton.faceColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0];
    changeCampButton.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    changeCampButton.radius = 6.0;
    changeCampButton.margin = 4.0;
    changeCampButton.depth = 2.0;
    changeCampButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [changeCampButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeCampButton setTitle:@"Change Camp" forState:UIControlStateNormal];
    [changeCampButton addTarget:self action:@selector(showCampSelectionMenu) forControlEvents:UIControlEventTouchUpInside];
    [bottomChangeCampBackground addSubview:changeCampButton];
}

-(void)showCampSelectionMenu {
    CampSelectionViewController *camps = [[CampSelectionViewController alloc] init];
    self.revealController.frontViewController = camps;
    [self.revealController showViewController:self.revealController.frontViewController];
}
@end
