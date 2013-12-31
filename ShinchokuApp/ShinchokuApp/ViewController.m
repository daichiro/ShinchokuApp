//
//  ViewController.m
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/13.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertView+Blocks.h"
#import "AddEventViewController.h"

#define kTimeInterval 0.1

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults valueForKey:@"ShinchokuArray"]) {
        [defaults setObject:[NSArray array] forKey:@"ShinchokuArray"];
        [defaults synchronize];
    }
    _isAlertViewShown = NO;
    [self startShinchoku];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startShinchoku {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"currentShinchoku"]) {
        [self setContentsOfShinchoku];
    } else {
        [self nothingShinchoku];
    }
}

- (void)nothingShinchoku {
    RIButtonItem *button = [RIButtonItem itemWithLabel:@"はい" action:^{
        [self performSegueWithIdentifier:@"segueList" sender:self];
    }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"進捗がありません" message:@"まずは進捗を設定しましょう！" cancelButtonItem:button otherButtonItems:nil];
    [alert show];
}

- (void)setContentsOfShinchoku {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults dictionaryForKey:@"currentShinchoku"];
    self.titleLabel.text = [dic objectForKey:@"Title"];
    _deadline = [dic objectForKey:@"Deadline"];
    self.deadlineLabel.text = [self getDateString:_deadline];
    int shinchoku = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"DefaultShinchoku"]] intValue];
    if (shinchoku == 100) {
        [self completeShinchoku];
    }
    self.progressView.progress = (float)shinchoku / 100.0f;
    self.perLabel.text = [NSString stringWithFormat:@"%@%%", [dic objectForKey:@"DefaultShinchoku"]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(loopContents) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)loopContents {
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [_deadline timeIntervalSinceDate:now];
    int hours = interval / 3600;
    int days = hours / 24;
    int minutes = (interval - hours*3600) / 60;
    int seconds = interval - hours*3600 - minutes*60;
    hours -= days*24;
    self.dayLabel.text = [[NSNumber numberWithInt:days] stringValue];
    self.dayLabel.textColor = (days < 4) ? [UIColor redColor] : [UIColor blackColor];
    self.hourLabel.text = [[NSNumber numberWithInt:hours] stringValue];
    if (days < 1) {
        self.hourLabel.textColor = [UIColor redColor];
        self.minuteLabel.textColor = [UIColor redColor];
        self.secondLabel.textColor = [UIColor redColor];
    } else {
        self.hourLabel.textColor = [UIColor blackColor];
        self.minuteLabel.textColor = [UIColor blackColor];
        self.secondLabel.textColor = [UIColor blackColor];
    }
    self.minuteLabel.text = [[NSNumber numberWithInt:minutes] stringValue];
    self.secondLabel.text = [[NSNumber numberWithInt:seconds] stringValue];
    self.todayLabel.text = [self getDateString:now];
    if (seconds < 0) {
        [_timer invalidate];
        [self deadlinePass];
    }
    if ([[self getDateString:now] hasSuffix:@"00:00"]) {
        [self resetNotification];
    }
}

- (NSString*)getDateString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [formatter stringFromDate:date];
}

- (void)resetNotification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"currentShinchoku"];
    NSMutableDictionary *tmp = [dic mutableCopy];
    NSInteger info = [[dic objectForKey:@"Information"] integerValue];
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calender components:NSWeekdayCalendarUnit fromDate:now];
    NSInteger weekday = [comps weekday];
    if (info == InfoTypeEveryday || info == weekday+1) {
        [tmp setObject:@"1" forKey:@"todaysNotification"];
        dic = tmp;
        [defaults setObject:dic forKey:@"currentShinchoku"];
        [defaults synchronize];
    }
}

