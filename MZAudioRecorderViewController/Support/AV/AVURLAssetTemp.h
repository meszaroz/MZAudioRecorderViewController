//
//  AVURLAssetTemp.h
//
//  Created by Mészáros Zoltán on 2016. 12. 19..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/* Will delete content on deallocation */
@interface AVURLAssetTemp : AVURLAsset
@end

@interface AVURLAsset(Copy)
@end
