//
//  UIView+Layout.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "UIView+Layout.h"
#import "NSArray+Dictionary.h"

@implementation UIView(Layout)

- (NSArray<NSLayoutConstraint*>*)autoDistributeSubviews:(NSArray<UIView *> *)subviews onAxis:(UIViewDistributeAxis)axis {
    NSArray<NSLayoutConstraint*> *out = nil;
    if (subviews && subviews.count > 0) {
        /* create spacers */
        NSMutableArray *spacers = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < subviews.count+1; ++i) {
            UIView *spacer = [UIView new]; spacer.translatesAutoresizingMaskIntoConstraints = NO; [self addSubview:spacer];
            [spacers addObject:spacer];
        }
        
        /* add member subviews */
        for (UIView *item in subviews) {
            NSAssert(item.superview == self, @"Item must be a subview of view!");
        }
        
        /* create dictionary */
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        [views addEntriesFromDictionary:[spacers  dictionaryWithKeyPrefix:@"spacer" ]];
        [views addEntriesFromDictionary:[subviews dictionaryWithKeyPrefix:@"subview"]];
        
        /* options */
        NSString             *axisPrefix = axis == UIViewDistributeAxisHorizontal ? @"H:|"                        : @"V:"                        ;
        NSLayoutFormatOptions options    = axis == UIViewDistributeAxisHorizontal ? NSLayoutFormatAlignAllCenterY : NSLayoutFormatAlignAllCenterX;
        
        /* create command */
        NSMutableString *command = [NSMutableString stringWithString:axisPrefix];
        NSUInteger i;
        for (i = 0; i < subviews.count; ++i)
            [command appendFormat:@"[spacer_%lu%@][subview_%lu]",(unsigned long)i,i > 0 ? @"(==spacer_0)" : @"",(unsigned long)i];
        [command appendFormat:@"[spacer_%lu(==spacer_0)]|",(unsigned long)i];
        
        
        /* set constraints */
        out = [NSLayoutConstraint constraintsWithVisualFormat:command
                                                      options:options
                                                      metrics:nil
                                                        views:views];
        [self addConstraints:out];
    }
    return out;
}

@end
