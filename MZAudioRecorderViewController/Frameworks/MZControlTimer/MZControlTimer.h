//
//  MZControlTimer.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 08..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZControlTimerProtocol.h"

@interface MZControlTimer : NSObject

@property (nonatomic, readonly, getter=isActive) BOOL active;

@property (nonatomic, readonly) NSTimeInterval timeInterval;
@property (weak, nonatomic) id<MZControlTimerDelegate> delegate;

+ (instancetype)timer;
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)repeats;
- (instancetype)initWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)repeats;

- (BOOL)start;
- (BOOL)stop;

@end
