//
//  YWVC_Collection.m
//  YWLoadingView_Example
//
//  Created by zhuhoulin on 2018/8/7.
//  Copyright © 2018年 601584870@qq.com. All rights reserved.
//

#import "YWVC_Collection.h"
//#import <YWLoadingView/UIView+YWLoadView.h>
#import <Masonry/Masonry.h>
#import <YWEmptyView/UIView+yw_Empty.h>

@interface YWVC_Collection ()
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnDelete;

@end

@implementation YWVC_Collection

- (void)dealloc {
    NSLog(@"%@ dealloc\n",NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.collection.ywEmptytarget = self;
    
    [self.view addSubview:self.collection];
    [self.view addSubview:self.btnAdd];
    [self.view addSubview:self.btnDelete];
    
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.bottom.left.equalTo(self.view);
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.bottom.right.equalTo(self.view);
    }];
    
    self.count = 0;
}

- (void)clickBtnAdd {
    
    self.count++;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collection insertItemsAtIndexPaths:@[indexPath]];
}

- (void)clickBtnDelete {
    if (self.count == 0) return;
    self.count--;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collection deleteItemsAtIndexPaths:@[indexPath]];
    
    [self.collection reloadData];
}

- (void)loadData {

    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    self.collection.verCenterOffset = @(100);
    
    [self.collection updateEmptyViewState:EmptyViewState_Loading];
    dispatch_async(queue, ^{
        
        sleep(4);

        dispatch_sync(dispatch_get_main_queue(), ^{
            self.collection.verCenterOffset = @(0);
            [self.collection emptyViewForceLayout];
        });
        
        sleep(4);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collection updateEmptyViewState:EmptyViewState_NoData
                                         callBack:^(UIImageView *iv, UILabel *lb, UIButton *btn)
            {
                btn.backgroundColor = [UIColor blackColor];
            }];
        });
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"zhuhoulin2" forIndexPath:indexPath];
    
    CGFloat r = ((CGFloat)(rand() % 255)) / 255.f;
    CGFloat g = ((CGFloat)(rand() % 255)) / 255.f;
    CGFloat b = ((CGFloat)(rand() % 255)) / 255.f;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    
    return cell;
}

#pragma mark -YWEmptyViewActionDelegate
- (void)yw_emptyViewTapAction:(EmptyViewState)state {
    NSLog(@"点击了哈哈哈哈哈哈哈哈");
}

//*****************************************************************
// MARK: - getter
//*****************************************************************

- (UICollectionView *)collection {
    if (!_collection) {
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"zhuhoulin2"];
        
        _collection = collectionView;
    }
    return _collection;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [UIButton new];
        [_btnAdd addTarget:self action:@selector(clickBtnAdd) forControlEvents:UIControlEventTouchUpInside];
        _btnAdd.backgroundColor = [UIColor blueColor];
    }
    return _btnAdd;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [UIButton new];
        [_btnDelete addTarget:self action:@selector(clickBtnDelete) forControlEvents:UIControlEventTouchUpInside];
        _btnDelete.backgroundColor = [UIColor redColor];
    }
    return _btnDelete;
}


@end
