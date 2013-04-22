//
//  NLViewController.m
//  ImageShowcase
//
// Copyright © 2012, Mirza Bilal (bilal@mirzabilal.com)
// All rights reserved.
//  Permission is hereby granted, free of charge, to any person obtaining a copy
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 1.	Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
// 2.	Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
// 3.	Neither the name of Mirza Bilal nor the names of its contributors may be used
//       to endorse or promote products derived from this software without specific
//       prior written permission.
// THIS SOFTWARE IS PROVIDED BY MIRZA BILAL "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MIRZA BILAL BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
// IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NLViewController.h"
#import "AFImageRequestOperation.h"
#import "MWPhotoBrowser.h"

@interface NLViewController ()
@property (nonatomic, strong) NSOperationQueue *imageRequestQueue;
@end

@implementation NLViewController

-(id)init {
    self = [super init];
    self.imageRequestQueue = [[NSOperationQueue alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    _imageShowCase = [[NLImageShowCase alloc] initWithFrame:self.view.bounds];
    _imageViewer = [[NLImageViewer alloc] initWithFrame:self.view.bounds];
    
    _images = [[NSMutableArray alloc] init];
    _imageShowCase.dataSource = self;
    
    _imageShowCase.backgroundColor = [UIColor clearColor];
//    _imageShowCase.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    _imageViewer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    _imagViewController = [[UIViewController alloc] init];
    [_imagViewController.view addSubview:_imageViewer];
    
    [self.view addSubview:_imageShowCase];
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(void)addImage:(UIImage *)image
{
    [_imageShowCase setDeleteMode:NO];
    [_imageShowCase addImage:image];
    [_images addObject:image];
}

- (void)addImages:(NSArray *)images
{
    [_imageShowCase setDeleteMode:NO];
    
    for (UIImage *image in images) {
        [_imageShowCase addImage:image];
        [_images addObject:image];
    }
}

-(void)addImagesFromLinks:(NSArray *)imageLinks
{
    [_imageShowCase setDeleteMode:NO];
    
    NSURL *imageLink;
    for (NSString *link in imageLinks) {
        imageLink = [NSURL URLWithString:link];
        [self requestImageDataFromLink:imageLink];
    }
}

-(void)requestImageDataFromLink:(NSURL *)imageURL {
    
    NSMutableURLRequest *request2 = [ [ NSMutableURLRequest alloc ] initWithURL: imageURL ];
    [ request2 setHTTPMethod: @"GET" ];

    AFImageRequestOperation *imageRequestOpertation = [AFImageRequestOperation imageRequestOperationWithRequest:request2 success:^(UIImage *image)
    {
        [self addImage:image];
    }];
    
    [self.imageRequestQueue addOperation:imageRequestOpertation];
}

#pragma mark - Image Showcase Protocol
- (CGSize)imageViewSizeInShowcase:(NLImageShowCase *) imageShowCase
{
    return CGSizeMake(120, 80);
//    return CGSizeMake(55, 70);
}
- (CGFloat)imageLeftOffsetInShowcase:(NLImageShowCase *) imageShowCase
{
    return 25.0f;
//    return 20.0f;
}
- (CGFloat)imageTopOffsetInShowcase:(NLImageShowCase *) imageShowCase
{
    return 5.0f + 44.0f;
}
- (CGFloat)rowSpacingInShowcase:(NLImageShowCase *) imageShowCase
{
//    return 20.0f;
    return 25.0f;

}
- (CGFloat)columnSpacingInShowcase:(NLImageShowCase *) imageShowCase
{
//    return 20.0f;
    return 25.0f;
}
- (void)imageClicked:(NLImageShowCase *) imageShowCase imageShowCaseCell:(NLImageShowCaseCell *)imageShowCaseCell;
{
//    [_imageViewer setImage:[imageShowCaseCell image]];
//    [self.navigationController pushViewController:_imagViewController animated:YES];
    
    // Create array of `MWPhoto` objects
//    NSMutableArray *photos = [NSMutableArray array];
//    [photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]];
//    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b.jpg"]]];
//    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b.jpg"]]];
    
    // Create & present browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.wantsFullScreenLayout = YES; // Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    browser.displayActionButton = YES; // Show action button to save, copy or email photos (defaults to NO)
    [browser setInitialPageIndex:1]; // Example: allows second image to be presented first
    // Present
    [self.navigationController pushViewController:browser animated:YES];
}
- (void)imageTouchLonger:(NLImageShowCase *)imageShowCase imageIndex:(NSInteger)index;
{
//    [_imageShowCase setDeleteMode:!(_imageShowCase.deleteMode)];
}

#pragma mark MWPhotoBrowser Delegate Methods
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_images count];
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _images.count)
        return [MWPhoto photoWithImage:[_images objectAtIndex:index]];
    return nil;
}

@end
