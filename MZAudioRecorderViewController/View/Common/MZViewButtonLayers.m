//
//  MZViewButtonLayers.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 11..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <PureLayout.h>
#import "MZViewButtonLayers.h"
#import "MZCircularMeterLayer.h"

/* typedefs */
typedef NSMutableArray<MZCircularMeterLayer*> LayerMutableArray;

/* Layer Constants */
static const NSUInteger kMaximalDisplayableLayerCount = 4;

@interface MZViewButtonLayers() {
    LayerMutableArray *_layers;
}
@end

@implementation MZViewButtonLayers

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self clearLayers];
    [super setCornerRadius:cornerRadius];
}

- (void)setColor:(UIColor *)color {
    [self clearLayers];
    [super setColor:color];
}

- (LayerArray*)layers {
    if (!_layers) {
        _layers = [self createStrokeLayersWithChannelCount:kMaximalDisplayableLayerCount];
    }
    return _layers;
}

- (LayerMutableArray*)createStrokeLayersWithChannelCount:(NSUInteger)count {
    LayerMutableArray *out = nil;
    
    if (self.superview) {
        out = [NSMutableArray array];
        
        int strokeWidth = self.layer.borderWidth;
        CGFloat radius = self.cornerRadius;
        
        for (NSUInteger i = 0; i < count; ++i) {
            radius += 2*strokeWidth;
            
            MZCircularMeterLayer *circle = [[MZCircularMeterLayer alloc] initWithCenter:self.center
                                                                                 radius:radius
                                                                            strokeColor:self.color
                                                                           andLineWidth:strokeWidth];
            [self.superview.layer addSublayer:circle];
            
            [out addObject:circle];
        }
    }
    
    return out;
}

@end

@implementation MZViewButtonLayers(Clear)

- (void)clearLayers {
    for (CALayer *layer in self.layers) {
        [layer removeFromSuperlayer];
    }
    _layers = nil;
}

@end

@implementation MZViewButtonLayers(Support)

- (void)animateStrokeAtIndex:(NSUInteger)index toAngle:(CGFloat)endAngle withDuration:(CFTimeInterval)duration {
    LayerArray *layers = self.layers;
    if (layers && index < layers.count) {
        [layers[index] animateStrokeToAngle:endAngle
                               withDuration:duration];
    }
}

@end
