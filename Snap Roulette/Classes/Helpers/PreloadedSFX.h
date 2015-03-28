//
//  PreloadedSFX.h
//  ExperimentF
//
//  Created by Jason Fieldman on 11/12/10.
//  Copyright 2010 Jason Fieldman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PreloadedSFXType {
	PLSFX_SHUTTER,
	
	PLSFX_COUNT,
} PreloadedSFXType_t;

@interface PreloadedSFX : NSObject {

}

+ (void) initializePreloadedSFX;

+ (void) playSFX:(PreloadedSFXType_t)type;

+ (void) setVolume:(float)volume;

@end
