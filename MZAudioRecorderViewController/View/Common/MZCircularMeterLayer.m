//
//  MZCircularMeterLayer.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 11..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCircularMeterLayer.h"

@interface MZCircularMeterLayer()

@property (nonatomic) CGFloat lastStrokeValue;

@end

@implementation MZCircularMeterLayer

+ (instancetype)layerWithCenter:(CGPoint)center radius:(CGFloat)radius strokeColor:(UIColor*)strokeColor andLineWidth:(CGFloat)width {
    return [[self alloc] initWithCenter:center radius:radius strokeColor:strokeColor andLineWidth:width];
}

- (instancetype)initWithCenter:(CGPoint)center radius:(CGFloat)radius strokeColor:(UIColor*)strokeColor andLineWidth:(CGFloat)width {
    self = [super init];
    if (self) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:radius startAngle:M_PI/2 endAngle:5*M_PI/2 clockwise:YES];
        self.path = path.CGPath;
        
        self.fillColor   = [UIColor clearColor].CGColor;
        self.strokeColor = strokeColor ? strokeColor.CGColor : [UIColor blackColor].CGColor;
        self.lineWidth   = width;
        
        self.strokeStart     = 0.0;
        self.strokeEnd       = 0.0;
        self.lastStrokeValue = 0.0;
    }
    return self;
}

- (void)animateStrokeToAngle:(CGFloat)endAngle withDuration:(CFTimeInterval)duration {
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = duration;
    drawAnimation.repeatCount         = 1.0;
    drawAnimation.removedOnCompletion = YES;
    
    self.strokeStart = 0;
    self.strokeEnd   = endAngle;
    
    drawAnimation.fromValue = @(self.lastStrokeValue);
    drawAnimation.toValue   = @(endAngle);
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    self.lastStrokeValue = endAngle;
}

@end
