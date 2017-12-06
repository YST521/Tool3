//
//  ViewController.m
//  RILI
//
//  Created by yst911521 on 2017/10/16.
//  Copyright © 2017年 YST. All rights reserved.
//

#import "ViewController.h"
#import "RangePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController pushViewController:[[RangePickerViewController alloc]init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
