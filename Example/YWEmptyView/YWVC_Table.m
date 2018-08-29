//
//  YWVC_Table.m
//  YWLoadingView_Example
//
//  Created by zhuhoulin on 2018/8/7.
//  Copyright © 2018年 601584870@qq.com. All rights reserved.
//

#import "YWVC_Table.h"
#import <Masonry/Masonry.h>
//#import <YWLoadingView/UIView+YWLoadView.h>
#import <YWEmptyView/UIView+yw_Empty.h>

@interface YWVC_Table ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UIButton *btnState;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIView *tableHeader;

@end

@implementation YWVC_Table

- (void)dealloc {
    NSLog(@"%@ dealloc\n",NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];

//    self.table.loadingActionTarget = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = self.tableHeader;
    
    [self.view addSubview:self.table];
    [self.view addSubview:self.btnAdd];
    [self.view addSubview:self.btnDelete];
    [self.view addSubview:self.btnState];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.bottom.left.equalTo(self.view);
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.bottom.right.equalTo(self.view);
    }];
    
    [self.btnState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.bottom.equalTo(self.view);
    }];
    
    self.count = 0;
}

- (void)clickBtnAdd:(id)sender {
    self.count++;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.table beginUpdates];
    [self.table insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.table endUpdates];
}

- (void)clickBtnState:(id)sender {
    [self loadData];
}

- (void)clickBtnDelete:(id)sender {
    if (self.count == 0) return;
    self.count--;
    [self.table reloadData];
}

static int CurrentIndex = 1;

- (void)loadData {

    if (CurrentIndex > 5) CurrentIndex = 1;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
//    [self.table ex_startLoading];
    [self.table updateEmptyViewState:EmptyViewState_Loading
                            callBack:^(UIImageView *iv, UILabel *lb, UIButton *btn) {
        
    }];
    
    dispatch_async(queue, ^{
        sleep(2);

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhuhoulin"];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark -YWLoadActionDelegate
//- (void)clickLoadUnloginView:(id<YWLoadUnloginViewProtocol>)unloginView {
//    NSLog(@"%@-点击了未登录", NSStringFromClass([self class]));
//}
//
//- (void)clickNoNetWorkView:(id<YWLoadNoNetWorkViewDelegate>)noNetWorkView {
//    NSLog(@"%@-点击了没网络", NSStringFromClass([self class]));
//}
//
//- (void)clickLoadNodataView:(id<YWLoadNodataViewProtocol>)nodataView {
//    NSLog(@"%@-点击了没数据", NSStringFromClass([self class]));
//}
//
//- (void)clickLoadFailedView:(id<YWLoadFailedViewProtocol>)failedView {
//    NSLog(@"%@-点击了加载失败", NSStringFromClass([self class]));
//}

//*****************************************************************
// MARK: - table
//*****************************************************************

- (UITableView *)table {
    if (!_table) {
        _table = [UITableView new];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 40;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"zhuhoulin"];
    }
    return _table;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [UIButton new];
        [_btnAdd addTarget:self action:@selector(clickBtnAdd:) forControlEvents:UIControlEventTouchUpInside];
        _btnAdd.backgroundColor = [UIColor blueColor];
    }
    return _btnAdd;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [UIButton new];
        [_btnDelete addTarget:self action:@selector(clickBtnDelete:) forControlEvents:UIControlEventTouchUpInside];
        _btnDelete.backgroundColor = [UIColor redColor];
    }
    return _btnDelete;
}

- (UIButton *)btnState {
    if (!_btnState) {
        _btnState = [UIButton new];
        [_btnState addTarget:self action:@selector(clickBtnState:) forControlEvents:UIControlEventTouchUpInside];
        _btnState.backgroundColor = [UIColor blackColor];
    }
    return _btnState;
}

- (UIView *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [UIView new];
        _tableHeader.backgroundColor = [UIColor clearColor];
        _tableHeader.frame = CGRectMake(0, 0, 0, 100);
    }
    return _tableHeader;
}
@end
