//
//  FirstViewController.h
//  CPWhereIAmWithSqlite
//
//  Created by Student P_08 on 14/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CPDatabaseManager.h"


@interface FirstViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>{
    
    
    MKPointAnnotation *myAnnotation;
    CLLocationManager *myLocation;

}
@property (strong, nonatomic) IBOutlet UIButton *startDetectionButton;

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)startDetectingButton:(id)sender;

- (IBAction)segmentControl:(id)sender;
@end

