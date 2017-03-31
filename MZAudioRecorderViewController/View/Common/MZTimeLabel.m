//
//  MZTimeLabel.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 21..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "MZTimeLabel.h"
#import "NSDictionary+ElapsedTime.h"

@interface MZTimeLabel() {
    ElapsedTimeFormatter _formatter;
}

+ (ElapsedTimeFormatter)defaultFormatter;
- (void)initialize;

@end

@implementation MZTimeLabel

+ (ElapsedTimeFormatter)defaultFormatter {
    static ElapsedTimeFormatter formatter = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        formatter = ^NSAttributedString*(NSDictionary *timeParts) {
            NSMutableString *out = [NSMutableString string];
            NSUInteger tmp;
            
            tmp = timeParts ? [timeParts timeForKey:kElapsedTimeDays        ] : 0;
            [out appendString:tmp > 0 ? [NSString stringWithFormat:@"%lu ",(unsigned long)tmp] : @""];
            
            tmp = timeParts ? [timeParts timeForKey:kElapsedTimeHours       ] : 0;
            [out appendString:tmp > 0 ? [NSString stringWithFormat:@"%lu:",(unsigned long)tmp] : @""];
            
            tmp = timeParts ? [timeParts timeForKey:kElapsedTimeMinutes     ] : 0;
            [out appendFormat:@"%02lu:",(unsigned long)tmp];
            
            tmp = timeParts ? [timeParts timeForKey:kElapsedTimeSeconds     ] : 0;
            [out appendFormat:@"%02lu.",(unsigned long)tmp];
            
            tmp = timeParts ? [timeParts timeForKey:kElapsedTimeMilliseconds]/100 : 0;
            [out appendFormat:@"%01lu" ,(unsigned long)tmp];
            
            return [[NSAttributedString alloc] initWithString:out
                                                   attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]}];
        };
    });
    return formatter;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.textAlignment = NSTextAlignmentCenter;
    self.elapsedTime = 0.0;
}

- (ElapsedTimeFormatter)formatter {
    if (!_formatter) {
        _formatter = [self.class defaultFormatter];
    }
    return _formatter;
}

- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _elapsedTime = elapsedTime;
    self.attributedText = self.formatter([NSDictionary elapsedTimeDictionary:elapsedTime]);
}

@end

static NSString *kAnimationKey = @"LabelAnimation";

@implementation MZTimeLabel(Animate)

- (void)reset {
    self.elapsedTime = 0.0;
    [self stopAnimation];
}

- (void)startAnimation:(CABasicAnimation*)animation {
    [self stopAnimation];
    if (animation) {
        [self.layer addAnimation:animation forKey:kAnimationKey];
    }
}

- (void)stopAnimation {
    [self.layer removeAnimationForKey:kAnimationKey];
}

@end
