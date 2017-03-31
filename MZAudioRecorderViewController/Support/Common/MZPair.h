//
//  TGPair.h
//  TotalGym
//
//  Created by Mészáros Zoltán on 21/07/15.
//  Copyright © 2015 XL Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/* shallow copying for items */
@interface MZPair : NSObject <NSCopying>
@property (strong, nonatomic) id first;
@property (strong, nonatomic) id second;
+ (instancetype)pairWithFirst:(id)first andSecond:(id)second;
- (instancetype)initWithFirst:(id)first andSecond:(id)second;
- (BOOL)isEqualToPair:(MZPair*)pair;
@end
