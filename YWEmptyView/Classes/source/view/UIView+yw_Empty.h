//
//  UIView+yw_Empty.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import <UIKit/UIKit.h>
#import "EmptyViewEnum.h"
#import "EmptyViewProtocol.h"
#import "YWEmptyProtocol.h"

/** 会默认给一套颜色字体，如果有特殊需求，那么调用该callBack */
typedef void (^YWEmptyViewCallBack)(UIImageView *, UILabel *, UIButton *);

@interface UIView (yw_Empty)<EmptyViewDataSource>

@property (nonatomic, weak) id<YWEmptyViewActionDelegate> ywEmptytarget;
@property (nonatomic, strong) NSNumber *verCenterOffset;
@property (nonatomic, strong, readonly) NSMutableDictionary *customViewDict;
@property (nonatomic, strong, readonly) NSNumber *curStateNum;

/**
 * message和imgs都使用默认文案，具体查看YWEmptyView
 */
- (void)updateEmptyViewState:(EmptyViewState)state;

/**
 * message和imgs都使用默认文案，具体查看YWEmptyView
 */
- (void)updateEmptyViewState:(EmptyViewState)state
                    callBack:(YWEmptyViewCallBack)callBack;

/**
 * message为nil的使用使用默认文案，message.length为0的使用不展示文案
 * imgs为nil的使用使用默认图片，imgs.count为0的时候，不展示图片
 */
- (void)updateEmptyViewState:(EmptyViewState)state
                     message:(id)message
                        imgs:(NSArray<UIImage *> *)imgs;

/**
 * message为nil的使用使用默认文案，message.length为0的使用不展示文案
 * imgs为nil的使用使用默认图片，imgs.count为0的时候，不展示图片
 * callback:返回YWEmptyView中的子控件，开发者可自定义特殊样式
 */
- (void)updateEmptyViewState:(EmptyViewState)state
                     message:(id)message
                        imgs:(NSArray<UIImage *> *)imgs
                    callBack:(YWEmptyViewCallBack)callBack;

// 自定义的View，所有的属性自己控制custom，更加灵活的自定义背景样式
- (void)updateEmptyViewState:(EmptyViewState)state
                  customView:(UIView *)customEmptyView;

- (void)emptyViewForceLayout;
- (void)emptyViewRemoveCustomView:(EmptyViewState)state;

@end
