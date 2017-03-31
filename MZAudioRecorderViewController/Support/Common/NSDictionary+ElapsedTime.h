//
//  NSDictionary+ElapsedTime.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 21..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <Foundation/Foundation.h>

/* constants */
static NSString *kElapsedTimeDays         = @"ElapsedTimeDays";
static NSString *kElapsedTimeHours        = @"ElapsedTimeHours";
static NSString *kElapsedTimeMinutes      = @"ElapsedTimeMinutes";
static NSString *kElapsedTimeSeconds      = @"ElapsedTimeSeconds";
static NSString *kElapsedTimeMilliseconds = @"ElapsedTimeMilliseconds";

/* extension */
@interface NSDictionary(ElapsedTime)

+ (instancetype)elapsedTimeDictionary:(NSTimeInterval)seconds;

- (NSUInteger)timeForKey:(NSString*)key;

@end
