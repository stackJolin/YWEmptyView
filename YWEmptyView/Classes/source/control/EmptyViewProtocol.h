//
//  YWEmptyViewProtocol.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import <Foundation/Foundation.h>

@protocol EmptyViewDataSource<NSObject>

@required
- (UIView *)yw_getCustomEmptyView;

@optional
- (CGFloat)yw_getCustomEmptyViewVerOffset;

@end
