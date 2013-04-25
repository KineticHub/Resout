//
//  DataHandler.m
//  AirlineProject
//
//  Created by Kinetic on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define RESERVATION_ID 1

#import "DataHandler.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface DataHandler ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation DataHandler
static id _instance;
@synthesize queue = _queue;
@synthesize campId = _campId;

@synthesize isCampsLoaded = _isCampsLoaded,
            isAreasLoaded = _isAreasLoaded,
            isStaffLoaded = _isStaffLoaded,
            isRanksLoaded = _isRanksLoaded,
            isMapsLoaded = _isMapsLoaded,
            isDocumentsLoaded = _isDocumentsLoaded,
            isContactsLoaded = _isContactsLoaded,
            isBadgesLoaded = _isBadgesLoaded;

@synthesize arrCamps = _arrCamps;
@synthesize arrMaps = _arrMaps;
@synthesize arrRanks = _arrRanks;
@synthesize arrDocuments = _arrDocuments;
@synthesize arrContacts = _arrContacts;
@synthesize arrBadges = _arrBadges;
@synthesize arrStaff = _arrStaff;
@synthesize arrAreas = _arrAreas;
@synthesize dicBadgeRequirements = _dicBadgeRequirements;

-(id)init {
    
    if(!_instance) 
    {
        self = [super init];
        _instance = self;
        _queue = [[NSOperationQueue alloc] init];
        _campId = -1;
    }
    
    return _instance;
}

+(DataHandler *)sharedInstance {
    
    if (_instance)
        return _instance;
    else
        return [[self alloc] init];
}

- (void)loadReservationData:(CompletionBlock)completionBlock {
    NSString *reservationPath = [NSString stringWithFormat:@"http://54.225.244.10/api/reservation/%i", RESERVATION_ID];
    [self JSONWithPath:reservationPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        self.reservationInfo = [[NSDictionary alloc] initWithDictionary:[[JSON objectAtIndex:0] objectForKey:@"fields"]];
        NSLog(@"reservation: %@", self.reservationInfo);
        completionBlock(error);
    }];
}

- (void)loadReservationCamps:(ObjectsCompletionBlock)completionBlock {
    NSString *campsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/reservation/camps/%i", RESERVATION_ID];
    [self JSONWithPath:campsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *camps = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *camp in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[camp objectForKey:@"fields"]];
            [tempDict setObject:[camp objectForKey:@"pk"] forKey:@"id"];
            [camps addObject:tempDict];
        }
        NSLog(@"camps: %@", camps);
        completionBlock(camps);
    }];
}

- (void)loadReservationDocuments:(ObjectsCompletionBlock)completionBlock {
    NSString *docsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/reservation/documents/%i", RESERVATION_ID];
    [self JSONWithPath:docsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *docs = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *doc in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[doc objectForKey:@"fields"]];
            [tempDict setObject:[doc objectForKey:@"pk"] forKey:@"id"];
            [docs addObject:tempDict];
        }
        NSLog(@"docs: %@", docs);
        completionBlock(docs);
    }];
}

- (void)loadReservationContacts:(ObjectsCompletionBlock)completionBlock {
    NSString *contactsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/reservation/contacts/%i", RESERVATION_ID];
    [self JSONWithPath:contactsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *contact in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[contact objectForKey:@"fields"]];
            [tempDict setObject:[contact objectForKey:@"pk"] forKey:@"id"];
            [contacts addObject:tempDict];
        }
        NSLog(@"contacts: %@", contacts);
        completionBlock(contacts);
    }];
}

- (void)loadCampAreas:(ObjectsCompletionBlock)completionBlock {
    NSString *areasPath = [NSString stringWithFormat:@"http://54.225.244.10/api/camp/areas/%i", self.campId];
    [self JSONWithPath:areasPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *areas = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *area in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[area objectForKey:@"fields"]];
            [tempDict setObject:[area objectForKey:@"pk"] forKey:@"id"];
            [areas addObject:tempDict];
        }
        NSLog(@"areas: %@", areas);
        completionBlock(areas);
    }];
}

