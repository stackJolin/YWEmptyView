//
//  EmptyViewConfig.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/27.
//

#import "EmptyViewConfig.h"

@implementation EmptyViewConfig

+ (void)setEmptyTextColor:(UIColor *)color {
    if (color) [[NSUserDefaults standardUserDefaults] setObject:color forKey:kEmptyViewConfigTextColor];
}

+ (UIColor *)emptyTextColor {
    UIColor *color = [[NSUserDefaults standardUserDefaults] objectForKey:kEmptyViewConfigTextColor];
    
    if (!color) color = [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1];
    
    return color;
}

+ (void)setEmptyTextFont:(UIFont *)font {
    if (font) [[NSUserDefaults standardUserDefaults] setObject:font forKey:kEmptyViewConfigTextFont];
}

+ (UIFont *)emptyTextFont {
    UIFont *font = [[NSUserDefaults standardUserDefaults] objectForKey:kEmptyViewConfigTextFont];
    
    if (!font) font = [UIFont systemFontOfSize:15];
    
    return font;
}

+ (void)setEmptyTextLineSpace:(NSInteger)lineSpace {
    if (lineSpace > 0) {
        NSNumber *num = [NSNumber numberWithInteger:lineSpace];
        [[NSUserDefaults standardUserDefaults] setObject:num forKey:kEmptyViewConfigTextLineSpace];
    }
}

+ (NSInteger)emptyTextLineSpace {
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kEmptyViewConfigTextLineSpace];
    
    if (!num) num = [NSNumber numberWithInteger:5];
    
    return num.integerValue;
}

+ (void)yw_setLoadingConfigTexts:(NSDictionary *)texts {
    if (texts) {
        [[NSUserDefaults standardUserDefaults] setObject:texts forKey:kEmptyViewConfigTexts];
    }
}

/** 所有的文案，自定存储，可指定部分
 @"EmptyLoadingText"     -> 正在加载中的文案
 @"EmptyFailedText"      -> 加载失败的文案
 @"EmptyNodataText"      -> 空数据文案
 @"EmptyNoNetText"       -> 无网络文案
 @"EmptyUnloginText"     -> 未登录文案
 */
+ (NSDictionary *)emptyTexts {
    NSDictionary *texts = [[NSUserDefaults standardUserDefaults] objectForKey:kEmptyViewConfigTexts];
    if (!texts) {
        texts = @{@"EmptyLoadingText" : @"正在加载中...",
                  @"EmptyFailedText"  : @"数据加载失败，点击重试",
                  @"EmptyNodataText"  : @"暂无内容",
                  @"EmptyNoNetText"   : @"网络错误，请检查网络设置",
                  @"EmptyUnloginText" : @"用户未登录，请点击登录"};
    }
    return texts;
}

@end
