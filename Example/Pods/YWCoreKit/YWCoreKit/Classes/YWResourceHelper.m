//
//  YWResourceHelper.m
//  FBSnapshotTestCase
//
//  Created by zhuhoulin on 2018/8/28.
//

#import "YWResourceHelper.h"

@implementation YWResourceHelper

/** rewrite */
+ (NSString *)bundleName {
    return @"YWCoreKit";
}

+ (UIImage *)imageNamed:(NSString *)name {
    NSString *bundleName = [self bundleName];
    if (!bundleName) return nil;
    NSBundle *bundle = [PodAsset bundleForPod:bundleName];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name
             bundleName:(NSString *)bundleName {
    
    if (!bundleName) return nil;
    NSBundle *bundle = [PodAsset bundleForPod:bundleName];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
