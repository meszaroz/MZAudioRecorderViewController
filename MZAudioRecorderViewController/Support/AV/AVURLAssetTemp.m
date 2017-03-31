//
//  AVURLAssetTemp.m
//
//  Created by Mészáros Zoltán on 2016. 12. 19..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "AVURLAssetTemp.h"
#import "AVURLAsset+Clear.h"

@implementation AVURLAssetTemp

- (void)dealloc {
    [self clearContent];
}

@end

@implementation AVURLAsset(Copy)

- (id)copy {
    return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
    AVURLAssetTemp *other = nil;
    if (self.URL && self.URL.path) {
        NSString *fileName = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:[self.URL.path pathExtension]];
        NSURL *url = [NSURL fileURLWithPathComponents:@[NSTemporaryDirectory(),fileName]];
        
        other = [[AVURLAssetTemp alloc] initWithURL:[self copyContentToURL:url] ? url : [NSURL URLWithString:@""]
                                            options:nil];
    }
    return other;
}

- (BOOL)copyContentToURL:(NSURL*)destination {
    return self.URL && destination
        && [[NSFileManager defaultManager] isReadableFileAtPath:self.URL.path]
        && [[NSFileManager defaultManager] copyItemAtURL:self.URL toURL:destination error:nil];
}

@end
