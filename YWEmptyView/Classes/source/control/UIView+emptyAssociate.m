//
//  UIView+emptyAssociate.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import "UIView+emptyAssociate.h"
#import <objc/runtime.h>

static char const *const KEmptyAssociateView         = "EmptyAssociateView";
static char const *const KEmptyAssociateBGView       = "EmptyAssociateBGView";

@implementation UIView (emptyAssociate)

- (UIView *)customEmptyView {
    return objc_getAssociatedObject(self, KEmptyAssociateView);
}

- (void)setCustomEmptyView:(UIView *)customEmptyView {
    objc_setAssociatedObject(self, KEmptyAssociateView, customEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)customEmptyBGView {
    return objc_getAssociatedObject(self, KEmptyAssociateBGView);
}

- (void)setCustomEmptyBGView:(UIView *)customEmptyBGView {
    objc_setAssociatedObject(self, KEmptyAssociateBGView, customEmptyBGView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
