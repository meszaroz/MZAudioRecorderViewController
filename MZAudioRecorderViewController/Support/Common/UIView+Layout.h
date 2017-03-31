//
//  UIView+Layout.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewDistributeAxis) {
    UIViewDistributeAxisVertical,
    UIViewDistributeAxisHorizontal
};

@interface UIView(Layout)

- (NSArray<NSLayoutConstraint*>*)autoDistributeSubviews:(NSArray<UIView*>*)subviews onAxis:(UIViewDistributeAxis)axis;

@end

