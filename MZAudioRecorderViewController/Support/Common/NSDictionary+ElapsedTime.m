//
//  NSDictionary+ElapsedTime.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 21..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "NSDictionary+ElapsedTime.h"

@implementation NSDictionary(ElapsedTime)

+ (instancetype)elapsedTimeDictionary:(NSTimeInterval)seconds {
    static const double kSecMillis = 1000;
    static const double kMinSecs  = 60;
    static const double kHourSecs = 60*kMinSecs;
    static const double kDaySecs  = 24*kHourSecs;
    
    NSUInteger days   = (NSUInteger)(seconds/kDaySecs ); seconds -= days *kDaySecs;
    NSUInteger hours  = (NSUInteger)(seconds/kHourSecs); seconds -= hours*kHourSecs;
    NSUInteger mins   = (NSUInteger)(seconds/kMinSecs ); seconds -= mins *kMinSecs;
    NSUInteger secs   = (NSUInteger)seconds            ; seconds -= secs;
    NSUInteger millis = (NSUInteger)(seconds*kSecMillis);
    
    return @{ kElapsedTimeDays         : @(days  ),
              kElapsedTimeHours        : @(hours ),
              kElapsedTimeMinutes      : @(mins  ),
              kElapsedTimeSeconds      : @(secs  ),
              kElapsedTimeMilliseconds : @(millis)};
}

- (NSUInteger)timeForKey:(NSString*)key {
    NSNumber *tmp = self[key];
    return tmp ?
        tmp.integerValue :
        0;
}

@end
