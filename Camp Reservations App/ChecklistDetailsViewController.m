//
//  ChecklistDetailsViewController.m
//  Goshen Scout Reservation App
//
//  Created by Kinetic on 11/18/12.
//  Copyright (c) 2012 BSA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChecklistDetailsViewController.h"

@interface ChecklistDetailsViewController ()
@property (nonatomic, strong) NSMutableDictionary *checklistItem;
@property (nonatomic, strong) NSMutableArray *checklist;
@property (nonatomic) int itemNum;
@end

@implementation ChecklistDetailsViewController

-(id)initWithChecklistItem:(int)itemNumber fromList:(NSMutableArray *)list {
    if (self = [super init]) {
        self.checklistItem = [list objectAtIndex:itemNumber];
        self.checklist = list;
        self.itemNum = itemNumber;
    }
    return self;
}

-(id)initWithChecklist:(NSMutableArray *)list {
    if (self = [super init]) {
        self.checklistItem = NULL;
        self.checklist = list;
        self.itemNum = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *background = [[UIView alloc] init];
//    [background setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"trees_bg"]]];
//    background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    
//    [self.navigationController.view addSubview:background];
//    [self.navigationController.view sendSubviewToBack:background];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    tapped.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapped];
    
    CGFloat y = 20.0;
    CGFloat x = 10.0;
    CGFloat spacer = 10.0;
    CGFloat width = 300.0;
    CGFloat height = 40.0;
    
    self.txtTitle = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.txtTitle setTextColor:[UIColor blackColor]];
    [self.txtTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.txtTitle setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(51.0/255.0) alpha:0.8]];
    [self.txtTitle.layer setCornerRadius:8];
    [self.txtTitle.layer setBorderWidth:2];
    [self.txtTitle.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.txtTitle setPlaceholder:@"Note Title"];
    [self.txtTitle setTextAlignment:NSTextAlignmentCenter];
    [self.txtTitle setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.txtTitle setReturnKeyType:UIReturnKeyDone];
    [self.txtTitle setDelegate:self];
    [self.txtTitle addTarget:self
                       action:@selector(keyboardDone:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:self.txtTitle];
    y += self.txtTitle.frame.size.height + spacer;
    
    self.txtDescription = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, height*6)];
    self.txtDescription.contentInset = UIEdgeInsetsMake(7,7,7,7);
    [self.txtDescription setFont:[UIFont systemFontOfSize:15.0]];
    [self.txtDescription setTextColor:[UIColor blackColor]];
    [self.txtDescription setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(51.0/255.0) alpha:0.8]];
    [self.txtDescription.layer setCornerRadius:8];
    [self.txtDescription.layer setBorderWidth:2];
    [self.txtDescription.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.txtDescription setDelegate:self];
    [self.view addSubview:self.txtDescription];
    y += self.txtDescription.frame.size.height + spacer;
    
    self.segPriority = [[UISegmentedControl alloc] initWithItems:@[@"Low", @"Medium", @"High"]];
    CGRect segRect = self.segPriority.frame;
    segRect.origin.x = x;
    segRect.origin.y = y;
    segRect.size.width = width;
    self.segPriority.frame = segRect;
    [self.segPriority setSelectedSegmentIndex:0];
//    [self.view addSubview:self.segPriority];
    
    if(self.itemNum != -1)
        [self readMode];
    else
        [self editMode:self];
    
//    // Instantiate a Save button to invoke the saveTask: method when tapped.
//    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
//                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
//                                   target:self action:@selector(saveTask:)];
//    
//    // Set up the Add custom button on the right of the navigation bar
//    self.navigationItem.rightBarButtonItem = saveButton;
//    
//    // Instantiate a Save button to invoke the saveTask: method when tapped.
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
//                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                     target:self action:@selector(cancelTask:)];
//    
//    // Set up the Add custom button on the right of the navigation bar
//    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Button methods

