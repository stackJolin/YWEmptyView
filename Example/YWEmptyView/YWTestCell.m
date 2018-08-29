//
//  YWTestCell.m
//  YWLoadingView_Example
//
//  Created by zhuhoulin on 2018/8/7.
//  Copyright © 2018年 601584870@qq.com. All rights reserved.
//

#import "YWTestCell.h"

@interface YWTestCell()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation YWTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.btn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.btn.frame = CGRectMake(0, 0, 100, self.frame.size.height);
}

- (void)clickSelf:(id)sender {
    if (self.clickDeleteCell) self.clickDeleteCell(self);
}

//*****************************************************************
// MARK: - getter
//*****************************************************************


- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton new];
        _btn.backgroundColor =[UIColor redColor];
        [_btn addTarget:self action:@selector(clickSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end
