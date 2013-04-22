//
//  ChecklistDetailsViewController.h
//  Goshen Scout Reservation App
//
//  Created by Kinetic on 11/18/12.
//  Copyright (c) 2012 BSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChecklistDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *txtTitle;
@property (strong, nonatomic) UITextView *txtDescription;
@property (strong, nonatomic) UISegmentedControl *segPriority;

-(id)initWithChecklist:(NSMutableArray *)list;
-(id)initWithChecklistItem:(int)itemNumber fromList:(NSMutableArray *)list;

@end
