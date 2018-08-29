//
//  UIView+EmptyControl.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

/** 负责UIView和UIScrollView的空页面处理
  * 默认会盖一层背景色和当前View相同颜色的View，在此View的基础上添加其他空View。
 */

#import <UIKit/UIKit.h>
#import "EmptyViewProtocol.h"
#import "UIView+emptyAssociate.h"

@interface UIView (EmptyControl)

@property (nonatomic, strong) id<EmptyViewDataSource> v_EmptyViewSource;

- (void)showEmptyView;
- (void)hiddenEmptyView;

@end
