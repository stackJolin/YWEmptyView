//
//  EmptyWeakObjContainer.m
//  Masonry
//
//  Created by zhuhoulin on 2018/8/29.
//

#import "EmptyWeakObjContainer.h"

@implementation EmptyWeakObjContainer

- (instancetype)initWithWeakObj:(NSObject *)obj {
    if (self = [super init]) {
        _obj = obj;
    }
    return self;
}

@end
