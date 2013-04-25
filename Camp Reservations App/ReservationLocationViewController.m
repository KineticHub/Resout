//
//  ReservationLocationViewController.m
//  Camp Reservations App
//
//  Created by Kinetic on 3/20/13.
//  Copyright (c) 2013 Kinetic. All rights reserved.
//

#import "ReservationLocationViewController.h"
#import "QBFlatButton.h"
#import "DataHandler.h"
#import "MBProgressHUD.h"

@interface ReservationLocationViewController ()
@property (nonatomic, strong) NSDictionary *reservation;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ReservationLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(178/255.0) green:(199/255.0) blue:(250/255.0) alpha:1.0];
    self.locationManager = [[CLLocationManager alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[DataHandler sharedInstance] loadReservationData:^(NSError *error)
         {
             self.reservation = [DataHandler sharedInstance].reservationInfo;
             NSLog(@"reservation: %@", self.reservation);
             [self setupView];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
         }];
    });
}

-(void)setupView
{
    CGFloat y = 10.0;
    CGFloat spacer = 10.0;
    CGFloat edgeInset = 10.0;
    CGFloat fieldWidth = 300.0;
    CGFloat fieldHeight = 40.0;
    
    UIImageView *areaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 54.0)];
    [areaImageView setImage:[UIImage imageNamed:@"goshen_forest.jpg"]];
    //    [self.view addSubview:areaImageView];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 54.0)];
    [self.view addSubview:self.mapView];
    [self setupMap];
    
    QBFlatButton *resName = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    resName.faceColor = [UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0];
    resName.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    resName.radius = 6.0;
    resName.margin = 4.0;
    resName.depth = 0.0;
    resName.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [resName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resName setTitle:@"Reservation Name" forState:UIControlStateNormal];
    [resName setFrame:CGRectMake(edgeInset, CGRectGetMaxY(areaImageView.frame) - fieldHeight, fieldWidth, fieldHeight + 5.0)];
    [resName setUserInteractionEnabled:NO];
    [self.view addSubview:resName];
    
    //    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, fieldWidth + 10.0, fieldHeight*4)];
    //    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(127/255.0) green:(167/255.0) blue:(247/255.0) alpha:0.4]];
    UIView *descriptionBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 15.0, self.view.frame.size.width, fieldHeight*4)];
    [descriptionBackground setBackgroundColor:[UIColor colorWithRed:(107/255.0) green:(90/255.0) blue:(68/255.0) alpha:1.0]];
    [self.view addSubview:descriptionBackground];
    
    //    UILabel *mailingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, fieldWidth + 10.0, fieldHeight - 15.0)];
    UILabel *mailingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(areaImageView.frame) + 10.0, self.view.frame.size.width, fieldHeight - 15.0)];
    [mailingLabel setBackgroundColor:[UIColor colorWithRed:(67/255.0) green:(40/255.0) blue:(18/255.0) alpha:1.0]];
    [mailingLabel setText:@"Mailing Address"];
    [mailingLabel setTextColor:[UIColor whiteColor]];
    [mailingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:mailingLabel];
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(5.0, CGRectGetHeight(mailingLabel.frame), fieldWidth, fieldHeight*4)];
    [descriptionView setTextColor:[UIColor whiteColor]];
    [descriptionView setBackgroundColor:[UIColor clearColor]];
    [descriptionView setEditable:NO];
    [descriptionView setFont:[UIFont systemFontOfSize:16.0]];
    NSString *mailingAddressDescription = [NSString stringWithFormat:@"[Scout Name] - [Pack or Troop]\n%@\n[Camp Name]\n%@", [self.reservation objectForKey:@"name"], [self.reservation objectForKey:@"address"]];
    [descriptionView setText:mailingAddressDescription];
    [descriptionBackground addSubview:descriptionView];
    
    y = CGRectGetMaxY(descriptionBackground.frame) + spacer;
    
    QBFlatButton *navigateButton = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    navigateButton.faceColor = lightBrown;
    navigateButton.sideColor = [UIColor colorWithRed:(52/255.0) green:(25/255.0) blue:(3/255.0) alpha:0.6];
    navigateButton.radius = 6.0;
    navigateButton.margin = 4.0;
    navigateButton.depth = 3.0;
    navigateButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [navigateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigateButton setTitle:@"Use Apple Maps Navigation" forState:UIControlStateNormal];
    [navigateButton setFrame:CGRectMake(edgeInset, y, fieldWidth, fieldHeight + 5.0)];
    [navigateButton setUserInteractionEnabled:YES];
    [self.view addSubview:navigateButton];
}

