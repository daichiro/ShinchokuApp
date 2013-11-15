//
//  ShinchokuViewController.h
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/15.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShinchokuViewDelegate <NSObject>

- (void)shinchokuViewBack:(NSNumber*)diff;

@end

@interface ShinchokuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UILabel *shinchokuLabel;
@property (strong, nonatomic) IBOutlet UILabel *sabunLabel;
@property (strong, nonatomic) IBOutlet UIButton *shinchokuButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *nowShinchokuLabel;
@property (strong, nonatomic) NSString *defShinchoku;
@property (nonatomic, assign) id<ShinchokuViewDelegate> delegate;

@end
