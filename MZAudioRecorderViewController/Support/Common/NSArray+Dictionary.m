//
//  NSArray+Dictionary.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "NSArray+Dictionary.h"

@implementation NSArray(Dictionary)

- (NSDictionary*)dictionary {
    return [self dictionaryWithKeyPrefix:nil];
}

- (NSDictionary*)dictionaryWithKeyPrefix:(NSString*)prefix {
    NSMutableDictionary *out = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < self.count; ++i)
        [out setValue:[self objectAtIndex:i] forKey:[NSString stringWithFormat:@"%@_%lu",
                                                     (prefix ? prefix : @""),
                                                     (unsigned long)i]];
    return out;
}


@end
