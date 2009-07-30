//
//  QuakeInfoViewController.m
//  QuakeInfo
//
//  Created by Craig Schamp on 7/26/09.
//  Copyright Craig Schamp 2009. All rights reserved.
//

#import "QuakeInfoViewController.h"

@implementation QuakeInfoViewController

@synthesize mapView;

#if 0
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	USGSParser *parser = [USGSParser parser];
	parser.delegate = self;
	[parser parseForData];
	// This really should run later, after we have annotations on the map.
	// At this point in time, we don't yet know the user location.
	//[self zoomToCurrentLocation];
}
#endif

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) zoomToCurrentLocation {
//	if (self.mapView.userLocation.updating == NO) {
		CLLocationCoordinate2D usercoord = self.mapView.userLocation.location.coordinate;
		MKCoordinateRegion region;
		region.center.latitude = usercoord.latitude;
		region.center.longitude = usercoord.longitude;
		region.span.latitudeDelta = 4.0;	// 1 degree = approx 69 miles.
		region.span.longitudeDelta = 4.0;
		[self.mapView setRegion:region animated:YES];
//	}
}

#pragma mark USGSParser Delegates

- (void)addEarthquake:(Earthquake *)earthquake {
	EarthquakeAnnotation *annot = [[[EarthquakeAnnotation alloc] initWithEarthquake:earthquake] autorelease];
	[self.mapView addAnnotation:annot];
	NSLog([earthquake description]);
}

- (void)parserFinished {
	NSLog(@"Parser finished");
	// XXX There might be a better place for this.
	[self zoomToCurrentLocation];
}

#pragma mark MKMapView Delegates

#define	quakeAnnotationID @"quakeAnnotationID"

- (MKAnnotationView *)mapView:(MKMapView *)view viewForAnnotation:(id <MKAnnotation>)annotation {
	if (annotation == view.userLocation) {
		// XXX This can't remain here, or else we fetch and parse the data
		// XXX every time the user's current location comes into view.
		USGSParser *parser = [USGSParser parser];
		parser.delegate = self;
		[parser parseForData];
		return nil;
	}

	EarthquakeAnnotation *annot = (EarthquakeAnnotation *) annotation;
	MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:quakeAnnotationID];
	if (annotationView == nil) {
		// Create a new annotationView since we can't find one to reuse.
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annot reuseIdentifier:quakeAnnotationID] autorelease];
		// XXX should assert here that annotationView isn't nil
	}
	// Add custom information and properties to the annotation
	float magnitude = [annot.earthquake.magnitude floatValue];
	if (magnitude >= 5.0f) {
		[(MKPinAnnotationView *)annotationView setPinColor:MKPinAnnotationColorRed];
	} else if (magnitude >= 3.0f) {
		[(MKPinAnnotationView *)annotationView setPinColor:MKPinAnnotationColorPurple];
	} else /* if (magnitude >= 2.0f) */ {
		[(MKPinAnnotationView *)annotationView setPinColor:MKPinAnnotationColorGreen];
	}
	[(MKPinAnnotationView *)annotationView setAnimatesDrop:NO];
	// setCanShowCallout:YES enables display of the info box when the pin is selected
	[annotationView setCanShowCallout:YES];
	return annotationView;
}

@end
