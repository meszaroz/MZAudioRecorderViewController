//
//  MZAudioRecorderHandler.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 07..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "MZAudioRecorderHandler.h"
#import "NSDictionary+AVAudio.h"
#import "AVAsset+Range.h"
#import "AVAudioObject.h"
#import "AVURLAssetTemp.h"

NSString * _Nonnull kPlayerRelativeStartTime = @"PlayerRelativeStartTime";
NSString * _Nonnull kPlayerRelativeDuration  = @"PlayerRelativeDuration" ;

@interface MZAudioRecorderHandler () <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    NSDictionary<NSString *, id> *_settings;
    NSString *_uniqueFileNameIdentifier;
    NSUInteger _fileNameCounter;
    
    AVAudioRecorder *_recorder;
    
    id<AVAudioProtocol> _activeObject;
}
@end

@implementation MZAudioRecorderHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self setupFileIdentifier];
    [self setupAVAudio];
}

#pragma mark - Setup
- (void)setupFileIdentifier {
    _uniqueFileNameIdentifier = [NSUUID UUID].UUIDString;
    _fileNameCounter = 0;
}

- (void)setupAVAudio {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    /* setup audio session */
    [session setCategory            :AVAudioSessionCategoryPlayAndRecord error:nil];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker   error:nil];
    
    /* initiate and prepare the recorder */
    _recorder = [self createRecorder];
}

#pragma mark - Factory
- (NSURL*)createUniqueFileURL {
    NSString *ext = self.audioRecordSettings.AVFormatExtension;
    return [NSURL fileURLWithPathComponents:
            @[NSTemporaryDirectory(),[[NSString stringWithFormat:@"%@-%lu",_uniqueFileNameIdentifier,(unsigned long)_fileNameCounter++] /* increase counter */
                                      stringByAppendingPathExtension:ext]]];
}

- (AVAudioRecorder*)createRecorder {
    NSDictionary<NSString *,id> *settings = self.audioRecordSettings;
    
    AVAudioRecorder *out = [[AVAudioRecorder alloc] initWithURL:[self createUniqueFileURL]
                                                       settings:settings
                                                          error:nil];
    out.delegate = self;
    out.meteringEnabled = YES;
    [out prepareToRecord];
    
    return out;
}

- (AVAudioPlayer*)createPlayerWithRelativeStart:(CGFloat)start {
    AVAudioPlayer *out = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
    out.delegate = self;
    out.meteringEnabled = YES;
    
    /* start time */
    out.currentTime = out.duration * MIN(MAX(start,0.0),1.0);
    
    return out;
}

# pragma mark - Audio Record/Playback
- (void)setAudioRecordSettings:(__kindof NSDictionary<NSString *,id> *)audioRecordSettings {
    _settings = [audioRecordSettings copy];
}

- (__kindof NSDictionary<NSString *,id> *)audioRecordSettings {
    [self validateRecordSettings];
    return _settings;
}

- (void)validateRecordSettings {
    NSMutableDictionary *settings = _settings ?
    [_settings mutableCopy] :
    [NSMutableDictionary dictionary];
    
    if ([settings setAVFormatID        :kAudioFormatMPEG4AAC]
      | [settings setAVSampleRate      :44100.0             ]
      | [settings setAVNumberOfChannels:1                   ]) {
        _settings = settings;
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    /* do through polling */
}

#pragma mark - AVAudioPlayerDelegate
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    /* do through polling */
}

#pragma mark - MZAudioRecorderControllerHandler
- (AVURLAsset* _Nullable)audioRecorderControllerRecordedAsset:(MZAudioRecorderController* _Nullable)controller {
    return _recorder ?
        [AVURLAsset URLAssetWithURL:_recorder.url options:nil] :
        nil;
}

- (id<AVAudioProtocol> _Nullable)audioRecorderControllerActiveAudioObject:(MZAudioRecorderController* _Nullable)controller {
    return _activeObject;
}

- (id<AVAudioProtocol> _Nullable)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
                             activateAudioObjectWithType:(MZAudioObjectType)type
                                                 andInfo:(NSDictionary<NSString*,id>* _Nullable)info {
    [self audioRecorderControllerDeactivateActiveAudioObject:controller];
    switch (type) {
        case MZAudioObjectTypeRecorder: _activeObject = [self activateRecorderWithInfo:info]; break;
        case MZAudioObjectTypePlayer  : _activeObject = [self activatePlayerWithInfo  :info]; break;
        default:                                                                              break;
    }
    if (_activeObject) {
        [_activeObject setActive:YES];
    }
    return _activeObject;
}

- (BOOL)audioRecorderControllerDeactivateActiveAudioObject:(MZAudioRecorderController* _Nullable)controller {
    BOOL out = _activeObject != nil;
    if (out) {
        [_activeObject stop];
        [_activeObject setActive:NO];
        _activeObject = nil;
    }
    return out;
}

- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
 recordedAssetWithRelativeRange:(NSDoubleRange)range
                  andCompletion:(AssetWithRangeCompletion _Nullable)completion
{
    /* ToDo: check if asset destroyed */
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:[self audioRecorderControllerRecordedAsset:controller]
                                                                           presetName:AVAssetExportPresetPassthrough];
    exportSession.outputURL = [self createUniqueFileURL];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = [exportSession.asset timeRangeFromRelativeRange:range];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^ {
        switch (exportSession.status) {
            case AVAssetExportSessionStatusCompleted: {
                if (completion) {
                    completion([AVURLAsset URLAssetWithURL:exportSession.outputURL options:nil]);
                }
            }
            case AVAssetExportSessionStatusUnknown  : NSLog(@"Unknown"  );                                   break;
            case AVAssetExportSessionStatusWaiting  : NSLog(@"Waiting"  );                                   break;
            case AVAssetExportSessionStatusExporting: NSLog(@"Exporting");                                   break;
            case AVAssetExportSessionStatusFailed   : NSLog(@"%@",exportSession.error.localizedDescription); break;
            case AVAssetExportSessionStatusCancelled: NSLog(@"Cancelled");                                   break;
            default: break;
        }
    }];
}

#pragma mark - support
- (id<AVAudioProtocol>)activateRecorderWithInfo:(NSDictionary<NSString*,id>* _Nullable)info {
    return _recorder;
}

- (id<AVAudioProtocol>)activatePlayerWithInfo:(NSDictionary<NSString*,id>* _Nullable)info {
    NSNumber *start = info ? info[kPlayerRelativeStartTime] : nil;
    return [self createPlayerWithRelativeStart:start ? start.doubleValue : 1.0];
}

- (void)dealloc {
    if (_recorder) {
        [_recorder deleteRecording];
    }
}

@end
