//
//  PushController.m
//  FSCalendarExample
//
//  Created by youxin on 2018/4/23.
//  Copyright © 2018年 wenchaoios. All rights reserved.
//

#import "PushController.h"
#import "FSCalendar.h"
#import "UIView+FLExtension.h"

//NS_ASSUME_NONNULL_BEGIN

// 获取物理屏幕的宽度
#define SceneWidth (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
// 获取物理屏幕的高度
#define SceneHeight (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define TabbarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20 ? 83 : 49) // 适配iPhone x 底栏高度
#define StatusbarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define  ScenePath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Scene"]



@interface PushController()<UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>{
    void * _KVOContext;
    
    UIButton *zoomBtn;
    NSString *requestDate;//请求参数日期 默认当天
    
    UIView   *headView,*headPopView,*btnBgView;
    UIButton  *allBtn,*headAllBtn,*allowBtn,*refuseBtn;
    UILabel  *headDateLa;
    NSString  * visTapyStr;
    NSString *searchStr;
    BOOL         isSearch;
    
    CGFloat height;
    CGFloat cHeight;
    
}

@property (strong, nonatomic) NSDictionary *fillSelectionColors;
@property (strong, nonatomic) NSDictionary *fillDefaultColors;
@property (strong, nonatomic) NSDictionary *borderDefaultColors;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (strong, nonatomic) NSArray *datesWithEvent;
@property (strong, nonatomic) NSArray *datesWithMultipleEvents;

@property (strong, nonatomic)  FSCalendar *calendar;
@property (strong, nonatomic)  UITableView *tableView;

//@property (strong, nonatomic)  NSLayoutConstraint *calendarHeightConstraint;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

@property (strong, nonatomic)NSMutableArray *dataArry;


//@property (strong, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) UIButton *previousButton;
@property (strong, nonatomic) UIButton *nextButton;

//@property (strong, nonatomic) NSCalendar *gregorian;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end


@implementation PushController

-(NSMutableArray *)dataArry{
    
    if (!_dataArry) {
        _dataArry =[NSMutableArray array];
    }
    return _dataArry;
}

#pragma mark - Life cycle
-(NSDateFormatter *)dateFormatter{
    
    if (!_dateFormatter) {
        _dateFormatter=[[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

-(void)viewDidLoad{
   [super viewDidLoad];
    
    self.title = @"FSCalendar";
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cHeight =   [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    
    [self loadViewvv];
    
}

- (void)loadViewvv
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    //btn 
    
    // 450 for iPad and 300 for iPhone
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 44 + StatusbarHeight, view.frame.size.width, [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300) ];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
//    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 64+5, 95, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-95, 64+5, 95, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    
    headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SceneWidth, 40);
    headView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:headView];
//
//    headDateLa = [[UILabel alloc]init];
//    headDateLa.frame = CGRectMake(20, 0, SceneWidth/2, headView.height);
//    [headView addSubview:headDateLa];
//    headDateLa.text = @"今天"; //默认今天
    
//    headAllBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    headAllBtn.frame = CGRectMake(SceneWidth-100, 0, 80, headView.height);
//    [headAllBtn setTitle:@"全部" forState:(UIControlStateNormal)]; //默认全部
//    [headAllBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//    headAllBtn.titleLabel.font =[UIFont systemFontOfSize:14 ];
//    [headAllBtn setImage:[UIImage imageNamed:@"icon_xiala"] forState:(UIControlStateNormal)];
//    headAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
//    headAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60 , 0, 0);
//    [headView addSubview:headAllBtn];
//    [headAllBtn addTarget:self action:@selector(headAllBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
//
    
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0,self.calendar.bottom+10, SceneWidth, SceneHeight-(44+StatusbarHeight+50+self.calendar.height)) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    
    NSLog(@"********view:%f**%f",self.view.height,SceneHeight-(40+44+StatusbarHeight+50+self.calendar.height));
    
    self.tableView.backgroundColor =[UIColor redColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.backgroundColor =[UIColor whiteColor];
    
    //     self.tableView.backgroundColor =[UIColor greenColor];
    //    self.tableView.rowHeight = 65;
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;

    //***************
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;

    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];

    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];

    self.calendar.scope = FSCalendarScopeWeek;
    
    zoomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
  zoomBtn.frame = CGRectMake(SceneWidth-70,44+StatusbarHeight+ 80, 30, 30);
    zoomBtn.layer.cornerRadius = zoomBtn.width/2;
    zoomBtn.layer.masksToBounds = YES;
    zoomBtn.layer.borderWidth =1;
    zoomBtn.layer.borderColor  = [UIColor lightGrayColor].CGColor;
