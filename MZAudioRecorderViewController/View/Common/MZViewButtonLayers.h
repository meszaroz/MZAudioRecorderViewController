//
//  MZViewButtonLayers.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 11..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "MZViewButton.h"

@class MZCircularMeterLayer;

/* typedefs */
typedef NSArray<MZCircularMeterLayer*> LayerArray;

@interface MZViewButtonLayers : MZViewButton

@property(strong, nonatomic, readonly) LayerArray *layers;

@end

@interface MZViewButtonLayers(Clear)

- (void)clearLayers;

@end

@interface MZViewButtonLayers(Support)

- (void)animateStrokeAtIndex:(NSUInteger)index toAngle:(CGFloat)endAngle withDuration:(CFTimeInterval)duration;

@end
