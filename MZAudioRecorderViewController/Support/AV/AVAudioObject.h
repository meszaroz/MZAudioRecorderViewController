//
//  AVAudioObject.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 10..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "AVAudioProtocol.h"

/* Recorder */
@interface AVAudioRecorder(Protocol) <AVAudioProtocol>
@end

/* Player */
@interface AVAudioPlayer(Protocol) <AVAudioProtocol>
@end
