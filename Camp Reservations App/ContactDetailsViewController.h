//
//  ContactDetailsViewController.h
//  Camp Reservations App
//
//  Created by Kinetic on 3/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactDetailsViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (id) initWithContactInfo:(NSDictionary *)contactInfo;
@end