- (void)loadCampContacts:(ObjectsCompletionBlock)completionBlock {
    NSString *contactsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/camp/contacts/%i", self.campId];
    [self JSONWithPath:contactsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *contact in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[contact objectForKey:@"fields"]];
            [tempDict setObject:[contact objectForKey:@"pk"] forKey:@"id"];
            [contacts addObject:tempDict];
        }
        NSLog(@"contacts: %@", contacts);
        completionBlock(contacts);
    }];
}

- (void)loadCampDocuments:(ObjectsCompletionBlock)completionBlock {
    NSString *documentsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/camp/documents/%i", self.campId];
    [self JSONWithPath:documentsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *documents = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *document in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[document objectForKey:@"fields"]];
            [tempDict setObject:[document objectForKey:@"pk"] forKey:@"id"];
            [documents addObject:tempDict];
        }
        NSLog(@"documents: %@", documents);
        completionBlock(documents);
    }];
}

- (void)loadCampStaff:(ObjectsCompletionBlock)completionBlock {
    NSString *documentsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/camp/staff/%i", self.campId];
    [self JSONWithPath:documentsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *staff = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *member in JSON) {
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[member objectForKey:@"fields"]];
            [tempDict setObject:[member objectForKey:@"pk"] forKey:@"id"];
            [tempDict setObject:[[[[member objectForKey:@"fields"] objectForKey:@"area"] objectForKey:@"fields"] objectForKey:@"name"] forKey:@"area"];
            [tempDict setObject:[[[member objectForKey:@"fields"] objectForKey:@"area"] objectForKey:@"pk"] forKey:@"area_id"];
            [tempDict setObject:[[[[member objectForKey:@"fields"] objectForKey:@"rank"] objectForKey:@"fields"] objectForKey:@"name"] forKey:@"rank"];
            [tempDict setObject:[[[[member objectForKey:@"fields"] objectForKey:@"rank"] objectForKey:@"fields"] objectForKey:@"order"] forKey:@"order"];
            [staff addObject:tempDict];
        }
        NSLog(@"staff: %@", staff);
        completionBlock(staff);
    }];
}

- (void)loadCampMeritBadges:(ObjectsCompletionBlock)completionBlock {
    NSString *badgesPath = [NSString stringWithFormat:@"http://54.225.244.10/api/camp/badges/%i", self.campId];
    [self JSONWithPath:badgesPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        NSMutableArray *badges = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempDict;
        for (NSMutableDictionary *badge in JSON)
        {
            NSLog(@"badge: %@", badge);
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:[[[badge objectForKey:@"fields"] objectForKey:@"badge"] objectForKey:@"fields"]];
            [tempDict setObject:[[[[badge objectForKey:@"fields"] objectForKey:@"area"] objectForKey:@"fields"] objectForKey:@"name"] forKey:@"area"];
            [tempDict setObject:[[[badge objectForKey:@"fields"] objectForKey:@"area"] objectForKey:@"pk"] forKey:@"area_id"];
            [tempDict setObject:[[[badge objectForKey:@"fields"] objectForKey:@"badge"] objectForKey:@"pk"] forKey:@"id"];
            [badges addObject:tempDict];
        }
        NSLog(@"badges: %@", badges);
        completionBlock(badges);
    }];
}

- (void)loadMeritBadgeRequirementsForBadge:(int)badgeId withCompletion:(ObjectsCompletionBlock)completionBlock {
    NSString *badgeRequirementsPath = [NSString stringWithFormat:@"http://54.225.244.10/api/badge/requirements/%i", badgeId];
    NSLog(@"path: %@", badgeRequirementsPath);
    [self JSONWithPath:badgeRequirementsPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        NSLog(@"requirements: %@", JSON);
        completionBlock(JSON);
    }];
}

/////////////////////////////////////////////////

- (void)saveFileWithName:(NSString*)requestName data:(NSArray*)fileData {
    
    NSRange lastSlash = [requestName rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *actualName = [requestName substringToIndex:lastSlash.location];
    
    NSString *fileName = [actualName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    NSMutableArray *fileDataWithDate = [NSMutableArray arrayWithArray:fileData];
    [fileDataWithDate insertObject:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] atIndex:0];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    [fileDataWithDate writeToFile:filePathInDocumentsDirectory atomically:YES];
    
//    NSLog(@"File Saved: %@ with data: %@", actualName, fileDataWithDate);
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathInDocumentsDirectory]) {
//        NSLog(@"exists");
//    }
}