// The saveTask: method is invoked when the user taps the Save button
- (void)saveTask:(id)sender
{
    //obtain user document directory and instantiate dictionary
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Checklist.plist"];
    
    NSMutableDictionary *newItem = [[NSMutableDictionary alloc] init];
    [newItem setObject:self.txtTitle.text forKey:@"title"];
    [newItem setObject:self.txtDescription.text forKey:@"description"];
    [newItem setObject:[NSNumber numberWithInt:self.segPriority.selectedSegmentIndex] forKey:@"priority"];
    
    if(self.itemNum != -1)
    {
        [self.checklist replaceObjectAtIndex:self.itemNum withObject:newItem];
        
    } else {
        [self.checklist addObject:newItem];
        self.itemNum = [self.checklist indexOfObject:newItem];
    }
    
    //save the new information to the plist in the user documents directory
    [self.checklist writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    [self refreshFromFile];
    [self readMode];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelTask:(id)sender
{
    //pop current view, return to previous
//    [self.navigationController popViewControllerAnimated:YES];
    [self readMode];
}

- (void)doneButton:(id)sender
{
    //pop current view, return to previous
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Detail View modes

- (void)editMode:(id)sender {
    
//    self.txtDescription.layer.shadowRadius = 3;
//    self.txtDescription.layer.shadowOpacity = 0.3;
//    self.txtDescription.layer.cornerRadius = 5;
    
    self.txtTitle.userInteractionEnabled = YES;
    self.txtDescription.editable = YES;
    self.segPriority.userInteractionEnabled = YES;
    
    // Instantiate a Save button to invoke the saveTask: method when tapped.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(saveTask:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Instantiate a Save button to invoke the saveTask: method when tapped.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self action:@selector(cancelTask:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    if (self.itemNum != -1)
    {
        self.txtTitle.text = [self.checklistItem objectForKey:@"title"];;
        self.txtDescription.text = [self.checklistItem objectForKey:@"description"];;
        self.segPriority.selectedSegmentIndex = [[self.checklistItem objectForKey:@"priority"] integerValue];
    }
}

- (void)readMode
{
//    self.txtDescription.layer.shadowRadius = 3;
//    self.txtDescription.layer.shadowOpacity = 0.3;
//    self.txtDescription.layer.cornerRadius = 5;
    
    self.txtTitle.userInteractionEnabled = NO;
    self.txtDescription.editable = NO;
    self.segPriority.userInteractionEnabled = NO;
    
    // Instantiate a Save button to invoke the saveTask: method when tapped
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                   target:self action:@selector(editMode:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    if (self.itemNum != -1) //was data passed in, are we editing existing item?
    {
        self.txtTitle.text = self.txtTitle.text = [self.checklistItem objectForKey:@"title"];;
        self.txtDescription.text = [self.checklistItem objectForKey:@"description"];;
        self.segPriority.selectedSegmentIndex = [[self.checklistItem objectForKey:@"priority"] integerValue];
    }
}

-(void)refreshFromFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"Checklist.plist"];
    self.checklist = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (self.itemNum != -1) {
        self.checklistItem = [self.checklist objectAtIndex:self.itemNum];
    }
}

#pragma mark - Keyboard Handling

/*
 To enable background tap to deactivate the editing and remove the keyboard,
 the View object class is changed from UIView to UIControl so that it can trigger messages.
 The View object is the Container View containing all of the UI objects; hence, the background.
 */
- (void)backgroundTap:(id)sender
{
    [self.txtTitle resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

// The keyboardDone: method is invoked when the user taps Done on the keyboard
- (void)keyboardDone:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark -
#pragma mark - Keyboard Delegation

-(void) slideFrameUp:(BOOL)up slideAmount:(int)amount delayAmount:(float)delay
{
    const float movementDuration = 0.3f; // tweak as needed
    int movement = up ? -amount : amount;
    
    [UIView animateWithDuration:movementDuration delay:delay options:UIViewAnimationCurveEaseIn animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    } completion:^(BOOL finished) {
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self slideFrameUp:YES slideAmount:50 delayAmount:0.0];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self slideFrameUp:NO slideAmount:50 delayAmount:0.0];
}

@end
