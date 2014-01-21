//
//  DrunkHungryViewController.m
//  drunkh
//
//  Created by Serena Simkus on 9/28/13.
//  Copyright (c) 2013 Serena Simkus. All rights reserved.
//

#import "DrunkHungryViewController.h"
#import "Foursquare.h"
#import <MapKit/MapKit.h>
#import "JSONModelLib.h"

@interface DrunkHungryViewController ()
{
    Venues* _venue;
}
@end

@implementation DrunkHungryViewController
int i;
Foursquare *api;
CLLocationManager *locationManager;
@synthesize title, image;
@synthesize fslat;
@synthesize fslng;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    [self.navigationController setNavigationBarHidden:true];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        fslng = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        fslat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];

    NSString *fsURL = [NSString stringWithFormat:@"%@%@%@%@", @"http://api.foursquare.com/v2/venues/explore?client_id=3NL43YODEKB2KMTIWBYGMONIQANNRKCGXX11OCSFJ1A4OEXU&client_secret=LFGUETUP01IADEEWD15XAXYMR1Q1BWZQVNSS4VLA3ZA3PW05&selection=food&venuePhotos=1&price=1&openNow=1&ll=",fslat, @",", fslng];
    NSLog(@"fslat: %@",fslat);
    NSLog(@"fslng: %@",fslng);
    
    NSURL *url1 = [NSURL URLWithString:fsURL];
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url1];
    [req setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSData *retData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err)
    {
        NSLog(@"%@", err);
    }
    else
    {
        NSString *resp = [[NSString alloc]initWithData:retData encoding:NSUTF8StringEncoding];
        
        NSData *jsondata = [resp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *e = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&e];
        
        api = [[Foursquare alloc] initWithDictionary:json error:&e];
        
        NSURL *url = [NSURL URLWithString:[[[[[[[[[api.response.groups[0] valueForKey:@"items"] objectAtIndex: i] valueForKey:@"venue"] valueForKey:@"photos"] valueForKey:@"groups"] valueForKey:@"items"] valueForKey:@"url"] objectAtIndex: 0] objectAtIndex: 0]];

        NSData *data = [NSData dataWithContentsOfURL:url];
        image.image = [UIImage imageWithData:data];
        
        title.text = [[[[api.response.groups[0] valueForKey:@"items"] objectAtIndex: i] valueForKey:@"venue"] valueForKey:@"name"];
        
        _venue = [[[api.response.groups[0] valueForKey:@"items"] objectAtIndex: i] valueForKey:@"venue"];
        
        NSLog(@"%lu", (unsigned long)[[api.response.groups[0] valueForKey:@"items"] count]);
        
        i = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reject:(id)sender {
    i++;
    [self updateImageView];
}

- (IBAction)work:(id)sender {
    NSString *lat = [[_venue valueForKey:@"location"] valueForKey:@"lat"];
    NSString *lng = [[_venue valueForKey:@"location"] valueForKey:@"lng"];
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]) addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:place];
    mapItem.name = [_venue valueForKey:@"name"];
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (void)updateImageView {
    _venue = [[[api.response.groups[0] valueForKey:@"items"] objectAtIndex: i] valueForKey:@"venue"];

    @try {
        NSURL *url = [NSURL URLWithString:[[[[[[[[[api.response.groups[0] valueForKey:@"items"] objectAtIndex: i] valueForKey:@"venue"] valueForKey:@"photos"] valueForKey:@"groups"] valueForKey:@"items"] valueForKey:@"url"] objectAtIndex: 0] objectAtIndex: 0]];
    
        NSData *data = [NSData dataWithContentsOfURL:url];
        image.image = [UIImage imageWithData:data];
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        
        NSURL *url = [NSURL URLWithString:@"http://thecatapi.com/api/images/get?format=src&type=gif"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        image.image = [UIImage imageWithData:data];
    }
        
    title.text = [[[[api.response.groups[0] valueForKey:@"items"] objectAtIndex: i] valueForKey:@"venue"] valueForKey:@"name"];
}

- (IBAction)swiperight:(id)sender {
    i++;
    
    if ([[api.response.groups[0] valueForKey:@"items"] count] <= 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oh no!" message: @"There are no more places open currently" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
    } else if (i == [[api.response.groups[0] valueForKey:@"items"] count]) {
        i = 0;
    }
    
    [self updateImageView];
}

- (IBAction)swipeleft:(id)sender {
    if (i == 0) {
        i = [[api.response.groups[0] valueForKey:@"items"] count] - 1;
        NSLog(@"%d", i);
    } else {
        i--;
    }
    
    [self updateImageView];
}

@end
