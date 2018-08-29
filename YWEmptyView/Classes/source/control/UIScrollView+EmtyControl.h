//
//  UIScrollView+YWEmty.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/15.
//

#import <UIKit/UIKit.h>
#import "EmptyViewProtocol.h"
#import "UIView+emptyAssociate.h"

/**
 * 轻量化的UITableView,UICollectionView的空页面Controller
 */

@interface UIScrollView (EmtyControl)

@property (nonatomic, strong) id<EmptyViewDataSource> emptyViewSource;

/**
 * 强制刷新。因为有些情况下，verOffset可能会随着UICollectionView或者UITableView的header而调整垂直方面的偏移量。这个时候，需要在'- (CGFloat)yw_CustomEmptyViewVerOffset'方法中，返回相应的高度后，重新调用该方法进行布局
 */
- (void)yw_emptyViewForceReload;

@end
