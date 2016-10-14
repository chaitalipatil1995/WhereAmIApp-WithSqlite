//
//  FirstViewController.m
//  CPWhereIAmWithSqlite
//
//  Created by Student P_08 on 14/10/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   

    self.startDetectionButton.layer.borderWidth = 2;
    
    self.startDetectionButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    self.startDetectionButton.layer.cornerRadius = 35/3;
    
    [self startLocating];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    
    longPress.minimumPressDuration = 1;
    
    [self.myMapView addGestureRecognizer:longPress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//method for handling Long press gesture recognizer

-(void)handleLongPress:(UILongPressGestureRecognizer*)gesture{
    
    CLLocationCoordinate2D pressedCoordinate;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint pressedLocation = [gesture locationInView:gesture.view];
        
        pressedCoordinate = [self.myMapView convertPoint:pressedLocation toCoordinateFromView:gesture.view];
        
        myAnnotation = [[MKPointAnnotation alloc]init];
        
        myAnnotation.coordinate = pressedCoordinate;
        
        
        MKPinAnnotationView *annotationView=[[MKPinAnnotationView alloc]initWithAnnotation:myAnnotation reuseIdentifier:@"pin"];
        annotationView.pinTintColor = [UIColor blueColor];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:pressedCoordinate.latitude longitude:pressedCoordinate.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"error:%@",error.localizedDescription);
                myAnnotation.title = @"Unknown Place";
                [self.myMapView addAnnotation:myAnnotation];
            }
            else{
                
                
                if (placemarks.count > 0) {
                    
                    CLPlacemark *myPlacemark = placemarks.lastObject;
                    
                    NSString *title = myPlacemark.subLocality;
                    
                    NSString *subTitle = myPlacemark.locality;
                    
                    myAnnotation.title = title;
                    myAnnotation.subtitle = subTitle;
                    
                    self.addressLabel.text = [NSString stringWithFormat:@"%@,%@",myPlacemark.subLocality,myPlacemark.locality];
                    
                    NSLog(@"%@",myPlacemark.subLocality);
                    
                    
                    [self.myMapView addAnnotation:myAnnotation];
                    
                }
                else {
                    
                    myAnnotation.title = @"Unknown Place";
                    [self.myMapView addAnnotation:myAnnotation];
                
                }
            
            }
            
        }];
    
    }
    else if(gesture.state == UIGestureRecognizerStateEnded){
        
    }
    [self saveTask];
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    [self.myMapView addAnnotation:myAnnotation];
    
    MKPinAnnotationView *annotationView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annotationView.pinTintColor = [UIColor blueColor];
    annotationView.canShowCallout = YES;
    return annotationView;
    
}



-(void)startLocating{
    myLocation = [[CLLocationManager alloc]init];
    
    myLocation.delegate = self;
    
    [myLocation setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [myLocation requestWhenInUseAuthorization];
    
    [myLocation startUpdatingLocation];

}

//method for finding coordinates

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"Latitude:%f",currentLocation.coordinate.latitude);
    NSLog(@"Longitude:%f",currentLocation.coordinate.longitude);
    NSLog(@"Altitude:%f",currentLocation.altitude);
    NSLog(@"Speed:%f",currentLocation.speed);

    MKCoordinateSpan mySpan = MKCoordinateSpanMake(0.001, 0.001);
    
    MKCoordinateRegion myRegion = MKCoordinateRegionMake(currentLocation.coordinate, mySpan);
    
    [self.myMapView setRegion:myRegion animated:YES];
    
    if (currentLocation != nil) {
        [myLocation stopUpdatingLocation];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.localizedDescription);
    
}


- (IBAction)startDetectingButton:(id)sender {
    
    [self saveTask];
    
    [self startLocating];

}

//method for changing map type

- (IBAction)segmentControl:(id)sender {
    
    UISegmentedControl *selectSegment = sender;
    
    
    if (selectSegment.selectedSegmentIndex == 0) {
        [self.myMapView setMapType:MKMapTypeStandard];
        
    }
    else if (selectSegment.selectedSegmentIndex == 1) {
        [self.myMapView setMapType:MKMapTypeSatellite];
        
    }
    else if (selectSegment.selectedSegmentIndex == 2) {
        [self.myMapView setMapType:MKMapTypeHybrid];
        
    }
    
}

//method for saving the address from addressLabel to sqlite database table
-(void)saveTask {
    
    NSString *task =self.addressLabel.text;
    
    if (task.length > 0) {
        
        NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO TASK_TABLE(TASK_ID,TASK) VALUES('%@','%@')",task.uppercaseString,task];
        
        NSLog(@"%@",insertQuery);
        
        int result = [[CPDatabaseManager sharedManager]executeQuery:insertQuery];
        
        if (result == 1) {
            NSLog(@"Successfully inserted Task");
        }
        else {
            NSLog(@"Unable to insert task in SQLite Database");
        }
        
        NSLog(@"Task Saved : %@",task);
        
       // self.taskField.text = @"";
    }
    else {
        NSLog(@"Enter Task First to Save.");
    }
    
    
    
}

@end
