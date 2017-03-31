//
//  NSArray+Dictionary.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray(Dictionary)

- (NSDictionary*)dictionary;
- (NSDictionary*)dictionaryWithKeyPrefix:(NSString*)prefix;

@end
