//
//  THDatePickerView.h
//  rongyp-company
//
//  Created by Apple on 2016/11/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer;

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

@end

@interface THDatePickerView : UIView

//type 1 为年月 2 为年月日 其他为那年月日时分秒
- (instancetype)initWithFrame:(CGRect)frame withType:(NSString*)type;

@property(nonatomic,strong)NSString *selectType;
@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id <DatePickerViewDelegate> delegate;

/// 显示
- (void)show;


@end
