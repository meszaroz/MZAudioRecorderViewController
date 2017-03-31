//
//  MZId.h
//  TotalWorkout
//
//  Created by Mészáros Zoltán on 30/08/16.
//  Copyright © 2016 XL Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZID : NSObject <NSCopying>

@property (strong, nonatomic) NSString *string; /* generates guid format */
@property (strong, nonatomic) NSNumber *number; /* returns only first from array */
@property (nonatomic, readonly) BOOL hasUUID; /* returns true if UUID is not from number */
@property (nonatomic, readonly) unsigned char *UUID;

+ (instancetype)ID;
+ (instancetype)IDWithNumber:(NSNumber*)number;
+ (instancetype)IDWithString:(NSString*)string;
+ (instancetype)IDWithBytes:(const uuid_t)bytes;

- (instancetype)initWithNumber:(NSNumber*)number;
- (instancetype)initWithString:(NSString*)string;
- (instancetype)initWithBytes:(const uuid_t)bytes;

- (BOOL)isCompatibleWithID:(MZID*)ID;
- (BOOL)isEqualToID:(MZID*)ID;
- (NSComparisonResult)compare:(MZID*)ID;
@end
