//
//  UIScrollView+YWEmty.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/15.
//

#import "UIScrollView+EmtyControl.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

#define kYWListViewEmptyViewSource @"YWListViewEmptyViewSource"

static NSMutableDictionary *yw_emptySwizzleInfo;
static NSString *const yw_emptySwizzleInfoPointerKey = @"pointer";
static NSString *const yw_emptySwizzleInfoOwnerKey = @"owner";
static NSString *const yw_emptySwizzleInfoSelectorKey = @"selector";

@implementation UIScrollView (EmtyControl)

//*****************************************************************
// MARK: - associate property
//*****************************************************************

- (id<EmptyViewDataSource>)emptyViewSource {
    return objc_getAssociatedObject(self, kYWListViewEmptyViewSource);
}

- (void)setEmptyViewSource:(id<EmptyViewDataSource>)emptyViewSource {
    
    if (!emptyViewSource) return;
    
    if (![self isKindOfClass:[UITableView class]] &&
        ![self isKindOfClass:[UICollectionView class]]) return;
    
    objc_setAssociatedObject(self, kYWListViewEmptyViewSource, emptyViewSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self switchMethod];
}

//*****************************************************************
// MARK: - public action
//*****************************************************************

- (void)yw_emptyViewForceReload {
    [self yw_insertAction];
}

//*****************************************************************
// MARK: - privete action
//*****************************************************************

// 交换方法 - (目前支持的参数个数-(0,1))
void yw_reWriteParamIMP(id target, SEL sel, id p) {
    IMP impPointer = yw_getImpPointer(target, sel);
    
    ((void(*)(id,SEL,id))impPointer)(target,sel,p);
}

void yw_reWriteNoParamIMP(id target, SEL sel) {
    IMP impPointer = yw_getImpPointer(target, sel);
    
    ((void(*)(id,SEL))impPointer)(target,sel);
}

IMP yw_getImpPointer(id target, SEL sel) {
    Class baseClass = yw_BaseClassToSwizzleForTarget(target);
    NSString *key = yw_SwizzleInfoKey(baseClass, sel);
    
    NSDictionary *swizzleInfo = [yw_emptySwizzleInfo objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:yw_emptySwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    
    // 执行自定义方法
    [(UIScrollView *)target yw_insertAction];
    
    return impPointer;
}

NSString *yw_SwizzleInfoKey(Class class, SEL selector) {
    if (!class || !selector) {
        return nil;
    }
    
    NSString *className = NSStringFromClass([class class]);
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}

Class yw_BaseClassToSwizzleForTarget(id target) {
    if ([target isKindOfClass:[UITableView class]]) {
        return [UITableView class];
    }
    else if ([target isKindOfClass:[UICollectionView class]]) {
        return [UICollectionView class];
    }
    else if ([target isKindOfClass:[UIScrollView class]]) {
        return [UIScrollView class];
    }
    
    return nil;
}

- (void)switchMethod {
    [self swizzleIfPossible:@selector(reloadData)];
    
    if ([self isKindOfClass:[UITableView class]]) {
        // 这两个方法都需要提前条用benupdate和最后调用endupdate，所以只需要监听endupdate即可
        //        [self swizzleIfPossible:@selector(deleteSections:withRowAnimation:)]
        //        [self swizzleIfPossible:@selector(deleteRowsAtIndexPaths:withRowAnimation:)]
        [self swizzleIfPossible:@selector(endUpdates)];
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collection = (UICollectionView *)self;
        [collection swizzleIfPossible:@selector(insertSections:)];
        [collection swizzleIfPossible:@selector(deleteSections:)];
        [collection swizzleIfPossible:@selector(insertItemsAtIndexPaths:)];
        [collection swizzleIfPossible:@selector(deleteItemsAtIndexPaths:)];
    }
}


- (void)swizzleIfPossible:(SEL)selector {
    
    if (![self respondsToSelector:selector]) {
        return;
    }
    
    if (!yw_emptySwizzleInfo) {
        yw_emptySwizzleInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    
    for (NSDictionary *info in [yw_emptySwizzleInfo allValues]) {
        Class class = [info objectForKey:yw_emptySwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:yw_emptySwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(selector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    Class baseClass = yw_BaseClassToSwizzleForTarget(self);
    NSString *key = yw_SwizzleInfoKey(baseClass, selector);
    
    NSValue *impValue = [[yw_emptySwizzleInfo objectForKey:key] valueForKey:yw_emptySwizzleInfoPointerKey];
    
    if (impValue || !key || !baseClass) {
        return;
    }
    
    Method method = class_getInstanceMethod(baseClass, selector);
    
    NSString *str = NSStringFromSelector(selector);
    
    IMP dzn_newImplementation;
    
    if ([str containsString:@":"]) { // 方法带参数
        dzn_newImplementation = method_setImplementation(method, (IMP)yw_reWriteParamIMP);
    }
    else {
        dzn_newImplementation = method_setImplementation(method, (IMP)yw_reWriteNoParamIMP);
    }
    
    NSDictionary *swizzledInfo = @{yw_emptySwizzleInfoOwnerKey: baseClass,
                                   yw_emptySwizzleInfoSelectorKey: NSStringFromSelector(selector),
                                   yw_emptySwizzleInfoPointerKey: [NSValue valueWithPointer:dzn_newImplementation]};
    
    [yw_emptySwizzleInfo setObject:swizzledInfo forKey:key];
}

- (void)yw_insertAction {
    
    if ([self yw_itemsCount] == 0) {
        // show emptyView
        
        if (!self.emptyViewSource || ![self.emptyViewSource respondsToSelector:@selector(customEmptyView)]) {
            return;
        }
        
        UIView *v = [self.emptyViewSource yw_getCustomEmptyView];
        if (!v) return;
        
        [self insertSubview:v atIndex:0];
        self.customEmptyView = v;
        v.hidden = NO;
        
        CGFloat verMiddleOffset = 0;
        
        if (self.emptyViewSource && [self.emptyViewSource respondsToSelector:@selector(yw_getCustomEmptyViewVerOffset)]) {
            verMiddleOffset = [self.emptyViewSource yw_getCustomEmptyViewVerOffset];
        }
        
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(verMiddleOffset);
            make.width.mas_equalTo(v.frame.size.width);
            make.height.mas_equalTo(v.frame.size.height);
        }];
    }
    else {
        if (!self.customEmptyView) return;
        
        self.customEmptyView.hidden = YES;
    }
}


- (NSInteger)yw_itemsCount {
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        
        NSInteger sections = 1;
        
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    
    return items;
}

@end
