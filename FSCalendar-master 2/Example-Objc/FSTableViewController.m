//
//  FSTableViewController.m
//  FSCalendar
//
//  Created by DingWenchao on 6/25/15.
//  Copyright (c) 2015 =. All rights reserved.
//

#import "FSTableViewController.h"
#import "LoadViewExampleViewController.h"
#import "FullScreenExampleViewController.h"
#import "DelegateAppearanceViewController.h"
#import "HidePlaceholderViewController.h"
#import "ButtonsViewController.h"
#import "DIYExampleViewController.h"
#import "RangePickerViewController.h"
#import "PushController.h"

@implementation FSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.viewControllers = @[
                             [RangePickerViewController class],
                             [DIYExampleViewController class],
                             [ButtonsViewController class],
                             [HidePlaceholderViewController class],
                             [DelegateAppearanceViewController class],
                             [FullScreenExampleViewController class],
                             [NSObject class],
                             [NSObject class],
                             [LoadViewExampleViewController class]
                            ];
    
    self.tableView.rowHeight = [[UIDevice currentDevice].model hasSuffix:@"iPad"] ? 60.0 : 44.0;
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"push" style:(UIBarButtonItemStylePlain) target:self action:@selector(PUSH)];
    
}
-(void)PUSH{
    
    PushController *pushVC = [[PushController alloc]init];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id viewControllerClass = self.viewControllers[indexPath.row];
    if ([viewControllerClass isSubclassOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:[[viewControllerClass alloc] init] animated:YES];
    }
}

@end
