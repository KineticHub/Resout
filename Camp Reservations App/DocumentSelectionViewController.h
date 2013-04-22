//
//  DocumentSelectionViewController.h
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicSelectionTableViewController.h"
#import "ReaderViewController.h"
#import "ReaderDocument.h"

@interface DocumentSelectionViewController : BasicSelectionTableViewController <ReaderViewControllerDelegate, UIAlertViewDelegate>
-(id)initForReservation:(bool)resInit;
@end
