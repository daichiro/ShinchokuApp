//
//  ViewController.h
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/13.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "EventsViewController.h"
#import "ShinchokuViewController.h"

@interface ViewController : UIViewController <EventsViewDelegate, ShinchokuViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dayLabel;
@property (nonatomic, retain) IBOutlet UILabel *hourLabel;
@property (nonatomic, retain) IBOutlet UILabel *minuteLabel;
@property (nonatomic, retain) IBOutlet UILabel *secondLabel;
@property (nonatomic, retain) IBOutlet UILabel *todayLabel;
@property (nonatomic, retain) IBOutlet UILabel *deadlineLabel;
@property (nonatomic, retain) IBOutlet UILabel *perLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSDate *deadline;
@property (nonatomic, assign) BOOL isAlertViewShown;

@end
