//
//  ViewController.m
//  EmptyTableView
//
//  Created by youxin on 2018/1/17.
//  Copyright © 2018年 YST. All rights reserved.
//

#import "ViewController.h"
#import "LYEmptyViewHeader.h"
#import "MyDIYEmpty.h"
#import "DemoEmptyView.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     self.dataArray = [NSMutableArray array];
    NSArray *arr = @[@"数据1", @"数据2", @"数据3"];
    [self.dataArray addObjectsFromArray:arr];
    
   _tabview = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [self.view addSubview:_tabview];
    _tabview.dataSource = self;
    _tabview.delegate = self;
    _tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tabview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
     [self requestData];
    //1 使用框架UI样式，直接调用
    self.tabview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据，点击重新加载"
                                                           detailStr:@""];
    
    
    //emptyView内容上的点击事件监听
    //emptyView内容上的点击事件监听
    __weak typeof(self)weakSelf = self;
    [self.tabview.ly_emptyView setTapContentViewBlock:^{
        [weakSelf requestData];
    }];
    //网络请求时调用
  //  [self.tabview ly_startLoading];
    //调用时机
//    [self.tableView ly_endLoading];
    
    
}
- (void)requestData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(1);
        
        [self.dataArray removeAllObjects];
        
        NSArray *arr = @[@"数据1", @"数据2", @"数据3"];
        [self.dataArray addObjectsFromArray:arr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray removeAllObjects];
            [self.tabview reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_tabview dequeueReusableCellWithIdentifier:@"cell"];
    
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
//    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
