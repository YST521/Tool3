//
//  UIButton+ClickBlock.h
//  RuntimeLearn
//
//  Created by ssb on 16/4/26.
//  Copyright © 2016年 MIMO. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickBlock)(void);

@interface UIButton (ClickBlock)
@property (nonatomic,copy) clickBlock click;
@end
