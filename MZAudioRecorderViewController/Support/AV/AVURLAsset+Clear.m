//
//  AVURLAsset+Clear.m
//
//  Created by Mészáros Zoltán on 2016. 12. 18..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "AVURLAsset+Clear.h"

@implementation AVURLAsset(Clear)

- (BOOL)clearContent {
    return self.URL
        && [[NSFileManager defaultManager] isDeletableFileAtPath:self.URL.path]
        && [[NSFileManager defaultManager] removeItemAtPath:self.URL.path error:nil];
}

@end
