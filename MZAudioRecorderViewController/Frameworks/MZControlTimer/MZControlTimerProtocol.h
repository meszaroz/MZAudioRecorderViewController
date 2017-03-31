//
//  MZControlTimerProtocol.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 08..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZControlTimer;

@protocol MZControlTimerDelegate <NSObject>

@optional
- (BOOL)controlTimerDidStart:(MZControlTimer*)timer;
- (BOOL)controlTimerDidStop :(MZControlTimer*)timer;
- (BOOL)controlTimerDidFire :(MZControlTimer*)timer;

@end
