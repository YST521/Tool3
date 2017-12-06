//
//  ViewController.m
//  THDatePickerView
//
//  Created by Apple on 2016/11/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "THDatePickerView.h"

#define PICKHIGEHT 300
// 获取物理屏幕的宽度
#define SceneWidth             [[UIScreen mainScreen] bounds].size.width
#define SceneHeight            [[UIScreen mainScreen] bounds].size.height

@interface ViewController () <DatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
@property (weak, nonatomic) THDatePickerView *dateView;
@property (strong, nonatomic) UIButton *selectDateBgbtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectDateBgbtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    self.selectDateBgbtn.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
    self.selectDateBgbtn.hidden = YES;
   // self.btn.alpha = 0.3;
    [self.view addSubview:self.selectDateBgbtn];
    [self.selectDateBgbtn addTarget:self action:@selector(datePickerViewCancelBtnClickDelegate) forControlEvents:(UIControlEventTouchUpInside)];
    
    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, PICKHIGEHT) withType:@"2"];
    dateView.delegate = self;
    dateView.title = @" ";
    [self.view addSubview:dateView];
    self.dateView = dateView;

    
}

// 显示
- (IBAction)timerBrnClick:(id)sender {
    self.selectDateBgbtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, PICKHIGEHT);
        [self.dateView show];
    }];
}

#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击");
    self.timerLbl.text = timer;
    
    self.selectDateBgbtn.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, PICKHIGEHT);
    }];
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
    self.selectDateBgbtn.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, PICKHIGEHT);
    }];
}

@end
