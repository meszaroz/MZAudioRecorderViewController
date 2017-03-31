//
//  AVURLAsset+Data.m
//
//  Created by Mészáros Zoltán on 2016. 12. 19..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "AVURLAsset+Data.h"

@implementation AVURLAsset(Data)

- (NSData*)data {
    NSURL *url = self.URL;
    return url && [[NSFileManager defaultManager] isReadableFileAtPath:url.path] ?
        [NSData dataWithContentsOfFile:url.path] :
        nil;
}

@end
