//
//  AddEventViewController.h
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/13.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import <UIKit/UIKit.h>

enum InfoType {
    InfoTypeNone,
    InfoTypeSun,
    InfoTypeMon,
    InfoTypeTue,
    InfoTypeWed,
    InfoTypeThu,
    InfoTypeFri,
    InfoTypeSat,
    InfoTypeEveryday,
};

#define kComponentsOfPickerView 1
#define kRowsOfPickerView 9

@interface AddEventViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *childView;
@property (nonatomic, retain) IBOutlet UITextField *textFieldTitle;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *sliderText;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *makeButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@end
