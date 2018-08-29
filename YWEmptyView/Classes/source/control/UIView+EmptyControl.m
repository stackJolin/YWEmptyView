//
//  UIView+EmptyControl.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import "UIView+EmptyControl.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

#define kYWUnListViewEmptyViewSource @"YWUnListViewEmptyViewSource"

@implementation UIView (EmptyControl)

//*****************************************************************
// MARK: - 关联属性
//*****************************************************************

- (id<EmptyViewDataSource>)v_EmptyViewSource {
    return objc_getAssociatedObject(self, kYWUnListViewEmptyViewSource);
}

- (void)setV_EmptyViewSource:(id<EmptyViewDataSource>)v_EmptyViewSource {
    
    objc_setAssociatedObject(self, kYWUnListViewEmptyViewSource, v_EmptyViewSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//*****************************************************************
// MARK: - public method
//*****************************************************************
- (void)showEmptyView {
    if (!self.v_EmptyViewSource ||
        ![self.v_EmptyViewSource respondsToSelector:@selector(yw_getCustomEmptyView)] ||
        ![self.v_EmptyViewSource yw_getCustomEmptyView]) {
        return;
    }
    
    if (!self.customEmptyBGView) {
        self.customEmptyBGView = [UIView new];
        self.customEmptyBGView.backgroundColor = self.backgroundColor;
    }
    
    UIView *customView = [self.v_EmptyViewSource yw_getCustomEmptyView];
    
    self.customEmptyView = customView;
    [self.customEmptyBGView addSubview:customView];
    
    if (self.superview) {
        [self.superview addSubview:self.customEmptyBGView];
        [self.superview bringSubviewToFront:self.customEmptyBGView];
    }
    else {
        [self addSubview:self.customEmptyBGView];
        [self bringSubviewToFront:self.customEmptyBGView];
    }
    
    self.customEmptyBGView.alpha = 1;
    
    CGFloat verCenterOffset = 0;
    
    if (self.v_EmptyViewSource &&
        [self.v_EmptyViewSource respondsToSelector:@selector(yw_getCustomEmptyViewVerOffset)]) {
        
        verCenterOffset = [self.v_EmptyViewSource yw_getCustomEmptyViewVerOffset];
    }
    
    [self.customEmptyBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.superview) {
            make.edges.equalTo(self.superview);
        }
        else {
            make.edges.equalTo(self);
        }
    }];
    
    [customView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(customView.frame.size.width);
        make.height.mas_equalTo(customView.frame.size.height);
        make.centerX.equalTo(self.customEmptyBGView);
        make.centerY.equalTo(self.customEmptyBGView).offset(verCenterOffset);
    }];
    
    if ([self isKindOfClass:UIScrollView.class]) {
        ((UIScrollView *)self).scrollEnabled = NO;
    }
}

- (void)hiddenEmptyView {
    
    if (!self.customEmptyView || !self.customEmptyBGView) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.customEmptyBGView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self isKindOfClass:UIScrollView.class]) {
            ((UIScrollView *)self).scrollEnabled = NO;
        }
    }];
}

@end
