//
//  AddEventViewController.m
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/13.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import "AddEventViewController.h"
#import "UIAlertView+Blocks.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

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
    [self.scrollView setContentSize:self.childView.bounds.size];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.textFieldTitle.delegate = self;
    self.slider.value = 0;
    [self.slider addTarget:self action:@selector(sliderSlided:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.textFieldTitle canResignFirstResponder]) {
        [self.textFieldTitle resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textFieldTitle resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return kComponentsOfPickerView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kRowsOfPickerView;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str;
    
    switch (row) {
        case InfoTypeNone:
            str = @"通知なし";
            break;
        case InfoTypeMon:
            str = @"毎週月曜";
            break;
        case InfoTypeTue:
            str = @"毎週火曜";
            break;
        case InfoTypeWed:
            str = @"毎週水曜";
            break;
        case InfoTypeThu:
            str = @"毎週木曜";
            break;
        case InfoTypeFri:
            str = @"毎週金曜";
            break;
        case InfoTypeSat:
            str = @"毎週土曜";
            break;
        case InfoTypeSun:
            str = @"毎週日曜";
            break;
        case InfoTypeEveryday:
            str = @"毎日";
        default:
            break;
    }
    
    return str;
}

- (void)sliderSlided:(UISlider*)slider {
    self.sliderText.text = [NSString stringWithFormat:@"%d%%", (int)slider.value];
}

- (void)showShinchokuMakeErrorAlert:(NSString*)status {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"進捗作成失敗" message:status delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - IBAction
- (IBAction)pressedMakeButton:(id)sender {
    if (![self.textFieldTitle hasText]) {
        [self showShinchokuMakeErrorAlert:@"進捗の名前がありません"];
        return;
    } else if ([self.datePicker.date timeIntervalSinceNow] < 0) {
        [self showShinchokuMakeErrorAlert:@"過去の日付は設定できません"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.textFieldTitle.text forKey:@"Title"];
    [dic setObject:self.datePicker.date forKey:@"Deadline"];
    [dic setObject:[NSNumber numberWithInt:(int)self.slider.value] forKey:@"DefaultShinchoku"];
    [dic setObject:[NSNumber numberWithInteger:[self.pickerView selectedRowInComponent:0]] forKey:@"Information"];
    [dic setObject:@"1" forKey:@"todaysNotification"];
    NSArray *tmpArray = [defaults objectForKey:@"ShinchokuArray"];
    NSMutableArray *tmpMutableArray = [tmpArray mutableCopy];
    [tmpMutableArray addObject:dic];
    tmpArray = tmpMutableArray;
    [defaults setObject:tmpArray forKey:@"ShinchokuArray"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressedCancelButton:(id)sender {
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"いいえ"];
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"はい" action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"進捗キャンセル" message:@"キャンセルしますか？" cancelButtonItem:cancelButton otherButtonItems:okButton, nil];
    [alert show];
}

@end
