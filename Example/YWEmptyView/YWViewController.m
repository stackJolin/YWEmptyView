//
//  YWViewController.m
//  YWLoadingView
//
//  Created by 601584870@qq.com on 08/06/2018.
//  Copyright (c) 2018 601584870@qq.com. All rights reserved.
//

#import "YWViewController.h"
#import "YWVC_Collection.h"
#import "YWVC_Table.h"
#import "YWVC_View.h"
#import "YWVC_Scroll.h"
#import <Masonry/Masonry.h>

@interface YWViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhuhoulin1"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"View";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"ScrollView";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"UITableView";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"CollectionView";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *v;
    if (indexPath.row == 0) {
        v = [YWVC_View new];
    }
    else if (indexPath.row == 1) {
        v = [YWVC_Scroll new];
    }
    else if (indexPath.row == 2) {
        v = [YWVC_Table new];
    }
    else if (indexPath.row == 3) {
        v = [YWVC_Collection new];
    }
    
    [self.navigationController pushViewController:v animated:YES];
}

//*****************************************************************
// MARK: - getter
//*****************************************************************

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"zhuhoulin1"];
    }
    return _tableView;
}

@end
