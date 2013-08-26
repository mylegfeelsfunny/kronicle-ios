//
//  Kronicle+Helper.m
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle+Helper.h"
#import "Kronicle+Life.h"
#import "Kronicle+JSON.h"
#import "KronicleEngine.h"
#import "Step+Helper.h"
#import "ManagedContextController.h"

@implementation Kronicle (Helper)

+ (NSString *)makeUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString *)createCoverImageName {
    return [NSString stringWithFormat:@"coverimage_%@.png", [Kronicle makeUUID]];
}

+ (void)getLocaleKronicles:(void (^)(NSArray *kronicles))successBlock
                 onFailure:(void (^)(NSDictionary *dict))failBlock {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"isFinishedNumber = YES"];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    
    if ([matches count] < 1) {
        failBlock(@{@"error":NO_LOCAL_KRONICLES});
        return;
    }
    
    successBlock(matches);
}

+ (void)getRemoteKronicles:(void (^)(NSArray *kronicles))successBlock
                 onFailure:(void (^)(NSError *error))failBlock {
    
    [[KronicleEngine current] allKroniclesWithCompletion:^(NSArray *kronicles) {

        NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in kronicles) {
                    Kronicle *k = [Kronicle kronicleShortFromJSONDictionary:dict];
                    [[ManagedContextController current] saveContext];
                    [arr addObject:k];
                }
                successBlock(arr);
            }
                                               onFailure:^(NSError *error) {
                                                   
                                                   NSLog(@"error : %@", error);
                                                   failBlock(error);
                                                   
                                               }];
    


}

+ (void)getLocaleKronicleWithUuid:(NSString *)uuid
                      withSuccess:(void (^)(Kronicle *kronicle))successBlock
                        onFailure:(void (^)(NSDictionary *error))failBlock {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    
    if ([matches count] < 1) {
        failBlock(@{@"error":NO_LOCAL_KRONICLE});
        return;
    }
    
    successBlock([matches lastObject]);
}

+ (void)getRemoteKronicleWithUuid:(NSString *)uuid
                      withSuccess:(void (^)(Kronicle *kronicle))successBlock
                        onFailure:(void (^)(NSError *error))failBlock {
    
    [[KronicleEngine current] fetchKronicle:uuid
                             withCompletion:^(NSDictionary *dict) {

                                 Kronicle *k = [Kronicle getKronicleWithUuid:[dict objectForKey:@"_id"]];
                                 if (!k || k.steps.count < 1) {
                                     k = [Kronicle readFromJSONDictionary:dict];
                                     [[ManagedContextController current] saveContext];
                                     successBlock(k);
                                     
                                 } else {
                                     successBlock(k);
                                 }
                             
                             }
                                  onFailure:^(NSError *error) {
                                      
                                      failBlock(error);
                                      
                                  }];
    
}

+ (void)populateLocalKronicleWithRemoteSteps:(Kronicle *)kronicle
                                 withSuccess:(void (^)(Kronicle *kronicle))successBlock
                                   onFailure:(void (^)(NSDictionary *dict))failBlock {    
    
    [[KronicleEngine current] fetchStepsForKronicleUUID:kronicle.uuid
                                         withCompletion:^(NSDictionary *dict) {
                                            [kronicle addStepsFromArray:(NSArray *)dict];
                                            [[ManagedContextController current] saveContext];
                                             
                                             if (kronicle.steps.count > 0) {
                                                 successBlock(kronicle);
                                             } else {
                                                 failBlock(@{@"error":@"bad stuff"});
                                             }

                                         }
                                              onFailure:^(NSError *error) {
                                                  failBlock(@{@"error":@"bad stuff"});
                                                  
                                              }];
}



// conversion helpers
- (NSString *)fullCoverURL {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", self.coverUrl]];
}

- (NSArray *)items {
    return [self.itemsSet allObjects];
}

- (NSArray *)steps {
    NSArray *stepsArray = [self.stepsSet allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexInKronicleNumber" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [stepsArray sortedArrayUsingDescriptors:sortDescriptors];;
}

- (void)setSteps:(NSArray *)steps {
    [self setValue:[NSSet setWithArray:steps] forKey:@"stepsSet"];
}

- (NSInteger)stepCount {
    return [self.stepCountNumber integerValue];
}

- (void)setStepCount:(NSInteger)stepCount {
    self.stepCountNumber = [NSNumber numberWithInteger:stepCount];
}

- (NSInteger)totalTime {
    NSInteger tTime = 0;
    for (Step *s in self.steps) {
        tTime += s.time;
    }
    return tTime;
}

- (NSInteger)rating {
    return [self.ratingNumber floatValue];
}

- (void)setRating:(NSInteger)rating {
    self.ratingNumber = [NSNumber numberWithInteger:rating];
}

- (BOOL)isFinished {
    return [self.ratingNumber boolValue];
}

- (void)setIsFinished:(BOOL)isFinished {
    self.isFinishedNumber = [NSNumber numberWithBool:isFinished];
}



@end