- (NSArray*)loadArrayFromFileWithName:(NSString*)requestName {
    
    NSRange lastSlash = [requestName rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *actualName = [requestName substringToIndex:lastSlash.location];
    
    NSString *fileName = [actualName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithContentsOfFile:filePathInDocumentsDirectory];
    
//    NSLog(@"Loading return array: %@", returnArray);
    
    [returnArray removeObjectAtIndex:0];
    
    return returnArray;
}

- (NSInteger)timestampForFileWithName:(NSString*)requestName {
    
    NSRange lastSlash = [requestName rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *actualName = [requestName substringToIndex:lastSlash.location];
    
    NSString *fileName = [actualName stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithContentsOfFile:filePathInDocumentsDirectory];
    return [[returnArray objectAtIndex:0] integerValue];
}

- (void)checkExistingIds:(NSString *)requestPath parameters:(NSArray*)arrayToAdd onCompletion:(CompletionBlock2)completionBlock {
    
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger time = 0;
    
    requestPath = [NSString stringWithFormat:@"%@%d/", requestPath, time];
    NSURL *url = [NSURL URLWithString:[requestPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Remove Request: %@", requestPath);
    
    NSError * error = nil;
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc] init];
    for (NSNumber *item in arrayToAdd) {
        [sendDic setObject:item forKey:[NSString stringWithFormat:@"%@", item]];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendDic options:0 error:&error];
    NSString *myRequestString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request2 = [ [ NSMutableURLRequest alloc ] initWithURL: url ];
    
    [ request2 setHTTPMethod: @"POST" ];
    [ request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [ request2 setHTTPBody: [myRequestString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request2 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            completionBlock(request, response, JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            completionBlock(request, response, JSON, error);
    }];
    [self.queue addOperation:operation];
}

- (void)removeExistingIdsForRequest:(NSString*)requestName givenArray:(NSArray*)dataArray onCompletion:(CompletionBlock3)completionBlock{
    
//    NSLog(@"Removing");
    
    NSMutableArray *id_array = [[NSMutableArray alloc]init];
    for (NSDictionary *item in dataArray) {
        [id_array addObject:[item objectForKey:@"id"]];
    }
    
    NSLog(@"Request array: %@", id_array);
    
    [self checkExistingIds:requestName parameters:id_array onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        NSMutableArray *tempDataArray = [NSMutableArray arrayWithArray:dataArray];
        for (NSNumber *idr in JSON) {
            NSLog(@"JSON: %@", JSON);
            for (NSDictionary *remove in dataArray) {
                if ([[remove objectForKey:@"id"] integerValue] == [idr integerValue]) {
                    [tempDataArray removeObject:remove];
                }
            }
        }
        
        [self saveFileWithName:requestName data:tempDataArray];
        completionBlock(tempDataArray);
//        NSLog(@"after remove: %@", tempDataArray);
    }];
}

- (void)JSONWithPath:(NSString *)requestPath onCompletion:(CompletionBlock2)completionBlock {
    
//    NSTimeInterval lastUpdate = [self timestampForFileWithName:requestPath]; //[[NSDate date] timeIntervalSince1970];
//    NSInteger time = [[self loadArrayFromFileWithName:requestPath] count] == 0 ? 0 : lastUpdate;
//    
//    NSLog(@"time interval used: %d", time);
//    
//    requestPath = [NSString stringWithFormat:@"%@%d", requestPath, time];
//    NSURL *url = [NSURL URLWithString:[requestPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSLog(@"URL: %@", url);
//    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestPath]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(request, response, JSON, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"JSON: %@", JSON);
        completionBlock(request, response, JSON, error);
    }];
    
    [self.queue addOperation:operation];
}

- (void)addQueueOperation:(id)operation {
    [self.queue addOperation:operation];
}

- (void)setupCampOptions {
    NSString *requestPath = [NSString stringWithFormat:@"%@/camps/", kBaseDataPath];
    requestPath = [requestPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
//        NSLog(@"OH MAN INSIDE");
        [DataHandler sharedInstance].arrCamps = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrCamps) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        for (NSDictionary *camp in JSON) {
            
            if ([id_array containsObject:[camp valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrCamps) {
                    if ([[item valueForKey:@"id"] intValue ] == [[camp valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[camp valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrCamps removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[camp valueForKey:@"pk"]]) {
                
//                NSLog(@"not contained");
                NSMutableDictionary *tmpCamp = [[NSMutableDictionary alloc] init];
                
                [tmpCamp setValue: [camp valueForKey:@"pk"] forKey:@"id"];
                [tmpCamp setValue: [[camp valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                
                [[DataHandler sharedInstance].arrCamps addObject:tmpCamp];
            }
        }
        
        //THIS IS THE FILE STUFF
//        [self saveFileWithName:requestPath data:[DataHandler sharedInstance].arrCamps];
//        [NSThread sleepForTimeInterval:1];
//        NSLog(@"Array Retrieved: %@", [self loadArrayFromFileWithName:requestPath]);
        
        
//        NSLog(@"ids: %@", id_array);
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrCamps onCompletion:^(NSArray *newData) {
            [DataHandler sharedInstance].arrCamps = [NSMutableArray arrayWithArray: newData];
        }];
//        [self checkExistingIds:requestPath parameters:id_array];
        //THIS IS THE FILE STUFF
        
//        NSLog(@"This is the array: %@", [DataHandler sharedInstance].arrCamps);
        
        [DataHandler sharedInstance].isCampsLoaded = YES;
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"CampsData"
         object:self];
    }];
}

- (void)setupRequirments:(NSString *)badgeName {
    
    if (![DataHandler sharedInstance].dicBadgeRequirements) {
        [DataHandler sharedInstance].dicBadgeRequirements = [[NSMutableDictionary alloc] init];
    }
    
    NSString *badgeExtension = [NSString stringWithFormat:@"meritbadges/%@", badgeName];
    NSString *requestPath = [self requestPathForType:badgeExtension];
    
//    NSLog(@"Request Path: %@", requestPath);
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
//        NSLog(@"Call: %@ JSON Requiremetns: %@", JSON, requestPath);
        NSMutableArray *requirementsArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *requirement in [JSON objectForKey:@"requirements"])
        {
            NSMutableDictionary *tmpRequirement = [[DataHandler sharedInstance] parseRequirement:requirement];
            NSMutableArray *tmpSubrequirements = [[NSMutableArray alloc] init];
            for (NSDictionary *subrequirement in [requirement objectForKey:@"subrequirements"]) {
                [tmpSubrequirements addObject:[[DataHandler sharedInstance] parseRequirement:subrequirement]];
            }
            [tmpRequirement setValue:tmpSubrequirements forKey:@"subrequirements"];
            [requirementsArray addObject:tmpRequirement];
        }
        
        [[DataHandler sharedInstance].dicBadgeRequirements setValue:requirementsArray forKey:badgeName];
        
        NSString *notificationName = [NSString stringWithFormat:@"%@Data", badgeName];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:notificationName
         object:self];
        
//        NSLog(@"Requirements for %@: %@", badgeName, requirementsArray);
        
    }];
}

- (NSMutableDictionary *)parseRequirement:(NSDictionary *)requirement {
    
    NSMutableDictionary *parsed = [[NSMutableDictionary alloc] init];
    [parsed setValue: [requirement valueForKey:@"id"] forKey:@"id"];
    [parsed setValue: [requirement valueForKey:@"description"] forKey:@"description"];
    [parsed setValue: [requirement valueForKey:@"prerequisite"] forKey:@"prerequisite"];
    [parsed setValue: [requirement valueForKey:@"subrequirement_letter"] forKey:@"subrequirement_letter"];
    [parsed setValue: [requirement valueForKey:@"requirement_number"] forKey:@"requirement_number"];
    return parsed;
}

- (void)setupCampData:(NSString *)camp {
//    self.camp = camp;
    
    self.isAreasLoaded = NO;
    self.isBadgesLoaded = NO;
    self.isContactsLoaded = NO;
    self.isDocumentsLoaded = NO;
    self.isMapsLoaded = NO;
    self.isRanksLoaded = NO;
    self.isStaffLoaded = NO;
    
    [self getAreasData:^(NSError *error) {
        self.isAreasLoaded = (!error) ? YES : NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"AreasData"
         object:self];
    }];
    [self getBadgesData:^(NSError *error) {
        self.isBadgesLoaded = (!error) ? YES : NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"BadgesData"
         object:self];
    }];
    [self getContactsData:^(NSError *error) {
        self.isContactsLoaded = (!error) ? YES : NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ContactsData"
         object:self];
    }];
    [self getDocumentsData:^(NSError *error) {
        self.isDocumentsLoaded = (!error) ? YES : NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DocumentsData"
         object:self];
    }];