//    zoomBtn.backgroundColor = [UIColor redColor];
    [zoomBtn setImage:[UIImage imageNamed:@"icon_xiala"] forState:(UIControlStateNormal)];
    [self.view addSubview:zoomBtn];
    [zoomBtn addTarget:self action:@selector(toggleClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
}


#pragma mark-tabview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text =[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}


#pragma mark -calendar

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}
#pragma mark---
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        //        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
        if (oldScope==FSCalendarScopeWeek) {
            
            [self calendarOpen];
        }
        
        if (oldScope==FSCalendarScopeMonth) {
            [self calendarZoom];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

//滑动日历或者cell 日历缩放
// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:{
                
                if(self.tableView.frame.origin.y >300){
                    
                    [ self calendarOpen] ;
                    
                }else{
                    [self calendarZoom];
                }
                NSLog(@"$$$$$$$$$$$$$$$111____%f",self.tableView.frame.origin.y);
                return velocity.y < 0;
            }
                break;
            case FSCalendarScopeWeek:{
                
                if(self.tableView.frame.origin.y < 300){
                    
                    [self calendarZoom];
                }else{
                    [ self calendarOpen] ;
                    
                }
                NSLog(@"$$$$$$$$$$$$$$$222____%f",self.tableView.frame.origin.y);
                return velocity.y > 0;
            }
                break;
        }
    }
    return shouldBegin;
}


#pragma mark - <FSCalendarDelegate>

//日期下小点

//- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
//{
//    //    NSLog(@"%@",(calendar.scope==FSCalendarScopeWeek?@"week":@"month"));
//    //_calendarHeightConstraint.constant = CGRectGetHeight(bounds);
//
//      _calendarHeightConstraint.constant = 200;
//
//    [self.view layoutIfNeeded];
//}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    //选择的时间
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSLog(@"选择的日期： %@",[format stringFromDate:date]);
    
    //根据日期查询访客记录
    requestDate = [format  stringFromDate:date];
//    [self requestData];
//    [self popHidden];
    [self.tableView reloadData];
    //     NSLog(@"选择的时间 %@", requestDate );
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
}

#pragma mark - <FSCalendarDataSource>
-(void)passZoomBtnClickAction:(UIButton*)btn{
    [self toggleClicked];
    
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        return 1;
    }
    
    return 0;
}


//日期背景颜色
#pragma mark - <FSCalendarDelegateAppearance>

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    
    return [UIColor redColor];
}

- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithMultipleEvents containsObject:dateString]) {
        return @[[UIColor magentaColor],appearance.eventDefaultColor,[UIColor blackColor]];
        
    }
    return nil;
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_fillSelectionColors.allKeys containsObject:key]) {
//        return _fillSelectionColors[key];
//    }
//    return appearance.selectionColor;
//}

//日期背景色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_fillDefaultColors.allKeys containsObject:key]) {
//        return _fillDefaultColors[key];
//    }
//    return nil;
//}

//日期背景边框颜色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        return _borderDefaultColors[key];
//    }
//    return appearance.borderDefaultColor;
//}
//
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        return _borderSelectionColors[key];
//    }
//    return appearance.borderSelectionColor;
//}
//
////日期边框
//- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
//{
//    if ([@[@8,@17,@21,@25] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]) {
//        return 0.0;
//    }
//    return 1.0;
//}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = touch.view;
    if ([view isKindOfClass:[UITableView class]] || [@"tableView" isEqualToString:[[view class] description]] )
    {
        return NO;
    }
    
    return YES;
}
#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (tableView == self.tableView) {
//        VisLeftModel *model  = self.dataArry[indexPath.row];
//        
//        VisDetaileRecordController *finshVC =[[VisDetaileRecordController alloc]init];
//        finshVC.visNameStr = ObjectToString(model.name);
//        finshVC.visStuType = [NSString stringWithFormat:@"%@",model.status];
//        finshVC.visPhoneNumStr = ObjectToString(model.phonenum);
//        [self.navigationController pushViewController:finshVC animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - Target actions

- (void)toggleClicked
{
    if (self.calendar.scope == FSCalendarScopeMonth) {
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
        if(self.tableView.frame.origin.y <self.calendar.bottom){
            
            
            [self calendarZoom];
        }
        NSLog(@"****1111111**********%f",self.tableView.frame.origin.y);
        
    } else {
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
        
        if(self.tableView.frame.origin.y >self.calendar.bottom){
            
            [ self calendarOpen] ;
        }
        
        NSLog(@"****33333**********%f",self.tableView.frame.origin.y);
        
        
    }
    
}

-(void)calendarOpen{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.calendar.frame = CGRectMake(0,44 + StatusbarHeight, SceneWidth,cHeight);
        self.tableView.frame = CGRectMake(0, self.calendar.bottom, SceneWidth, SceneHeight-(self.calendar.bottom));
//        self.tableView.frame = CGRectMake(0,self.calendar.bottom+10, SceneWidth, SceneHeight-(44+StatusbarHeight+50+self.calendar.height));
        headPopView.frame = CGRectMake(0, self.tableView.top+40, SceneWidth, SceneHeight -(self.tableView.top+40) );
        //        zoomBtn.frame = CGRectMake(SceneWidth-60, height-20, 40, 40); NSLog(@"***aaaa**********%f",self.tableView.frame.origin.y);
         zoomBtn.frame = CGRectMake(SceneWidth-70, self.calendar.bottom-30, 30, 30);
           [zoomBtn setImage:[UIImage imageNamed:@"icon_shangla"] forState:(UIControlStateNormal)];
    }];
}

-(void)calendarZoom{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.frame = CGRectMake(0,44 + StatusbarHeight, SceneWidth,cHeight);
     self.tableView.frame = CGRectMake(0, self.calendar.bottom-180, SceneWidth, SceneHeight-(self.calendar.bottom));
//        self.tableView.frame = CGRectMake(0,cHeight+10, SceneWidth, SceneHeight-(44+StatusbarHeight+50+self.calendar.height));
        headPopView.frame = CGRectMake(0, self.tableView.top+40, SceneWidth, SceneHeight -(self.tableView.top+40) );
//        zoomBtn.frame = CGRectMake(SceneWidth-60, 120-20, 30, 30); NSLog(@"****bbbbb**********%f",self.tableView.frame.origin.y);
          zoomBtn.frame = CGRectMake(SceneWidth-70,44+StatusbarHeight+ 80, 30, 30);
           [zoomBtn setImage:[UIImage imageNamed:@"icon_xiala"] forState:(UIControlStateNormal)];
    }];
}

-(void)test{
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    
    self.datesWithEvent = @[@"2015-10-03",
                            @"2015-10-06",
                            @"2015-10-12",
                            @"2015-10-25"];
    
    self.datesWithMultipleEvents = @[@"2015-10-08",
                                     @"2015-10-16",
                                     @"2015-10-20",
                                     @"2015-10-28"];
    
    
}






@end
