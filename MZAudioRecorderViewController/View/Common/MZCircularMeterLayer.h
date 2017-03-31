//
//  MZCircularMeterLayer.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 11..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MZCircularMeterLayer : CAShapeLayer

+ (instancetype)layerWithCenter:(CGPoint)center radius:(CGFloat)radius strokeColor:(UIColor*)strokeColor andLineWidth:(CGFloat)width;
- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius strokeColor:(UIColor*)strokeColor andLineWidth:(CGFloat)width;

- (void)animateStrokeToAngle:(CGFloat)endAngle withDuration:(CFTimeInterval)duration;

@end
