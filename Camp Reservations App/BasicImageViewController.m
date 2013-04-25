//
//  BasicImageViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/19/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "BasicImageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface BasicImageViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *imgLink;
@property (nonatomic, strong) NSMutableData *recData;
@property (nonatomic, strong) NSMutableString *diskPath;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation BasicImageViewController

-(id)initWithImageLink:(NSString *)imgLinkString {
    self = [super init];
    if (self) {
        self.imgLink = imgLinkString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imgView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 - 30.0);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        __block UIViewController *selfVC = self;
        __block UIView *selfView = self.view;
//        __block UINavigationController *thisController = self.navigationController;
        NSURL *imageURL = [NSURL URLWithString:self.imgLink];
        
        [self.imgView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                            {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageReady" object:nil];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [MBProgressHUD hideHUDForView:selfView animated:YES];
                                                });
                                            }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                            {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [MBProgressHUD hideHUDForView:selfView animated:YES];
                                                });
                                                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Image Failed"
                                                                                                  message:@"The image failed to load."
                                                                                                 delegate:selfVC
                                                                                        cancelButtonTitle:@"Okay"
                                                                                        otherButtonTitles:nil];
                                                [message show];
                                            }];
        
        [self.scrollView addSubview:self.imgView];
        
        [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.scrollView setDelegate:self];
        [self.scrollView setMaximumZoomScale:2.0];
        [self.scrollView setContentSize:self.view.bounds.size];
        [self.scrollView addSubview:self.imgView];
        [self.view addSubview:self.scrollView];
        
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Okay"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
