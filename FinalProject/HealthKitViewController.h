//
//  HealthKitViewController.h
//  FinalProject
//
//  Created by Brent Dady on 6/18/15.
//  Copyright (c) 2015 Brent Dady. All rights reserved.
//

@import UIKit;
@import HealthKit;

@interface HealthKitViewController : UIViewController

@property (nonatomic) HKHealthStore *healthStore;

@end