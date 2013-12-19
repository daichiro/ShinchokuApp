//
//  ShinchokuViewController.m
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/15.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import "ShinchokuViewController.h"
#import "UIAlertView+Blocks.h"

@interface ShinchokuViewController ()

@end

@implementation ShinchokuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"currentShinchoku"];
    _defShinchoku = [dic objectForKey:@"DefaultShinchoku"];
    self.stepper.value = [_defShinchoku doubleValue];
    self.nowShinchokuLabel.text = [NSString stringWithFormat:@"現在：%@%%", _defShinchoku];
    self.shinchokuLabel.text = [NSString stringWithFormat:@"%@%%", _defShinchoku];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveShinchoku:(NSNumber*)diff {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"currentShinchoku"];
    NSMutableDictionary *tmpDic = [dic mutableCopy];
    [tmpDic setObject:[NSNumber numberWithInt:(int)self.stepper.value] forKey:@"DefaultShinchoku"];
    dic = tmpDic;
    [defaults setObject:dic forKey:@"currentShinchoku"];
    [defaults synchronize];
    [self.delegate shinchokuViewBack:diff total:[NSNumber numberWithDouble:self.stepper.value]];
}

#pragma mark - IBAction
- (IBAction)changedStepperValue:(UIStepper*)sender {
    double value = [sender value];
    self.shinchokuLabel.text = [NSString stringWithFormat:@"%d%%", (int)value];
    int diff = (int)self.stepper.value - [_defShinchoku intValue];
    NSString *diffStr = @"(+0%)";
    if (diff >= 0) {
        diffStr = [NSString stringWithFormat:@"(+%d%%)", diff];
        self.sabunLabel.textColor = [UIColor blackColor];
    } else if (diff < 0) {
        diffStr = [NSString stringWithFormat:@"(%d%%)", diff];
        self.sabunLabel.textColor = [UIColor redColor];
    }
    self.sabunLabel.text = diffStr;
}

- (IBAction)pressedMakeButton:(id)sender {
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"いいえ"];
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"はい" action:^{
        NSString *tmp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentShinchoku"] objectForKey:@"DefaultShinchoku"];
        int diff = (int)self.stepper.value - [tmp intValue];
        [self performSelectorOnMainThread:@selector(saveShinchoku:) withObject:[NSNumber numberWithInt:diff] waitUntilDone:YES];
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"進捗報告" message:@"進捗を確定します" cancelButtonItem:cancelButton otherButtonItems:okButton, nil];
    [alertView show];
}

- (IBAction)pressedCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