/*
 * NEED TO FINISH THE GOOGLE MAPS PORTION FOR iOS 5.0, OR SWITCH TO MAKING MAP FULL VIEW IN ANOTHER CONTROLLER
 */
-(void)getDirections
{    
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        @try
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self.reservation objectForKey:@"latitude"] floatValue], [[self.reservation objectForKey:@"longitude"] floatValue]);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:[self.reservation objectForKey:@"name"]];
            
            // Set the directions mode to "Walking"
            // Can use MKLaunchOptionsDirectionsModeDriving instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            // Get the "Current User Location" MKMapItem
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                           launchOptions:launchOptions];
        }@catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
        @finally {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Navigation Failure"
                                                              message:@"Unable to navigate to the reservaitno a this time."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Okay"
                                                    otherButtonTitles:nil];
            [message show];
        }
    } else {
        
        /*********************************************************************************
         See Google Map Query Parameters at http://mapki.com/wiki/Google_Map_Parameters
         Google Map Query Parameters Used:
         
         dirflg = Direction flag: t=car, r=bus, w=walk, b=bike
         &saddr = starting address for directions
         &daddr = destination address for directions
         
         A Google Map Query cannot contain spaces. All spaces must be converted to +.
         Example: "123 Main Street, Blacksburg, VA" --> "123+Main+Street,+Blacksburg,+VA"
         ********************************************************************************/
        
        // Compose the Google map query for directions by CAR
//        NSString *campAddressURL = [campAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        NSString *userAddressURL = [userAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        
//        NSString *googleMapQuery = [NSString stringWithFormat:@"http://maps.google.com/maps?dirflg=t&saddr=%@&daddr=%@", campAddressURL, userAddressURL];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapQuery]];
    }
}

#pragma mark - Setup Mapview
-(void)setupMap {
    
    MKPointAnnotation *resAnnotation = [[MKPointAnnotation alloc] init];
    resAnnotation.title = [self.reservation objectForKey:@"name"];
    
    @try
    {
        CLLocationCoordinate2D resLocation = CLLocationCoordinate2DMake([[self.reservation objectForKey:@"latitude"] floatValue], [[self.reservation objectForKey:@"longitude"] floatValue]);
        resAnnotation.coordinate = resLocation;
        
        [self.mapView addAnnotation:resAnnotation];
        
        // CHOOSE FROM BELOW WHAT TO ZOOM TO
        
        MKMapRect flyTo = MKMapRectNull;
        
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(flyTo)) {
                flyTo = pointRect;
            } else {
                flyTo = MKMapRectUnion(flyTo, pointRect);
            }
        }
        
        // Position the map so that all overlays and annotations are visible on screen.
        self.mapView.visibleMapRect = flyTo;
        
        //    MKCoordinateRegion mapRegion;
        //    mapRegion.center.latitude = self.mapView.userLocation.coordinate.latitude;
        //    mapRegion.center.longitude = self.mapView.userLocation.coordinate.longitude;
        //    mapRegion.center = self.mapView.userLocation.coordinate;
        //    mapRegion.span.latitudeDelta = 0.01;
        //    mapRegion.span.longitudeDelta = 0.01;
        //    [self.mapView setRegion:mapRegion animated: YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

@end
