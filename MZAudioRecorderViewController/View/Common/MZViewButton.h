//
//  MZViewButton.h
//
//  Created by Mészáros Zoltán on 20/12/15.
//  Copyright © 2015 XL Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZViewButton : UIControl {
    NSLayoutConstraint *mSizeConstraint;
}
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, getter=isFilled) BOOL filled;
@end
