//
//  TGPair.m
//  TotalGym
//
//  Created by Mészáros Zoltán on 21/07/15.
//  Copyright © 2015 XL Solutions. All rights reserved.
//

#import "MZPair.h"

@implementation MZPair
+ (instancetype)pairWithFirst:(id)first andSecond:(id)second {
    return [[self alloc] initWithFirst:first andSecond:second];
}
- (instancetype)initWithFirst:(id)first andSecond:(id)second {
    self = [super init];
    if (self) {
        _first  = first;
        _second = second;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return self == object ||
        ([object isKindOfClass:self.class] && [self isEqualToPair:object]);
}

- (BOOL)isEqualToPair:(MZPair*)pair {
    return pair
    && [_first  isEqual:pair.first ]
    && [_second isEqual:pair.second];
}

- (instancetype)copyWithZone:(NSZone*)zone {
    return [[MZPair allocWithZone:zone] initWithFirst:_first andSecond:_second];
}

@end
