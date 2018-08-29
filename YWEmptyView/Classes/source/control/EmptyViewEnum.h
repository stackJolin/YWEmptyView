//
//  EmptyViewEnum.h
//  Masonry
//
//  Created by zhuhoulin on 2018/8/26.
//

typedef NS_ENUM(NSInteger, EmptyViewState){
    EmptyViewState_Loading      = 0,             // 正在加载
    EmptyViewState_NoData       = 1,             // 没数据
    EmptyViewState_Failed       = 2,             // 加载失败
    EmptyViewState_UnLogin      = 3,             // 需要登录
    EmptyViewState_NoNetWork    = 4,             // 网络问题
    EmptyViewState_loadSuccess  = 5,             // 加载完成
};
