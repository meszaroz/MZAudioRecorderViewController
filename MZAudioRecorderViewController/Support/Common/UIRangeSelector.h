//
//  UIRangeSelector.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 03..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDoubleRange.h"

extern const UIEdgeInsets  kSelectorViewInsets;
extern const NSDoubleRange kDefaultRelativeRange;

@interface UIRangeSelector : UIControl

@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;

@property(nonatomic) NSDoubleRange value;

@property(nonatomic) BOOL selectionEnabled;

- (void)setSelectionEnabled:(BOOL)selectionEnabled animated:(BOOL)animated;

@end

@interface UIRangeSelector(Relative)

@property (nonatomic) NSDoubleRange relativeValue;

@end

@interface UIRangeSelector(Reset)

- (void)reset;

@end

