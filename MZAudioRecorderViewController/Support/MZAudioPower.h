//
//  MZAudioPower.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 07..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZPair.h"

@interface MZAudioPower : MZPair

@property (nonatomic) CGFloat averagePower;
@property (nonatomic) CGFloat peakPower;

+ (instancetype)pairWithAveragePower:(CGFloat)avrgPower andPeakPower:(CGFloat)peakPower;
- (instancetype)initWithAveragePower:(CGFloat)avrgPower andPeakPower:(CGFloat)peakPower;

@end

@interface MZAudioPower(Angle)

- (CGFloat)averageAngle;
- (CGFloat)peakAngle;

@end
