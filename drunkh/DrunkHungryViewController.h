//
//  DrunkHungryViewController.h
//  drunkh
//
//  Created by Serena Simkus on 9/28/13.
//  Copyright (c) 2013 Serena Simkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DrunkHungryViewController : UIViewController<CLLocationManagerDelegate> {
    NSString *fslat;
    NSString *fslng;
}
@property (weak, nonatomic) IBOutlet UILabel *title;
- (IBAction)reject:(id)sender;
- (IBAction)work:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, copy) NSString *fslat;
@property (nonatomic, copy) NSString *fslng;

@end
