//
//  YWEmptyView.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import <UIKit/UIKit.h>
#import "EmptyViewEnum.h"

@interface YWCustomEmptyView : UIView

@property (nonatomic, copy) void (^clickBtnReloadCallBack)(void);

@property (nonatomic, assign, readonly) EmptyViewState state;

/**
 * message为nil的使用使用默认文案，message.length为0的使用不展示文案
 * imgs为nil的使用使用默认图片，imgs.count为0的时候，不展示图片
 */

- (void)customView_updateState:(EmptyViewState)state
                       message:(id)message
                          imgs:(NSArray<UIImage *> *)imgs
                      callBack:(void (^)(UIImageView *, UILabel *, UIButton *))callBack;

@end
