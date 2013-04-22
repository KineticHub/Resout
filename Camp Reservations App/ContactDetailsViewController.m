//
//  ContactDetailsViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ContactDetailsViewController.h"
#import "QBFlatButton.h"

@interface ContactDetailsViewController ()
@property (nonatomic, strong) NSDictionary *contact;
@end

@implementation ContactDetailsViewController

- (id) initWithContactInfo:(NSDictionary *)contactInfo {
    self = [super init];
    if (self) {
        self.contact = contactInfo;
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
    
    /* this actually goes behind the rest of the content */
    UIView *bgDarkView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgDarkView setBackgroundColor:mediumBlue];
    [self.view addSubview:bgDarkView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trees_bg"]]; //goshen_forest.jpg
    bgImage.frame = bgDarkView.frame;
    [self.view addSubview:bgImage];
    
    UIImageView *profilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(edgeInset, y, 130, 130)];
    [profilePicView setBackgroundColor:[UIColor redColor]];
    [profilePicView.layer setBorderColor:[darkBrown CGColor]];
    [profilePicView.layer setBorderWidth:5.0];
    [profilePicView.layer setCornerRadius:8.0];
    [profilePicView.layer setMasksToBounds:YES];
    [profilePicView setCenter:CGPointMake(self.view.frame.size.width/2, profilePicView.center.y)];
    [self.view addSubview:profilePicView];
    
    y += profilePicView.frame.size.height + spacer;
    
    UILabel *profileName = [[UILabel alloc] initWithFrame:CGRectMake(0.0, y - 20.0, self.view.frame.size.width, fieldHeight - 10.0)];
    [profileName setBackgroundColor:darkBrown];
    [profileName setTextAlignment:NSTextAlignmentCenter];
    [profileName setText:[self.contact objectForKey:@"name"]];
    [profileName setTextColor:[UIColor whiteColor]];
    [profileName setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.view addSubview:profileName];
    
    UILabel *profilePosition = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(profileName.frame) - 10.0, self.view.frame.size.width, fieldHeight)];
    [profilePosition setBackgroundColor:darkBrown];
    [profilePosition setTextAlignment:NSTextAlignmentCenter];
    [profilePosition setText:[self.contact objectForKey:@"position"]];
    [profilePosition setTextColor:[UIColor lightGrayColor]];
    [profilePosition setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.view addSubview:profilePosition];
    
    [self.view bringSubviewToFront:profileName];
    
    y = CGRectGetMaxY(profilePosition.frame) + spacer*2;
//    y = bgDarkView.frame.size.height + spacer * 3;
    
    /* this actually goes behind the rest of the content */
    UIView *bgLightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(bgDarkView.frame), self.view.frame.size.width, self.view.frame.size.height/2)];
    [bgLightView setBackgroundColor:mediumBlue];
    [self.view addSubview:bgLightView];
    
    if ([[self.contact objectForKey:@"email"] length] > 0)
    {
        QBFlatButton *emailButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        emailButton.faceColor = darkBrown;
        emailButton.sideColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:0.7];
        emailButton.radius = 6.0;
        emailButton.margin = 4.0;
        emailButton.depth = 3.0;
        emailButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [emailButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [emailButton setTitle:[self.contact objectForKey:@"email"] forState:UIControlStateNormal];
        [emailButton setFrame:CGRectMake(edgeInset, y, fieldWidth, fieldHeight + 5.0)];
        [emailButton addTarget:self action:@selector(emailContact) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:emailButton];
        
        y += emailButton.frame.size.height + spacer;
    }
    
    if ([[self.contact objectForKey:@"number"] length] > 0)
    {
        QBFlatButton *callButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        callButton.faceColor = darkBrown;
        callButton.sideColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:0.7];
        callButton.radius = 6.0;
        callButton.margin = 4.0;
        callButton.depth = 3.0;
        callButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [callButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *numberToCall = [self changeNumberToPhoneNumber:[self stripStringForNumbers:[self.contact objectForKey:@"number"]]];
        [callButton setTitle:numberToCall forState:UIControlStateNormal];
        [callButton setFrame:CGRectMake(edgeInset, y, fieldWidth, fieldHeight + 5.0)];
        [callButton addTarget:self action:@selector(callContact) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:callButton];
    }
}

#pragma mark - Phone delegate method
#pragma mark TODO - ask before calling
- (void)callContact
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *numberToCall = [self stripStringForNumbers:[self.contact objectForKey:@"number"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberToCall]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device does not support calling." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

#pragma mark - Email delegate methods
- (void)emailContact
{
    //    NSLog(@"Email Contact");
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *messageTitle = @"";
        NSString *messageBody = @"";
        
        //    if (eventBody && [eventBody length] > 120)
        //        eventBody = [[eventBody substringToIndex:117] stringByAppendingString:@"..."];
        
        [mail setToRecipients:[NSArray arrayWithObject:[self.contact valueForKey:@"email"]]];
        [mail setSubject:messageTitle];
        [mail setMessageBody:messageBody isHTML:YES];
        
        [self presentViewController:mail animated:YES completion:^{
        }];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
	[self becomeFirstResponder];
    
    NSString *mailAlertMessage;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            mailAlertMessage = @"Mail sending cancelled.";
            break;
        case MFMailComposeResultSaved:
            mailAlertMessage = @"Mail saved.";
            break;
        case MFMailComposeResultSent:
            mailAlertMessage = @"Mail sent.";
            break;
        case MFMailComposeResultFailed:
            mailAlertMessage = @"Mail sending failed.";
            break;
        default:
            mailAlertMessage = @"Mail not sent.";
            break;
    }
    
	[self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *mailingAlert=[[UIAlertView alloc] initWithTitle:@"Mail" message:mailAlertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mailingAlert show];
    }];
}

-(void)searchWithText:(NSString *)searchText andScope:(NSString *)scope {
    NSLog(@"Searching Inside Contact Info Should Never Happen");
}

#pragma mark - Format Phone Number

- (NSString *)changeNumberToPhoneNumber:(NSString*)numberString {
    
    int length = [numberString length];
    NSMutableString *mutableNumberString = [NSMutableString stringWithString:numberString];
    
    if (length == 11) {
        [mutableNumberString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    [mutableNumberString insertString:@"(" atIndex:0];
    [mutableNumberString insertString:@")" atIndex:4];
    [mutableNumberString insertString:@" " atIndex:5];
    [mutableNumberString insertString:@"-" atIndex:9];
    
    return mutableNumberString;
}

- (NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    if (length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    
    return mobileNumber;
}

-(NSString *)stripStringForNumbers:(NSString*)stripString {
    
    NSString *originalString = stripString;
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    return strippedString;
}

@end
