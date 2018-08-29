//
//  YWVC_View.m
//  YWLoadingView_Example
//
//  Created by zhuhoulin on 2018/8/7.
//  Copyright © 2018年 601584870@qq.com. All rights reserved.
//

#import "YWVC_View.h"
#import <Masonry/Masonry.h>
#import "UIView+yw_Empty.h"

@interface YWVC_View ()

@property (nonatomic, strong) UIImageView *ivContent;

@end

@implementation YWVC_View

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
    
    [self.view addSubview:self.ivContent];
    
    [self.ivContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    [self.view updateEmptyViewState:EmptyViewState_Loading];
    
    dispatch_async(queue, ^{
        
        sleep(4);

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.view updateEmptyViewState:EmptyViewState_NoData];
        });
        
        
        sleep(4);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIView *v = [UIView new];
            v.backgroundColor = [UIColor redColor];
            v.frame = CGRectMake(0, 0, 300, 300);
            [self.view updateEmptyViewState:EmptyViewState_NoData customView:v];
        });
    });
}

//*****************************************************************
// MARK: - getter
//*****************************************************************

- (UIImageView *)ivContent {
    if (!_ivContent) {
        _ivContent = [UIImageView new];
        _ivContent.image = [UIImage imageNamed:@"bk"];
    }
    return _ivContent;
}

@end
