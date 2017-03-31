//
//  NSDictionary+AVFormat.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSDictionary+AVFormat.h"

@implementation NSDictionary(AVFormat)

+ (instancetype)AVFormatDictionary {
    return @{ @(kAudioFormatLinearPCM           ) : @"lpcm",
              @(kAudioFormatAC3                 ) : @"ac-3",
              @(kAudioFormat60958AC3            ) : @"cac3",
              @(kAudioFormatAppleIMA4           ) : @"ima4",
              @(kAudioFormatMPEG4AAC            ) : @"m4a",
              @(kAudioFormatMPEG4CELP           ) : @"celp",
              @(kAudioFormatMPEG4HVXC           ) : @"hvxc",
              @(kAudioFormatMPEG4TwinVQ         ) : @"twvq",
              @(kAudioFormatMACE3               ) : @"MAC3",
              @(kAudioFormatMACE6               ) : @"MAC6",
              @(kAudioFormatULaw                ) : @"ulaw",
              @(kAudioFormatALaw                ) : @"alaw",
              @(kAudioFormatQDesign             ) : @"QDMC",
              @(kAudioFormatQDesign2            ) : @"QDM2",
              @(kAudioFormatQUALCOMM            ) : @"Qclp",
              @(kAudioFormatMPEGLayer1          ) : @"mp1",
              @(kAudioFormatMPEGLayer2          ) : @"mp2",
              @(kAudioFormatMPEGLayer3          ) : @"mp3",
              @(kAudioFormatTimeCode            ) : @"time",
              @(kAudioFormatMIDIStream          ) : @"midi",
              @(kAudioFormatParameterValueStream) : @"apvs",
              @(kAudioFormatAppleLossless       ) : @"alac",
              @(kAudioFormatMPEG4AAC_HE         ) : @"aach",
              @(kAudioFormatMPEG4AAC_LD         ) : @"aacl",
              @(kAudioFormatMPEG4AAC_ELD        ) : @"aace",
              @(kAudioFormatMPEG4AAC_ELD_SBR    ) : @"aacf",
              @(kAudioFormatMPEG4AAC_ELD_V2     ) : @"aacg",
              @(kAudioFormatMPEG4AAC_HE_V2      ) : @"aacp",
              @(kAudioFormatMPEG4AAC_Spatial    ) : @"aacs",
              @(kAudioFormatAMR                 ) : @"samr",
              @(kAudioFormatAMR_WB              ) : @"sawb",
              @(kAudioFormatAudible             ) : @"AUDB",
              @(kAudioFormatiLBC                ) : @"ilbc",
              @(kAudioFormatDVIIntelIMA         ) : @"dii",
              @(kAudioFormatMicrosoftGSM        ) : @"mgsm",
              @(kAudioFormatAES3                ) : @"aes3",
              @(kAudioFormatEnhancedAC3         ) : @"ec-3"};
}

@end
