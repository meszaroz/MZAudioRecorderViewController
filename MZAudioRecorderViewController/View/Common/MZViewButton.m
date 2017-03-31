//
//  MZViewButton.m
//
//  Created by Mészáros Zoltán on 20/12/15.
//  Copyright © 2015 XL Solutions. All rights reserved.
//

#import "MZViewButton.h"
#import <PureLayout.h>

@interface MZViewButton()
- (void)setupLabel;
@end

@implementation MZViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLabel];
        self.filled = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.filled = self.filled;
    [super willMoveToSuperview:newSuperview];
}

- (void)setupLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_titleLabel];
    [_titleLabel autoCenterInSuperview];
    [self autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeWidth ofView:self];
    mSizeConstraint = [self autoSetDimension:ALDimensionHeight toSize:0.0];    
    [self addConstraint:mSizeConstraint];
    
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.5;
    self.cornerRadius = 15.0;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    mSizeConstraint.constant = cornerRadius*2;
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setEnabled:(BOOL)enabled {
    super.enabled = enabled;
    self.alpha = enabled ? 1.0 : 0.5;
}

- (void)setFilled:(BOOL)filled {
    _filled = filled;
    self.backgroundColor = _filled ?
        _color :
        [UIColor clearColor];
    self.titleLabel.textColor = _filled ?
        (self.superview ?
            [self.superview backgroundColor] :
            [UIColor blackColor]) :
        _color;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.layer.borderColor = _color.CGColor;
    self.filled = self.filled;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    self.alpha = 0.5;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0;
    [super touchesCancelled:touches withEvent:event];
}
@end
