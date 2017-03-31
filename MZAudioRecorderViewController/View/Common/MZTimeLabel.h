//
//  MZTimeLabel.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 21..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSAttributedString* (^ElapsedTimeFormatter)(NSDictionary *);

@interface MZTimeLabel : UILabel

@property (        nonatomic) NSTimeInterval elapsedTime;
@property (strong, nonatomic) ElapsedTimeFormatter formatter;

@end

@interface MZTimeLabel(Animate)

- (void)reset;
- (void)startAnimation:(CABasicAnimation*)animation;
- (void)stopAnimation;

@end
