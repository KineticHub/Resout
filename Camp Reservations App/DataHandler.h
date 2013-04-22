//
//  DataHandler.h
//  AirlineProject
//
//  Created by Kinetic on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

typedef void(^CompletionBlock)(NSError *error);
typedef void(^CompletionBlock2)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error);
typedef void(^CompletionBlock3)(NSArray *newData);
typedef void(^ObjectsCompletionBlock)(NSMutableArray* objects);

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (DataHandler *)sharedInstance;

- (void)loadReservationData:(CompletionBlock)completionBlock;
- (void)loadReservationCamps:(ObjectsCompletionBlock)completionBlock;
- (void)loadReservationDocuments:(ObjectsCompletionBlock)completionBlock;
- (void)loadReservationContacts:(ObjectsCompletionBlock)completionBlock;
- (void)loadCampAreas:(ObjectsCompletionBlock)completionBlock;
- (void)loadCampContacts:(ObjectsCompletionBlock)completionBlock;
- (void)loadCampDocuments:(ObjectsCompletionBlock)completionBlock;
- (void)loadCampStaff:(ObjectsCompletionBlock)completionBlock;
- (void)loadCampMeritBadges:(ObjectsCompletionBlock)completionBlock;
- (void)loadMeritBadgeRequirementsForBadge:(int)badgeId withCompletion:(ObjectsCompletionBlock)completionBlock;

- (void)JSONWithPath:(NSString *)requestPath onCompletion:(CompletionBlock2)completionBlock;
- (void)setupCampOptions;
- (void)setupCampData:(NSString *)camp;
- (void)setupRequirments:(NSString *)badgeName;
- (void)addQueueOperation:(id)operation;
- (void)checkRequirementsAndSubrequirementsForBadge:(NSString *)badgeName;

@property int campId;
@property (nonatomic, strong) NSDictionary *campInfo;
@property (nonatomic, strong) NSDictionary *reservationInfo;

@property (nonatomic) BOOL isCampsLoaded;
@property (nonatomic) BOOL isAreasLoaded;
@property (nonatomic) BOOL isStaffLoaded;
@property (nonatomic) BOOL isRanksLoaded;
@property (nonatomic) BOOL isMapsLoaded;
@property (nonatomic) BOOL isDocumentsLoaded;
@property (nonatomic) BOOL isContactsLoaded;
@property (nonatomic) BOOL isBadgesLoaded;

@property (nonatomic, strong) NSMutableArray *arrCamps;
@property (nonatomic, strong) NSMutableArray *arrMaps;
@property (nonatomic, strong) NSMutableArray *arrRanks;
@property (nonatomic, strong) NSMutableArray *arrDocuments;
@property (nonatomic, strong) NSMutableArray *arrContacts;
@property (nonatomic, strong) NSMutableArray *arrBadges;
@property (nonatomic, strong) NSMutableArray *arrStaff;
@property (nonatomic, strong) NSMutableArray *arrAreas;
@property (nonatomic, strong) NSMutableDictionary *dicBadgeRequirements;


@end
