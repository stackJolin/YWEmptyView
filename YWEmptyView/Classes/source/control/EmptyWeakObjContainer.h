//
//  EmptyWeakObjContainer.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/29.
//

#import <Foundation/Foundation.h>

@interface EmptyWeakObjContainer : NSObject

@property (nonatomic, weak, readonly) id obj;

- (instancetype)initWithWeakObj:(NSObject *)obj;

@end
