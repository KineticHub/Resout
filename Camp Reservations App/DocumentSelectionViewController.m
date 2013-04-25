//
//  DocumentSelectionViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "DocumentSelectionViewController.h"
#import "BasicImageViewController.h"

@interface DocumentSelectionViewController ()
@property bool showReservationDocuments;
@property (nonatomic, strong) NSMutableArray *documents;
@end

@implementation DocumentSelectionViewController

-(id)initForReservation:(bool)resInit {
    self = [super init];
    if (self) {
        self.showReservationDocuments = resInit;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.showReservationDocuments) {
        [self loadReservationDocuments];
    } else {
        [self loadCampDocuments];
    }
}

-(void)loadReservationDocuments
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadReservationDocuments:^(NSMutableArray *objects) {
            
            self.documents = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

-(void)loadCampDocuments
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[DataHandler sharedInstance] loadCampDocuments:^(NSMutableArray *objects) {
            
            self.documents = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    });
}

#pragma mark - UITableView Override Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.documents count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCell *cell = (BasicCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *document = [self.documents objectAtIndex:[indexPath section]];
    cell.textLabel.text = [document objectForKey:@"name"];
    cell.detailTextLabel.text = [document objectForKey:@"format"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSDictionary *document = [self.documents objectAtIndex:[indexPath section]];//[[self.documents objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    
    if ([[document objectForKey:@"format"] caseInsensitiveCompare:@"IMAGE"] == NSOrderedSame) {
        NSString *docLink = [document objectForKey:@"link"];
        BasicImageViewController *campMapViewController = [[BasicImageViewController alloc] initWithImageLink:docLink];
        [self.navigationController pushViewController:campMapViewController animated:YES];
    } else {
        [self openPDFViewerWithLink:document];
    }
}

#pragma mark - Document Methods
-(void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)openPDFViewerWithLink:(NSDictionary*)documentToOpen {
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSString *documentName = [documentToOpen objectForKey:@"name"];
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.pdf",
                          documentsDirectory, documentName];
    
    NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[documentToOpen objectForKey:@"link"]]];
    [pdfData writeToFile:fileName atomically:YES];
    NSString *filePath = fileName;
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trees_bg"]];
        background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [readerViewController.view addSubview:background];
        [readerViewController.view sendSubviewToBack:background];
        
		[self presentViewController:readerViewController animated:YES completion:^{
        }];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Document Failed"
                                                          message:@"The document failed to load."
                                                         delegate:nil
                                                cancelButtonTitle:@"Okay"
                                                otherButtonTitles:nil];
        [message show];
    }
}
@end
