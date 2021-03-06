//
//  Earthquake.m
//  QuakeInfo
//
//  Created by Craig Schamp on 7/26/09.
//  Copyright 2009 Craig Schamp. All rights reserved.
//

#import "Earthquake.h"

@implementation Earthquake

@synthesize detailsURL;
@synthesize magnitude;
@synthesize place;
@synthesize lastUpdate;
@synthesize location;

- (void)dealloc {
	self.detailsURL = nil;
	self.magnitude = nil;
	self.place = nil;
	self.lastUpdate = nil;
	self.location = nil;
    [super dealloc];
}


@end