- (void)doShinchoku {
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"キャンセル"];
    RIButtonItem *ShinchokuOK = [RIButtonItem itemWithLabel:@"進捗あります" action:^{
        [self performSelectorOnMainThread:@selector(gotoShinchokuView) withObject:nil waitUntilDone:YES];
    }];
    RIButtonItem *ShinchokuDAME = [RIButtonItem itemWithLabel:@"進捗だめです" action:^{
        [self performSelectorOnMainThread:@selector(noShinchoku) withObject:nil waitUntilDone:YES];
    }];
    UIAlertView *shinchokuAlert = [[UIAlertView alloc] initWithTitle:@"進捗どうですか" message:@"進捗を選択してください" cancelButtonItem:cancelButton otherButtonItems:ShinchokuOK, ShinchokuDAME, nil];
    [shinchokuAlert show];
}

- (void)gotoShinchokuView {
    [self performSegueWithIdentifier:@"segueShinchoku" sender:self];
}

- (void)noShinchoku {
    __block NSString *dateStr = [self getDateString:[NSDate date]];
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"はい"];
    RIButtonItem *tweetButton = [RIButtonItem itemWithLabel:@"ツイートする" action:^{
        [self tweet:[NSString stringWithFormat:@"進捗だめでした。 %@ #進捗アプリ", dateStr]];
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"進捗結果" message:@"進捗だめでした" cancelButtonItem:cancelButton otherButtonItems:tweetButton, nil];
    [alertView show];
}

- (void)endOfShinchoku {
    [_timer invalidate];
}

- (void)deadlinePass {
    __block NSString *dateStr = [self getDateString:[NSDate date]];
    RIButtonItem *tweetButton = [RIButtonItem itemWithLabel:@"ツイートする" action:^{
        [self tweet:[NSString stringWithFormat:@"進捗期限が過ぎました。 %@ #進捗アプリ", dateStr]];
    }];
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"はい"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"進捗終了" message:@"期限を過ぎました。" cancelButtonItem:okButton otherButtonItems:tweetButton, nil];
    if (!_isAlertViewShown) {
        [alert show];
        _isAlertViewShown = YES;
    }
}

- (void)completeShinchoku {
    __block NSString *dateStr = [self getDateString:[NSDate date]];
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"はい" action:^{
        [self endOfShinchoku];
    }];
    RIButtonItem *tweetButton = [RIButtonItem itemWithLabel:@"ツイートする" action:^{
        [self tweet:[NSString stringWithFormat:@"進捗完了しました。 %@ #進捗アプリ", dateStr]];
        [self endOfShinchoku];
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"進捗100%" message:@"おめでとうございます！進捗完了です。" cancelButtonItem:okButton otherButtonItems:tweetButton, nil];
    [alertView show];
}

- (void)tweet:(NSString*)status {
    SLComposeViewController *tweetView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetView setInitialText:status];
    [self presentViewController:tweetView animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueList"]) {
        EventsViewController *eventsViewController = segue.destinationViewController;
        eventsViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"segueShinchoku"]) {
        ShinchokuViewController *shinchokuViewController = segue.destinationViewController;
        shinchokuViewController.delegate = self;
    }
}

#pragma mark - EventsViewController
- (void)eventsViewShinchokuSet {
    [self startShinchoku];
}

#pragma mark - ShinchokuViewDelegate
- (void)shinchokuViewBack:(NSNumber*)diff total:(NSNumber *)per {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (diff == nil && per == nil) {
        return;
    }
    [self setContentsOfShinchoku];
    __block int blockDiff = [diff intValue];
    __block NSString *dateStr = [self getDateString:[NSDate date]];
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"はい"];
    RIButtonItem *tweetButton = [RIButtonItem itemWithLabel:@"ツイートする" action:^{
        [self tweet:[NSString stringWithFormat:@"%d%%進捗しました！(現在%d%%) %@ #進捗アプリ", blockDiff, [per intValue] , dateStr]];
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"進捗完了" message:@"進捗を反映させました" cancelButtonItem:okButton otherButtonItems:tweetButton, nil];
    [alertView show];
}

#pragma mark - IBAction
- (IBAction)pressedListButton:(id)sender {
    [self performSegueWithIdentifier:@"segueList" sender:self];
}

- (IBAction)pressedShinchoku:(id)sender {
    [self doShinchoku];
}

@end
