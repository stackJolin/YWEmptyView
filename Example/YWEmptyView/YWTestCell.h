//
//  YWTestCell.h
//  YWLoadingView_Example
//
//  Created by zhuhoulin on 2018/8/7.
//  Copyright © 2018年 601584870@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWTestCell : UITableViewCell

@property (nonatomic, copy) void (^clickDeleteCell)(YWTestCell *);

@end
