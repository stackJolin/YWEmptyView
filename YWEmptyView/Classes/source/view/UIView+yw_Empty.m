//
//  UIView+yw_Empty.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import "UIView+yw_Empty.h"
#import "UIView+emptyAssociate.h"
#import "YWCustomEmptyView.h"
#import "UIScrollView+EmtyControl.h"
#import "UIView+EmptyControl.h"
#import <objc/runtime.h>
#import "EmptyWeakObjContainer.h"

#define kYWEmptyTarget @"kYWEmptyTarget"
#define kYWEmptyVerCenterOffset @"YWEmptyVerCenterOffset"
#define kYWEmptyCustomViewDict @"YWEmptyCustomViewDict"
#define kYWEmptyCustomViewStateNum @"YWEmptyCustomViewStateNum"

@implementation UIView (yw_Empty)

//*****************************************************************
// MARK: - 关联属性
//*****************************************************************

- (id<YWEmptyViewActionDelegate>)ywEmptytarget {
    
    EmptyWeakObjContainer *container = objc_getAssociatedObject(self, kYWEmptyTarget);
    return container.obj;
}

- (void)setYwEmptytarget:(UIResponder *)ywEmptytarget {
    objc_setAssociatedObject(self, kYWEmptyTarget, [[EmptyWeakObjContainer alloc] initWithWeakObj:ywEmptytarget], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)verCenterOffset {
    return objc_getAssociatedObject(self, kYWEmptyVerCenterOffset);
}

- (void)setVerCenterOffset:(NSNumber *)verCenterOffset {
    objc_setAssociatedObject(self, kYWEmptyVerCenterOffset, verCenterOffset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)customViewDict {
    return objc_getAssociatedObject(self, kYWEmptyCustomViewDict);
}

- (void)setCustomViewDict:(NSMutableDictionary *)customViewDict {
    objc_setAssociatedObject(self, kYWEmptyCustomViewDict, customViewDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)curStateNum {
    return objc_getAssociatedObject(self, kYWEmptyCustomViewStateNum);
}

- (void)setCurStateNum:(NSNumber *)curStateNum {
    objc_setAssociatedObject(self, kYWEmptyCustomViewStateNum, curStateNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//*****************************************************************
// MARK: - public method
//*****************************************************************

- (void)updateEmptyViewState:(EmptyViewState)state {
    [self updateEmptyViewState:state
                       message:nil
                          imgs:nil
                      callBack:nil];
}

- (void)updateEmptyViewState:(EmptyViewState)state
                    callBack:(YWEmptyViewCallBack)callBack {
    
    [self updateEmptyViewState:state
                       message:nil
                          imgs:nil
                      callBack:callBack];
}

- (void)updateEmptyViewState:(EmptyViewState)state
                     message:(id)message
                        imgs:(NSArray<UIImage *> *)imgs {
    
    [self updateEmptyViewState:state
                       message:message
                          imgs:imgs
                      callBack:nil];
    
}

- (void)updateEmptyViewState:(EmptyViewState)state
                     message:(id)message
                        imgs:(NSArray<UIImage *> *)imgs
                    callBack:(YWEmptyViewCallBack)callBack {
    
    self.curStateNum = @(state);
    
    if ([self isKindOfClass:UITableView.class] ||
        [self isKindOfClass:UICollectionView.class]) {
        
        UIScrollView *v = (UIScrollView *)self;
        if (!v.emptyViewSource) v.emptyViewSource = self;
    }
    else if ([self isKindOfClass:UIView.class]){
        if (!self.v_EmptyViewSource) self.v_EmptyViewSource = self;
    }
    
    if ([self isKindOfClass:[UITableView class]] ||
             [self isKindOfClass:[UICollectionView class]]) {
        
        [self updateListEmptyViewState:state
                               message:message
                                  imgs:message
                              callBack:callBack];
    }
    else if ([self isKindOfClass:[UIView class]] ||
        [self isKindOfClass:[UIScrollView class]]) {
        
        [self updateNoListEmptyViewState:state
                                 message:message
                                    imgs:message
                                callBack:callBack];
    }
}


- (void)updateListEmptyViewState:(EmptyViewState)state
                         message:(id)message
                            imgs:(NSArray<UIImage *> *)imgs
                        callBack:(YWEmptyViewCallBack)callBack {

    YWCustomEmptyView *v = (YWCustomEmptyView *)[self yw_getCustomEmptyView];
    
    [v customView_updateState:state
                      message:message
                         imgs:imgs
                     callBack:callBack];
}

- (void)updateNoListEmptyViewState:(EmptyViewState)state
                           message:(id)message
                              imgs:(NSArray<UIImage *> *)imgs
                          callBack:(YWEmptyViewCallBack)callBack {
    
    YWCustomEmptyView *v = (YWCustomEmptyView *)[self yw_getCustomEmptyView];
    
    if (state == EmptyViewState_loadSuccess) {
        [self hiddenEmptyView];
    }
    else {
        [self showEmptyView];
    }
    
    [v customView_updateState:state
                      message:message
                         imgs:imgs
                     callBack:callBack];
}


- (void)updateEmptyViewState:(EmptyViewState)state
                  customView:(UIView *)customEmptyView {
    
    if (!customEmptyView) return;
    
    if (!self.customViewDict) {
        self.customViewDict = [NSMutableDictionary new];
    }
    
    [self.customViewDict setObject:customEmptyView forKey:@(state).stringValue];
    self.curStateNum = @(state);
    
    if ([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class]) {
        
        UIScrollView *scoll = (UIScrollView *)self;
        if (!scoll.emptyViewSource) scoll.emptyViewSource = self;
    }
    else if ([self isKindOfClass:UIView.class]){
        if (!self.v_EmptyViewSource) self.v_EmptyViewSource = self;
    }
    
    if ([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class]) {
        [((UITableView *)self) reloadData];
    }
    else if ([self isKindOfClass:UIScrollView.class] || [self isKindOfClass:UIView.class]) {
        if (state == EmptyViewState_loadSuccess) {
            [self hiddenEmptyView];
        }
        else {
            [self showEmptyView];
        }
    }
}

- (void)emptyViewForceLayout {
    if ([self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class]) {
        [((UIScrollView *)self) yw_emptyViewForceReload];
    }
}

- (void)emptyViewRemoveCustomView:(EmptyViewState)state {
    if (self.customViewDict && self.customViewDict[@(state).stringValue]) {
        [self.customViewDict removeObjectForKey:@(state).stringValue];
    }
}

//*****************************************************************
// MARK: - Private Method
//*****************************************************************

- (void)yw_clickReloadActionItem {
    if (!self.ywEmptytarget && ![self.ywEmptytarget respondsToSelector:@selector(yw_emptyViewTapAction:)]) return;
    
    YWCustomEmptyView *v = (YWCustomEmptyView *)self.customEmptyView;
    [self.ywEmptytarget yw_emptyViewTapAction:v.state];
}

//*****************************************************************
// MARK: - delegates
//*****************************************************************
#pragma mark -EmptyViewDataSource

- (UIView *)yw_getCustomEmptyView {
    
    if (self.curStateNum && self.customViewDict && self.customViewDict[self.curStateNum.stringValue]) {
        return self.customViewDict[self.curStateNum.stringValue];
    }
    
    if (!self.customEmptyView) {
        self.customEmptyView = [YWCustomEmptyView new];
        
        if (self.ywEmptytarget) {
            __weak typeof(self) weakSelf = self;
            ((YWCustomEmptyView *)self.customEmptyView).clickBtnReloadCallBack = ^{
                [weakSelf yw_clickReloadActionItem];
            };
        }
    }
    return self.customEmptyView;
}

- (CGFloat)yw_getCustomEmptyViewVerOffset {
    if (self.verCenterOffset) return self.verCenterOffset.floatValue;
    
    return 0;
}

@end
