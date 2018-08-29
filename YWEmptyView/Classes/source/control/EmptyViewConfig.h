//
//  YWEmptyViewConfig.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/27.
//

#import <Foundation/Foundation.h>

#define kEmptyViewConfigTextColor        @"EmptyViewConfigTextColor"
#define kEmptyViewConfigTextFont         @"EmptyViewConfigTextFont"
#define kEmptyViewConfigTextLineSpace    @"EmptyViewConfigTextLineSpace"
#define kEmptyViewConfigTexts            @"EmptyViewConfigTexts"

@interface EmptyViewConfig : NSObject

// 文字颜色
+ (void)setEmptyTextColor:(UIColor *)color;
+ (UIColor *)emptyTextColor;

// 字体
+ (void)setEmptyTextFont:(UIFont *)font;
+ (UIFont *)emptyTextFont;

// 行间距 默认 5.f
+ (void)setEmptyTextLineSpace:(NSInteger)lineSpace;
+ (NSInteger)emptyTextLineSpace;

/** 所有的文案，自定存储，可指定部分
 @"EmptyLoadingText"     -> 正在加载中的文案
 @"EmptyFailedText"      -> 加载失败的文案
 @"EmptyNodataText"      -> 空数据文案
 @"EmptyNoNetText"       -> 无网络文案
 @"EmptyUnloginText"     -> 未登录文案
 */
+ (void)setEmptyTexts:(NSDictionary *)texts;
+ (NSDictionary *)emptyTexts;

@end
