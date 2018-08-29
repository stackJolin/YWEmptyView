//
//  YWEmptyProtocol.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/27.
//

#import <Foundation/Foundation.h>
#import "EmptyViewEnum.h"

@protocol YWEmptyViewActionDelegate<NSObject>

- (void)yw_emptyViewTapAction:(EmptyViewState)state;

@end
