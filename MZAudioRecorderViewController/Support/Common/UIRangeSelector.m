//
//  UIRangeSelector.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 03..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <PureLayout.h>
#import "UIRangeSelector.h"

const UIEdgeInsets  kSelectorViewInsets   = { 14.0, 10.0, 10.0, 10.0 };
const NSDoubleRange kDefaultRelativeRange = { 0.0 , 1.0 };

@interface UIRangeSelector() {
    UIView *_selectorView;
    UIView *_selector1;
    UIView *_selector2;
    UIView *_selectedSelector;
    NSDoubleRange _relativeValue;
}

@property (nonatomic, readonly) CGFloat effectiveWidth;

@end

@implementation UIRangeSelector

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setMinimumValue:(CGFloat)minimumValue {
    if (_minimumValue != minimumValue) {
        _minimumValue = minimumValue;
        _maximumValue = MAX(_minimumValue, _maximumValue);
    }
}

- (void)setMaximumValue:(CGFloat)maximumValue {
    if (_maximumValue != maximumValue) {
        _maximumValue = maximumValue;
        _minimumValue = MIN(_minimumValue, _maximumValue);
    }
}

- (void)setValue:(NSDoubleRange)value {
    self.relativeValue = [self convertToRelativeValue:value];
}

- (NSDoubleRange)value {
    return [self convertToAbsoluteValue:_relativeValue];
}

- (void)setSelectionEnabled:(BOOL)selectionEnabled {
    [self setSelectionEnabled:selectionEnabled animated:NO];
}

- (void)setSelectionEnabled:(BOOL)selectionEnabled animated:(BOOL)animated {
    _selectionEnabled = selectionEnabled;
    void (^block)(void) = ^{
        _selector1.alpha = _selectionEnabled ? 1.0 : 0.0;
        _selector2.alpha = _selectionEnabled ? 1.0 : 0.0;
    };
    if (animated) { [UIView animateWithDuration:0.2 animations:block]; }
    else          { block();                                           }
}

- (void)setRelativeValue:(NSDoubleRange)relativeValue {
    _relativeValue = [self validatedRelativeValue:relativeValue];
    [self setValuePrivate];
}

- (NSDoubleRange)relativeValue {
    return _relativeValue;
}

- (CGFloat)effectiveWidth {
    return self.frame.size.width-kSelectorViewInsets.left-kSelectorViewInsets.right;
}

- (void)reset {
    self.relativeValue = kDefaultRelativeRange;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayout];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _selectedSelector = nil;
    if (_selectionEnabled) {
        for (UIView *view in @[_selector1,_selector2]) {
            CGPoint originTouch  = [[touches anyObject] locationInView:view];
            if (ABS(originTouch.x) < 30.0) {
                _selectedSelector = view;
                break;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_selectedSelector) {
        CGPoint pointInSelf = [[touches anyObject] locationInView:self];
        
        CGFloat locationThis  = MIN(MAX(pointInSelf.x, kSelectorViewInsets.left), self.frame.size.width-kSelectorViewInsets.right);
        CGFloat locationOther = _selectedSelector == _selector1 ? _selector2.center.x : _selector1.center.x;
        
        self.relativeValue = NSMakeDoubleRange([self.class convertToRelativeValue:MIN(locationThis,locationOther)
                                                                              min:kSelectorViewInsets.left
                                                                              max:kSelectorViewInsets.left+self.effectiveWidth],
                                               [self.class convertToRelativeValue:ABS(locationThis-locationOther)
                                                                              min:0.0
                                                                              max:self.effectiveWidth]);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _selectedSelector = nil;
}

#pragma mark - support
- (void)initialize {
    [self initializeValues];
    [self initializeViews ];
}

- (void)initializeValues {
    _selectionEnabled = YES;
    _minimumValue = kDefaultRelativeRange.location;
    _maximumValue = kDefaultRelativeRange.location+kDefaultRelativeRange.length;
    _relativeValue = kDefaultRelativeRange;
}

- (void)initializeViews {
    _selectorView = [UIView new];
    [self addSubview:_selectorView];
    [_selectorView autoPinEdgeToSuperviewEdge:ALEdgeTop    withInset:kSelectorViewInsets.top   ];
    [_selectorView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kSelectorViewInsets.bottom];
    
    _selectorView.layer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1].CGColor;
    _selectorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _selectorView.layer.borderWidth = 1.0;
    _selectorView.layer.cornerRadius = 5.0;
    _selectorView.clipsToBounds = YES;
    
    _selector1 = [self createSelector];
    _selector2 = [self createSelector];
}

- (UIView*)createSelector {
    const CGFloat size = kSelectorViewInsets.top;
    
    UIView *out = [UIView new];
    [self addSubview:out];
    [out autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self withOffset:kSelectorViewInsets.bottom];
    [out autoSetDimension:ALDimensionHeight toSize:size];
    [out autoSetDimension:ALDimensionWidth  toSize:size];
    
    out.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    out.layer.cornerRadius = size/2;
    out.clipsToBounds = YES;
    
    return out;
}

- (void)updateLayout {
    NSDoubleRange relativeValue = self.relativeValue;
    CGFloat effectiveWidth = self.effectiveWidth;

    [self updateLayoutWithRange:NSMakeDoubleRange(kSelectorViewInsets.left+effectiveWidth*relativeValue.location,
                                                  effectiveWidth*relativeValue.length)];
}

- (void)updateLayoutWithRange:(NSDoubleRange)range {
    _selectorView.frame = CGRectMake(range.location, _selectorView.frame.origin.y, range.length, _selectorView.frame.size.height);
    _selector1.center = CGPointMake(range.location,              _selector1.center.y);
    _selector2.center = CGPointMake(range.location+range.length, _selector2.center.y);
}

- (void)setValuePrivate {
    [self updateLayout];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (NSDoubleRange)validatedRelativeValue:(NSDoubleRange)value {
    CGFloat location = MAX(value.location, kDefaultRelativeRange.location);
    CGFloat length   = MIN(value.length  , kDefaultRelativeRange.length-location);
    return NSMakeDoubleRange(location,length);
}

- (NSDoubleRange)convertToRelativeValue:(NSDoubleRange)value {
    CGFloat location = [self.class convertToRelativeValue:value.location              min:_minimumValue max:_maximumValue];
    CGFloat length   = [self.class convertToRelativeValue:value.location+value.length min:_minimumValue max:_maximumValue]-location;
    return NSMakeDoubleRange(location, length);
}

- (NSDoubleRange)convertToAbsoluteValue:(NSDoubleRange)value {
    CGFloat location = [self.class convertToAbsoluteValue:value.location              min:_minimumValue max:_maximumValue];
    CGFloat length   = [self.class convertToAbsoluteValue:value.location+value.length min:_minimumValue max:_maximumValue]-location;
    return NSMakeDoubleRange(location, length);
}

+ (CGFloat)convertToRelativeValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max {
    return (value-min)/(max-min);
}

+ (CGFloat)convertToAbsoluteValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max {
    return value*(max-min)+min;
}

@end
