//
//  EventsViewController.m
//  ShinchokuApp
//
//  Created by ICHIHARA DAICHI on 2013/11/13.
//  Copyright (c) 2013年 ICHIHARA DAICHI. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)getShinchokuArray {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ShinchokuArray"];
}

- (void)setShinchoku:(NSUInteger)number {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"ShinchokuArray"];
    [defaults setObject:[array objectAtIndex:number] forKey:@"currentShinchoku"];
    [defaults synchronize];
    [self.delegate eventsViewShinchokuSet];
}

#pragma mark - UINavigationControllerDelegate
// NOT Recommended
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"ShinchokuArray"];
    if (indexPath.row != [array count]) {
        [defaults setInteger:indexPath.row forKey:@"SelectedIndexPath"];
        [defaults synchronize];
        [self.tableView reloadData];
    }
    if (indexPath.row == [array count]) {
        [self performSegueWithIdentifier:@"segueAdd" sender:self];
    } else {
        [self setShinchoku:indexPath.row];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self getShinchokuArray];
    if ([array count] == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"SelectedIndexPath"];
        [defaults synchronize];
        [self setShinchoku:0];
    }
    return [array count]+1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"ShinchokuArray"];
    if (indexPath.row < [array count]) {
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"Title"];
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.textLabel.text = @"進捗を追加する";
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (indexPath.row == [defaults integerForKey:@"SelectedIndexPath"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row == [self.tableView numberOfRowsInSection:0]-1) {
            return;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *tmpArray = [defaults objectForKey:@"ShinchokuArray"];
        NSMutableArray *tmpMutableArray = [tmpArray mutableCopy];
        [tmpMutableArray removeObjectAtIndex:indexPath.row];
        tmpArray = tmpMutableArray;
        if (indexPath.row == [defaults integerForKey:@"SelectedIndexPath"]) {
            if (!indexPath.row == 0) {
                [defaults setInteger:indexPath.row-1 forKey:@"SelectedIndexPath"];
            } else if (![tmpArray count]) {
                [defaults setInteger:-1 forKey:@"SelectedIndexPath"];
            }
        }
        [defaults setObject:tmpArray forKey:@"ShinchokuArray"];
        [defaults synchronize];
        [self.tableView reloadData];
    }
}

#pragma mark - IBAction
- (IBAction)pressedEditButton:(id)sender {
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem setHidesBackButton:YES animated:YES];
    }
}

@end
