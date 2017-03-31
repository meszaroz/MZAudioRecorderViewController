//
//  MZAudioPower.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 07..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "MZAudioPower.h"
#import "MeterTable.h"

@interface MZAudioPower() {
    MeterTable meterTable;
}
@end

@implementation MZAudioPower

+ (instancetype)pairWithAveragePower:(CGFloat)avrgPower andPeakPower:(CGFloat)peakPower {
    return [[self alloc] initWithAveragePower:avrgPower andPeakPower:peakPower];
}

- (instancetype)initWithAveragePower:(CGFloat)avrgPower andPeakPower:(CGFloat)peakPower {
    return [super initWithFirst:@(avrgPower) andSecond:@(peakPower)];
}

- (CGFloat)averagePower {
    NSNumber *value = (NSNumber*)self.first;
    return value ?
        value.doubleValue :
        0.0;
}

- (void)setAveragePower:(CGFloat)averagePower {
    self.first = @(averagePower);
}

- (CGFloat)peakPower {
    NSNumber *value = (NSNumber*)self.second;
    return value ?
        value.doubleValue :
        0.0;
}

- (void)setPeakPower:(CGFloat)peakPower {
    self.second = @(peakPower);
}

@end

@implementation MZAudioPower(Angle)
/*
+ (CGFloat)angleFromPower:(CGFloat)power {
    static const CGFloat kMinPower = -80.0;
    static const CGFloat kMaxPower =   0.0;
    
    power = MAX(kMinPower,MIN(kMaxPower,power));
    return (power-kMinPower)/(kMaxPower-kMinPower);
}
*/
- (CGFloat)averageAngle {
    return meterTable.ValueAt(self.averagePower);
}

- (CGFloat)peakAngle {
    return meterTable.ValueAt(self.peakPower   );
}

@end
