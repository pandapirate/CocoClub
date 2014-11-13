//
//  MathSolver.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/13/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MathSolver : NSObject

@property BOOL returnToMain;
@property BOOL toNextLevel;
@property int retryLevel;

@property (strong, retain) AVAudioPlayer *player;

+ (MathSolver *) instance;
- (double) solve: (NSString*)equation;
- (NSString *) newEquationforLevel: (int) level;
- (NSString *) newEquationforLevel:(int)level andOperations: (NSMutableArray *) operations andType: (int) type;
- (NSString *) formatEquation: (NSString *) eq;
- (void) playSound;

@end
