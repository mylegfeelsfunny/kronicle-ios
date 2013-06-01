//
//  KRKronicle.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRSerializable.h"

@interface KRKronicle : NSObject <KRSerializable>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSArray *steps;
@property (nonatomic, assign) NSUInteger totalTime;
@property (nonatomic, assign) int timesCompleted;
@property (nonatomic, assign) int rating;

- (void)kronicleShortFromJSONDictionary:(NSDictionary *)dict;

@end
