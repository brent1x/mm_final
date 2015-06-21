//
//  ViewController.m
//  FinalProject
//
//  Created by Brent Dady on 6/12/15.
//  Copyright (c) 2015 Brent Dady. All rights reserved.
//

#import "RootViewController.h"
#import "ConsumptionEvent.h"
#import "CustomWaterLevelView.h"
#import "ContainerButton.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addWaterButton;
@property (weak, nonatomic) IBOutlet ContainerButton *menuButton1;
@property (weak, nonatomic) IBOutlet ContainerButton *menuButton2;
@property (weak, nonatomic) IBOutlet ContainerButton *menuButton3;
@property NSMutableArray *menuButtons;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property NSArray *consumptionEvents;
@property int totalVolumeSummed;

@property (weak, nonatomic) IBOutlet UIView *waterLevel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waterLevelHeightConstraint;

@property float waterLevelHeight;
@property float waterLevelY;
@property UIDynamicAnimator *animator;
@property BOOL isFannedOut;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    [self.addWaterButton addTarget:self action:@selector(toggleFan) forControlEvents:UIControlEventTouchUpInside];

//    self.menuButtons = [NSMutableArray arrayWithObjects:self.menuButton1, self.menuButton2, self.menuButton3, nil];
//    for (ContainerButton *button in self.menuButtons) {
//        [self.view addSubview:button];
////        [button addTarget:self action:@selector(onAddWaterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    }

 self.navigationController.navigationBarHidden = YES;
    self.consumptionEvents = [NSArray new];

//    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"ANON: %@", [PFUser currentUser]);

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        //do nothing
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Welcome to Water Tap"
                                                                       message:@"Everything you could want in a water-consumption-tracking-kickass-better-than-the-rest mobile app for your iPhone. !!!"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Show me this fucking sweet app" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

        // This is the first launch ever
        //Take user through tutorial
    }
}



//-(void)beginTutorial {
//
//
//
//
//}

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
//    {
//        // app already launched
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        // This is the first launch ever
//    }
//}

- (IBAction)onAddWaterButtonTapped:(id)sender {

    ConsumptionEvent *myConsumptionEvent = [ConsumptionEvent new];

    myConsumptionEvent.volumeConsumed = 10;

    myConsumptionEvent.user = [PFUser currentUser];
    myConsumptionEvent.consumptionGoal = 32;
    myConsumptionEvent.consumedAt = [NSDate date];
    [myConsumptionEvent pinInBackground];

    [self changeWaterLevel:myConsumptionEvent.volumeConsumed];
}


- (void)toggleFan {

    [self.animator removeAllBehaviors];
    if (self.isFannedOut){
        [self fanIn];
    }
    else {
        [self fanOut];
    }

    self.isFannedOut = !self.isFannedOut;
}

-(void)fanOut{
    CGPoint point = CGPointMake(self.addWaterButton.frame.origin.x - 50, self.addWaterButton.frame.origin.y + 20);
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.menuButton1 snapToPoint:point];
    [self.animator addBehavior:snapBehavior];

    point = CGPointMake(self.addWaterButton.frame.origin.x - 45, self.addWaterButton.frame.origin.y - 45);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.menuButton2 snapToPoint:point];
    [self.animator addBehavior:snapBehavior];

    point = CGPointMake(self.addWaterButton.frame.origin.x + 20, self.addWaterButton.frame.origin.y - 50);
    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.menuButton3 snapToPoint:point];
    [self.animator addBehavior:snapBehavior];

}

-(void)fanIn{

    CGPoint point = self.addWaterButton.center;

    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self.menuButton1 snapToPoint:point];
    [self.animator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.menuButton2 snapToPoint:point];
    [self.animator addBehavior:snapBehavior];

    snapBehavior = [[UISnapBehavior alloc] initWithItem:self.menuButton3 snapToPoint:point];
    [self.animator addBehavior:snapBehavior];
    
}


-(void)changeWaterLevel:(int) heightChange{



    NSLog(@"1 self.waterLevel height is %f and self.waterLevel y position is %f", self.waterLevel.frame.size.height, self.waterLevel.frame.origin.y);

    CGRect newFrameRect = self.waterLevel.frame;
    newFrameRect.size.height = self.waterLevel.frame.size.height + heightChange;

    newFrameRect.origin.y = self.waterLevel.frame.origin.y - heightChange;

    NSLog(@"2 self.waterLevel height is %f and self.waterLevel y position is %f", self.waterLevel.frame.size.height, self.waterLevel.frame.origin.y);

//    NSLog(@"Height is %f and y position is %f", newFrameRect.size.height, newFrameRect.origin.y);

    if(self.waterLevel.frame.size.height + heightChange >= 667) {


        newFrameRect.size.height = self.waterLevel.frame.size.height + heightChange;

        [UIView animateWithDuration:0.5 animations:^{

            //        self.waterLevelHeightConstraint.constant += heightChange;
            self.waterLevel.frame = newFrameRect;
            self.waterLevelY = self.waterLevel.frame.origin.y;
            self.waterLevelHeight = self.waterLevel.frame.size.height;
            self.waterLevel.backgroundColor = [UIColor colorWithRed:0.96 green:0.85 blue:0.27 alpha:1];
            

        }];
        NSString *messageString = @"You've reached your water intake goal for the day!!!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations you gulper!!" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }

    else{
         newFrameRect.size.height = self.waterLevel.frame.size.height + heightChange;

        [UIView animateWithDuration:0.5 animations:^{

            //        self.waterLevelHeightConstraint.constant += heightChange;
            self.waterLevel.frame = newFrameRect;
            self.waterLevelY = self.waterLevel.frame.origin.y;
            self.waterLevelHeight = self.waterLevel.frame.size.height;
        }];
        
    }
}


- (void)totalVolumeConsumed {
    PFQuery *query = [ConsumptionEvent query];

    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query selectKeys:@[@"volumeConsumed"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // NSLog(@"%@", objects);
        self.consumptionEvents = objects;

        self.totalVolumeSummed = 0;

        for (ConsumptionEvent *event in self.consumptionEvents) {

            self.totalVolumeSummed += event.volumeConsumed;
        }

        NSLog(@"%i", self.totalVolumeSummed);
    }];


}

-(void)refreshWaterLevel {

    [self changeWaterLevel:-self.waterLevel.frame.origin.y];
    [self totalVolumeConsumed];
    [self changeWaterLevel:self.totalVolumeSummed];
}
@end
