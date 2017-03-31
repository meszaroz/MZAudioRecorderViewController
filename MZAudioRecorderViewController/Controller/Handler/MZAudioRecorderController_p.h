//
//  MZAudioRecorderHandler_p.h
//
//  Created by Mészáros Zoltán on 2016. 12. 18..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "MZAudioRecorderController.h"
#import "MZAudioRecorderHandler.h"

@protocol AVAudioProtocol;

@interface MZAudioRecorderController(Private)

@property(nullable, strong, nonatomic, readonly) id<AVAudioProtocol> activeAudioObject;
@property(nullable, strong, nonatomic, readonly) AVURLAsset *recordedAsset;

- (void)recordedAssetWithRelativeRange:(NSDoubleRange)range
                         andCompletion:(AssetWithRangeCompletion _Nullable)completion;

@end
