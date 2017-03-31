//
//  MZControlTimer.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 08..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "MZControlTimer.h"
#import "MZControlTimerProtocol.h"

static const NSTimeInterval kControlTimerInterval = 0.1;

@interface MZControlTimer() {
    BOOL _repeats;
    NSTimer *_timer;
}
@end

@implementation MZControlTimer

#pragma mark - init
+ (instancetype)timer {
    return [self.class new];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)repeats {
    return [[self.class alloc] initWithTimeInterval:ti repeats:repeats];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)repeats {
    self = [super init];
    if (self) {
        _repeats      = repeats;
        _timeInterval = ti;
    }
    return self;
}

- (instancetype)init {
    return [self initWithTimeInterval:kControlTimerInterval
                              repeats:YES];
}

#pragma mark - properties
- (BOOL)isActive {
    return _timer && _timer.isValid;
}

#pragma mark - control
- (BOOL)start {
    BOOL out = [self createTimer];
    if (out) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlTimerDidStart:)]) {
            out = [_delegate controlTimerDidStart:self];
        }
    }
    return out;
}

- (BOOL)stop {
    BOOL out = [self invalidateTimer];
    if (out) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlTimerDidStop:)]) {
            out = [_delegate controlTimerDidStop:self];
        }
    }
    return out;
}

#pragma mark - timer
- (BOOL)createTimer {
    BOOL out = !self.isActive;
    if (out) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:_repeats];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return out;
}

- (BOOL)invalidateTimer {
    BOOL out =  self.isActive;
    if (out) {
        [_timer invalidate];
        _timer = nil;
    }
    return out;
}

#pragma mark - action (private)
- (void)timerAction:(NSTimer*)sender {
    if (sender == _timer) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlTimerDidFire:   )]) {
            [_delegate controlTimerDidFire:self];
        }
    }
}



@end
