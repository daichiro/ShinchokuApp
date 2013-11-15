//
//  EventsViewController.h
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/13.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventsViewDelegate <NSObject>

- (void)eventsViewShinchokuSet;

@end

@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<EventsViewDelegate> delegate;

@end