//    [self getMapsData:^(NSError *error) {
//        self.isMapsLoaded = (!error) ? YES : NO;
//    }];
    [self getRanksData:^(NSError *error) {
        self.isRanksLoaded = (!error) ? YES : NO;
    }];
    [self getStaffData:^(NSError *error) {
        self.isStaffLoaded = (!error) ? YES : NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"StaffData"
         object:self];
    }];
}

- (NSString *)requestPathForType:(NSString *)type {
    NSString *requestPath;

//    if ([self.camp length] == 0) {
//        requestPath = [NSString stringWithFormat:@"%@%@/", kBaseDataPath, type];
//    } else {
//        requestPath = [NSString stringWithFormat:@"%@%@/%@/", kBaseDataPath, self.camp, type];
//    }
    
    return requestPath;
}

- (void)getAreasData:(CompletionBlock)onCompletion {
    NSString *requestPath = [self requestPathForType:@"areas"];
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        [DataHandler sharedInstance].arrAreas = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrAreas) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        for (NSDictionary *area in JSON) {
            
            if ([id_array containsObject:[area valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrAreas) {
                    if ([[item valueForKey:@"id"] intValue ] == [[area valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[area valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrAreas removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[area valueForKey:@"pk"]]) {
                NSMutableDictionary *tmpArea = [[NSMutableDictionary alloc] init];
                
                [tmpArea setValue: [area valueForKey:@"pk"] forKey:@"id"];
                [tmpArea setValue: [[area valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                [tmpArea setValue: [[area valueForKey:@"fields"] valueForKey:@"description"] forKey:@"description"];
                [tmpArea setValue: [[area valueForKey:@"fields"] valueForKey:@"icon"] forKey:@"icon"];
                [tmpArea setValue: [[area valueForKey:@"fields"] valueForKey:@"schedule"] forKey:@"schedule"];
                
                [[DataHandler sharedInstance].arrAreas addObject:tmpArea];
            }
        }
        
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrAreas onCompletion:^(NSArray *newData) {
            [DataHandler sharedInstance].arrAreas = [NSMutableArray arrayWithArray: newData];
        }];
        onCompletion(error);
//        NSLog(@"Areas: %@", [DataHandler sharedInstance].arrAreas);
    }];
}

- (void)getStaffData:(CompletionBlock)onCompletion {
    NSString *requestPath = [self requestPathForType:@"staff"];
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        [DataHandler sharedInstance].arrStaff = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrStaff) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        for (NSDictionary *staff in JSON) {
            
            if ([id_array containsObject:[staff valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrStaff) {
                    if ([[item valueForKey:@"id"] intValue ] == [[staff valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[staff valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrStaff removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[staff valueForKey:@"pk"]]) {
                NSMutableDictionary *tmpStaff = [[NSMutableDictionary alloc] init];
                
                [tmpStaff setValue: [staff valueForKey:@"pk"] forKey:@"id"];
                [tmpStaff setValue: [[staff valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                [tmpStaff setValue: [[[staff valueForKey:@"fields"] valueForKey:@"area"] valueForKey:@"pk"] forKey:@"area"];
                [tmpStaff setValue: [[[staff valueForKey:@"fields"] valueForKey:@"rank"] valueForKey:@"pk"] forKey:@"rank"];
                [tmpStaff setValue: [[staff valueForKey:@"fields"] valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                [tmpStaff setValue: [[[[staff valueForKey:@"fields"] valueForKey:@"rank"] valueForKey:@"fields"] objectForKey:@"name"] forKey:@"position"];
                
                [[DataHandler sharedInstance].arrStaff addObject:tmpStaff];
            }
        }
        
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrStaff onCompletion:^(NSArray *newData) {
            [DataHandler sharedInstance].arrStaff = [NSMutableArray arrayWithArray: newData];
        }];
        onCompletion(error); 
//        NSLog(@"Staff data handler out: %@", [DataHandler sharedInstance].arrStaff);
    }];
}

- (void)getBadgesData:(CompletionBlock)onCompletion {
    NSString *requestPath = [self requestPathForType:@"meritbadges"];
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        [DataHandler sharedInstance].arrBadges = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrBadges) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        for (NSDictionary *badge in JSON) {
            NSLog(@"JSON BADGES: %@", JSON);
            
            if ([id_array containsObject:[badge valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrBadges) {
                    if ([[item valueForKey:@"id"] intValue ] == [[badge valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[badge valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrBadges removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[badge valueForKey:@"pk"]]) {
                NSMutableDictionary *tmpBadge = [[NSMutableDictionary alloc] init];
                
                [tmpBadge setValue: [badge valueForKey:@"pk"] forKey:@"id"];
                [tmpBadge setValue: [[[badge valueForKey:@"fields"] valueForKey:@"area"] valueForKey:@"pk"] forKey:@"area"];
                [tmpBadge setValue: [[[[badge valueForKey:@"fields"] valueForKey:@"badge"] valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                [tmpBadge setValue: [[[[badge valueForKey:@"fields"] valueForKey:@"badge"] valueForKey:@"fields"] valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                
                [[DataHandler sharedInstance].arrBadges addObject:tmpBadge];
            }
            
            if ([[DataHandler sharedInstance].dicBadgeRequirements objectForKey:[[[[badge valueForKey:@"fields"] valueForKey:@"badge"] valueForKey:@"fields"] valueForKey:@"name"]])
            {
                [[DataHandler sharedInstance] setupRequirments:[[[[badge valueForKey:@"fields"] valueForKey:@"badge"] valueForKey:@"fields"] valueForKey:@"name"]];
            }

        }
        
        NSLog(@"Badge Request: %@", requestPath);
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrBadges onCompletion:^(NSArray *newData) {
            NSLog(@"After remove: %@", newData);
            [DataHandler sharedInstance].arrBadges = [NSMutableArray arrayWithArray: newData];
        }];
        
        onCompletion(error);
        NSLog(@"Merit Badges: %@", [DataHandler sharedInstance].arrBadges);
    }];
}

-(void)checkRequirementsAndSubrequirementsForBadge:(NSString *)badgeName {
    
    NSString *requestPath = [self requestPathForType:@"meritbadges/check_requirements"];
    
    NSMutableDictionary *badgeRequirements = [[DataHandler sharedInstance].dicBadgeRequirements objectForKey:badgeName];
    NSMutableArray *reqNums = [[NSMutableArray alloc] init];
    for (NSDictionary *req in badgeRequirements) {
        [reqNums addObject: req[@"id"]];
    }
    [self removeExistingIdsForRequest:requestPath givenArray:[[DataHandler sharedInstance].dicBadgeRequirements objectForKey:badgeName] onCompletion:^(NSArray *newData) {
        NSLog(@"Returned Requirements Array After Remove: %@", newData);
        if ([newData count] != [[[DataHandler sharedInstance].dicBadgeRequirements objectForKey:badgeName] count]) {
            [[DataHandler sharedInstance].dicBadgeRequirements setObject:newData forKey:badgeName];
            [[DataHandler sharedInstance] setupRequirments:badgeName];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"RequirementsData"
             object:self];
        } else {
            NSString *requestPath2 = [self requestPathForType:@"meritbadges/check_subrequirements"];
            bool __block update = NO;
            for (NSDictionary *req in [[DataHandler sharedInstance].dicBadgeRequirements objectForKey:badgeName]) {
                if ([req[@"subrequirements"] count] > 0) {
                    [self removeExistingIdsForRequest:requestPath2 givenArray:req[@"subrequirements"] onCompletion:^(NSArray *newData) {
                        [req setValue:newData forKey:@"subrequirements"];
                        update = YES;
                    }];
                }
                if (update) {
                    [[DataHandler sharedInstance] setupRequirments:badgeName];
                }
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"RequirementsData"
                 object:self];
            }
        }
     
    }];
}

- (void)getContactsData:(CompletionBlock)onCompletion {
    NSString *requestPath = [self requestPathForType:@"contacts"];
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        [DataHandler sharedInstance].arrContacts = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrContacts) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        for (NSDictionary *contact in JSON) {
            
            if ([id_array containsObject:[contact valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrContacts) {
                    if ([[item valueForKey:@"id"] intValue ] == [[contact valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[contact valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrContacts removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[contact valueForKey:@"pk"]]) {
                NSMutableDictionary *tmpContact = [[NSMutableDictionary alloc] init];
                
                [tmpContact setValue: [contact valueForKey:@"pk"] forKey:@"id"];
                [tmpContact setValue: [[contact valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                [tmpContact setValue: [[contact valueForKey:@"fields"] valueForKey:@"position"] forKey:@"position"];
                [tmpContact setValue: [[contact valueForKey:@"fields"] valueForKey:@"email"] forKey:@"email"];
                [tmpContact setValue: [[contact valueForKey:@"fields"] valueForKey:@"number"] forKey:@"number"];
                
                [[DataHandler sharedInstance].arrContacts addObject:tmpContact];
            }
        }
        
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrContacts onCompletion:^(NSArray *newData) {
            [DataHandler sharedInstance].arrContacts = [NSMutableArray arrayWithArray: newData];
        }];
        onCompletion(error);
//        NSLog(@"Contacts: %@", [DataHandler sharedInstance].arrContacts);
    }];
}

- (void)getDocumentsData:(CompletionBlock)onCompletion {
    NSString *requestPath = [self requestPathForType:@"documents"];
//    NSLog(@"Request: %@", requestPath);
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        [DataHandler sharedInstance].arrDocuments = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrDocuments) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        [DataHandler sharedInstance].arrMaps = [[NSMutableArray alloc] init];
        
        for (NSDictionary *document in JSON) {
            
            if ([id_array containsObject:[document valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrDocuments) {
                    if ([[item valueForKey:@"id"] intValue ] == [[document valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[document valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrDocuments removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[document valueForKey:@"pk"]]) {
//                NSLog(@"Document: %@", document);
                NSMutableDictionary *tmpDocument = [[NSMutableDictionary alloc] init];
                
                [tmpDocument setValue: [document valueForKey:@"pk"] forKey:@"id"];
                [tmpDocument setValue: [[document valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                [tmpDocument setValue: [[document valueForKey:@"fields"] valueForKey:@"link"] forKey:@"link"];
                [tmpDocument setValue: [[document valueForKey:@"fields"] valueForKey:@"format"] forKey:@"format"];
                [tmpDocument setValue: [[[[document valueForKey:@"fields"] valueForKey:@"type"] valueForKey:@"fields"] valueForKey:@"name"] forKey:@"type"];
                
                
                [[DataHandler sharedInstance].arrDocuments addObject:tmpDocument];
                
//                if ([[tmpDocument valueForKey:@"type"] caseInsensitiveCompare:@"map"] == NSOrderedSame) {
//                    [[DataHandler sharedInstance].arrMaps addObject:tmpDocument];
//                }
            }
        }
        
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrDocuments onCompletion:^(NSArray *newData) {
            [DataHandler sharedInstance].arrDocuments = [NSMutableArray arrayWithArray: newData];
            
            for (NSDictionary* doc in [DataHandler sharedInstance].arrDocuments) {
                if ([[doc valueForKey:@"type"] caseInsensitiveCompare:@"map"] == NSOrderedSame) {
                    [[DataHandler sharedInstance].arrMaps addObject:doc];
                }
            }
//            NSLog(@"Docs Found: %@", [DataHandler sharedInstance].arrDocuments);
//            NSLog(@"Maps Found: %@", [DataHandler sharedInstance].arrMaps);
            onCompletion(error);
        }];
        
//        NSLog(@"Documents: %@", [DataHandler sharedInstance].arrDocuments);
    }];
}

//-(void)setupMapDataFromDocuments {
//    [DataHandler sharedInstance].arrMaps = [[NSMutableArray alloc] init];
//    
//    for (NSDictionary *map in self.arrDocuments) {
//        NSMutableDictionary *tmpMap = [[NSMutableDictionary alloc] init];
//
//        [tmpMap setValue:[map valueForKey:@"link"] forKey:@"link"];
//        [tmpMap setValue:[map valueForKey:@"name"] forKey:@"name"];
//
//        [[DataHandler sharedInstance].arrMaps addObject:tmpMap];
//    }
//}

//- (void)getMapsData:(CompletionBlock)onCompletion {
//    NSString *requestPath = [self requestPathForType:@"maps"];
//    
//    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
//    
//        [DataHandler sharedInstance].arrMaps = [[NSMutableArray alloc] init];
//        
//        for (NSDictionary *map in JSON) {
//            NSMutableDictionary *tmpMap = [[NSMutableDictionary alloc] init];
//            
//            [tmpMap setValue:[[[[map valueForKey:@"fields"] valueForKey:@"map"] valueForKey:@"fields"] valueForKey:@"link"] forKey:@"link"];
//            [tmpMap setValue:[[map valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
//            
//            [[DataHandler sharedInstance].arrMaps addObject:tmpMap];
//        }
//    
//        onCompletion(error);
////        NSLog(@"Maps: %@", [DataHandler sharedInstance].arrMaps);
//    }];
//}

- (void)getRanksData:(CompletionBlock)onCompletion {
    NSString *requestPath = [self requestPathForType:@"ranks"];
    
    [[DataHandler sharedInstance] JSONWithPath:requestPath onCompletion:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
        
        [DataHandler sharedInstance].arrRanks = [[NSMutableArray alloc] initWithArray:[self loadArrayFromFileWithName:requestPath]];
        
        NSMutableArray *id_array = [[NSMutableArray alloc]init];
        for (NSDictionary *item in [DataHandler sharedInstance].arrRanks) {
            [id_array addObject:[item objectForKey:@"id"]];
        }
        
        for (NSDictionary *rank in JSON) {
            
            if ([id_array containsObject:[rank valueForKey:@"pk"]]) {
                NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
                NSUInteger currentIndex = 0;
                for (NSDictionary *item in [DataHandler sharedInstance].arrRanks) {
                    if ([[item valueForKey:@"id"] intValue ] == [[rank valueForKey:@"pk"] intValue]) {
                        [indexesToDelete addIndex:currentIndex];
                        [id_array removeObject:[rank valueForKey:@"pk"]];
                    }
                    currentIndex++;
                }
                [[DataHandler sharedInstance].arrRanks removeObjectsAtIndexes:indexesToDelete];
            }
            
            if (![id_array containsObject:[rank valueForKey:@"pk"]]) {
                NSMutableDictionary *tmpRank = [[NSMutableDictionary alloc] init];
                
                [tmpRank setValue:[[rank valueForKey:@"fields"] valueForKey:@"name"] forKey:@"name"];
                [tmpRank setValue:[rank valueForKey:@"pk"] forKey:@"id"];
                [tmpRank setValue:[[rank valueForKey:@"fields"] valueForKey:@"order"] forKey:@"order"];
                
                [[DataHandler sharedInstance].arrRanks addObject:tmpRank];
            }
        }
        
        [self removeExistingIdsForRequest:requestPath givenArray:[DataHandler sharedInstance].arrRanks onCompletion:^(NSArray *newData) {
            [DataHandler sharedInstance].arrRanks = [NSMutableArray arrayWithArray: newData];
        }];
        onCompletion(error);
//        NSLog(@"Ranks: %@", [DataHandler sharedInstance].arrRanks);
    }];
}

@end
