//
//  YWResourceHelper.h
//  FBSnapshotTestCase
//
//  Created by zhuhoulin on 2018/8/28.
//

#import <Foundation/Foundation.h>
#import <PodAsset/PodAsset.h>

@interface YWResourceHelper : NSObject

/** rewrite */
+ (NSString *)bundleName;

+ (UIImage *)imageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name
             bundleName:(NSString *)bundleName;

@end
