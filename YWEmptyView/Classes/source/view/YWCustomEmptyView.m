//
//  YWEmptyView.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

#import "YWCustomEmptyView.h"
#import <Masonry/Masonry.h>
#import "EmptyViewConfig.h"

@interface YWCustomEmptyView()

@property (nonatomic, strong) UIImageView *ivImg;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *btnReload;

@end

@implementation YWCustomEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    if (self = [super initWithFrame:rect]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self bindView];
    [self bindLayout];
    [self bindAction];
}

- (void)bindView {
    [self addSubview:self.ivImg];
    [self addSubview:self.lbTitle];
    [self addSubview:self.btnReload];
}

- (void)bindLayout {
    
    [self.ivImg sizeToFit];
    [self.ivImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.ivImg.frame.size.width);
        make.height.mas_equalTo(self.ivImg.frame.size.height);
        make.bottom.equalTo(self.mas_centerY).offset(-10);
        make.centerX.equalTo(self);
    }];

    CGFloat margin = 40;
    
    [self.lbTitle sizeToFit];
    
    CGFloat width = self.frame.size.width - margin * 2;
    if (self.lbTitle.frame.size.width < width) {
        width = self.lbTitle.frame.size.width;
    }
    
    [self.lbTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY).offset(10);
    }];
    
    [self.btnReload mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(150);
        make.height.mas_equalTo(35);
        make.centerX.equalTo(self);
        make.top.equalTo(self.lbTitle.mas_bottom).offset(20);
    }];
}

- (void)bindAction {
    [self.btnReload addTarget:self action:@selector(clickBtnReload:)
         forControlEvents:UIControlEventTouchUpInside];
}

//*****************************************************************
// MARK: - action
//*****************************************************************

- (void)customView_updateState:(EmptyViewState)state
                       message:(id)message
                          imgs:(NSArray<UIImage *> *)imgs
                      callBack:(void (^)(UIImageView *, UILabel *, UIButton *))callBack {
    
    [self updateLbTitleText:message state:state];
    
    [self updateIvImgs:imgs state:state];
    
    if (state == EmptyViewState_loadSuccess || state == EmptyViewState_Loading) {
        self.btnReload.hidden = YES;
    }
    else {
        self.btnReload.hidden = NO;
    }
    
    if (callBack) {
        callBack(self.ivImg, self.lbTitle, self.btnReload);
    }
    
    [self bindLayout];
}

- (void)clickBtnReload:(id)sender {
    if (self.clickBtnReloadCallBack) self.clickBtnReloadCallBack();
}

- (void)updateIvImgs:(NSArray *)imgs
               state:(EmptyViewState)state {
    NSMutableArray *arr = [NSMutableArray new];
    
    if (!imgs) {
        switch (state) {
            case EmptyViewState_Loading: {
                for (int i = 0; i <= 35; i++) {
                    NSString *name = [NSString stringWithFormat:@"loading_%02d", i];
                    UIImage *img = kGetYWEmptyViewImage(name);
                    if (img) [arr addObject:img];
                }
                break;
            }
            case EmptyViewState_NoData: {
                UIImage *img = kGetYWEmptyViewImage(@"nodata");
                if (img) [arr addObject:img];
                break;
            }
            case EmptyViewState_Failed: {
                UIImage *img = kGetYWEmptyViewImage(@"nonet");
                if (img) [arr addObject:img];
                break;
            }
            case EmptyViewState_NoNetWork: {
                UIImage *img = kGetYWEmptyViewImage(@"nonet");
                if (img) [arr addObject:img];
                break;
            }
            case EmptyViewState_UnLogin: {
                UIImage *img = kGetYWEmptyViewImage(@"unLogin");
                if (img) [arr addObject:img];
                break;
            }
            case EmptyViewState_loadSuccess: {
                break;
            }
            default: { break; }
        }
    }
    
    [self.ivImg stopAnimating];
    
    if (arr.count == 0) {
        self.ivImg.image = nil;
    }
    else if (arr.count == 1) {
        self.ivImg.image = arr.firstObject;
    }
    else if (arr.count > 1) { // 动画
        self.ivImg.image = [UIImage animatedImageWithImages:arr duration:2.f];
        [self.ivImg startAnimating];
    }
}

/* 所有的文案，自定存储，可指定部分
 @"EmptyLoadingText"     -> 正在加载中的文案
 @"EmptyFailedText"      -> 加载失败的文案
 @"EmptyNodataText"      -> 空数据文案
 @"EmptyNoNetText"       -> 无网络文案
 @"EmptyUnloginText"     -> 未登录文案
 */
- (void)updateLbTitleText:(id)message
                    state:(EmptyViewState)state {
    
    if (!message) { // 如果message为nil的话，会使用默认的文案
        NSString *key = @"";
        
        switch (state) {
            case EmptyViewState_Loading: {
                key = @"EmptyLoadingText";
                break;
            }
            case EmptyViewState_NoData: {
                key = @"EmptyNodataText";
                break;
            }
            case EmptyViewState_Failed: {
                key = @"EmptyFailedText";
                break;
            }
            case EmptyViewState_NoNetWork: {
                key = @"EmptyNoNetText";
                break;
            }
            case EmptyViewState_UnLogin: {
                key = @"EmptyUnloginText";
                break;
            }
            case EmptyViewState_loadSuccess: {
                break;
            }
            default: { break; }
        }
        
        if (key.length > 0) {
            message = [[EmptyViewConfig emptyTexts] valueForKey:key];
        }
    }
    
    NSAttributedString *attr = nil;
    
    if ([message isKindOfClass:NSString.class]) {
        
        NSString *text = message;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        CGFloat space = [EmptyViewConfig emptyTextLineSpace];
        
        [paragraphStyle setLineSpacing:space];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        [attributedString addAttribute:NSFontAttributeName value:self.lbTitle.font range:NSMakeRange(0, text.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.lbTitle.textColor range:NSMakeRange(0, text.length)];
        
        attr = attributedString;
    }
    else if ([message isKindOfClass:NSAttributedString.class]){
        attr = message;
    }
    
    self.lbTitle.attributedText = attr;
}

//*****************************************************************
// MARK: - getter
//*****************************************************************

- (UIImageView *)ivImg {
    if (!_ivImg) {
        _ivImg = [UIImageView new];
    }
    return _ivImg;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [UILabel new];
        _lbTitle.numberOfLines = 2;
        _lbTitle.textColor = (UIColor *)[EmptyViewConfig emptyTextColor];
        _lbTitle.font = (UIFont *)[EmptyViewConfig emptyTextFont];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lbTitle;
}

- (UIButton *)btnReload {
    if (!_btnReload) {
        _btnReload = [UIButton new];
        _btnReload.backgroundColor = [UIColor redColor];
        [_btnReload setTitle:@"重新加载" forState:UIControlStateNormal];
    }
    return _btnReload;
}
@end
