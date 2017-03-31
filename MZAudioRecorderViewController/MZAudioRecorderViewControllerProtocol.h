//
//  MZAudioRecorderViewControllerProtocol.h
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZAudioRecorderViewController;
@protocol MZAudioRecorderViewControllerDelegate <NSObject>
@optional
- (void)audioRecorderViewController:(MZAudioRecorderViewController*)editor willFinishEditingAsset:(AVURLAsset*)asset;
- (void)audioRecorderViewController:(MZAudioRecorderViewController*)editor didFinishEditingAsset:(AVURLAsset*)asset;
- (void)audioRecorderViewControllerWillCancel:(MZAudioRecorderViewController*)editor;
- (void)audioRecorderViewControllerDidCancel:(MZAudioRecorderViewController*)editor;
@end
