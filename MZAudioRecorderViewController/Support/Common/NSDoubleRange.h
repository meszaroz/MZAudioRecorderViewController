//
//  NSDoubleRange.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 03..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct _NSDoubleRange {
    CGFloat location;
    CGFloat length;
} NSDoubleRange;

NS_INLINE NSDoubleRange NSMakeDoubleRange(CGFloat loc, CGFloat len) {
    NSDoubleRange r;
    r.location = loc;
    r.length = len;
    return r;
}
