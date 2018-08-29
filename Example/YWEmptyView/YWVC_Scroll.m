//
//  YWVC_Scroll.m
//  YWLoadingView_Example
//
//  Created by zhuhoulin on 2018/8/7.
//  Copyright © 2018年 601584870@qq.com. All rights reserved.
//

#import "YWVC_Scroll.h"
#import <Masonry/Masonry.h>
#import <YWEmptyView/UIView+yw_Empty.h>

@interface YWVC_Scroll ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *ivContent;

@end

@implementation YWVC_Scroll

- (void)dealloc {
    NSLog(@"%@ dealloc\n",NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    [self.view updateEmptyViewState:EmptyViewState_Loading];
    dispatch_async(queue, ^{
        sleep(3);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.view updateEmptyViewState:EmptyViewState_NoData];
        });
    });
}

//*****************************************************************
// MARK: - getter
//*****************************************************************

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (UIImageView *)ivContent {
    if (!_ivContent) {
        _ivContent = [UIImageView new];
        _ivContent.image = [UIImage imageNamed:@"bk"];
    }
    return _ivContent;
}

@end
