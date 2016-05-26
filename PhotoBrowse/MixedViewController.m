//
//  MixedViewController.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "MixedViewController.h"
#import "CollectionViewCell.h"
#import "PhotoBrowseViewController.h"
#import "TransitionAnimate.h"

@interface MixedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MixedViewController{
    NSArray             *_dataSource;
    UICollectionView    *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _dataSource = @[[self photoInfoWithImage:[UIImage imageNamed:@"1.jpg"] url:nil],
                    [self photoInfoWithImage:[UIImage imageNamed:@"2.jpg"] url:nil],
                    [self photoInfoWithImage:nil url:@"http://f.hiphotos.baidu.com/image/pic/item/00e93901213fb80e0ee553d034d12f2eb9389484.jpg"],
                    [self photoInfoWithImage:nil url:@"http://d.hiphotos.baidu.com/image/pic/item/55e736d12f2eb938e0ae49f5d7628535e4dd6ff1.jpg"],
                    [self photoInfoWithImage:[UIImage imageNamed:@"3.jpg"] url:nil]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (screen_width - 6) / 3;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:CollectionViewCell.class forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self.view addSubview:_collectionView];
}

- (PhotoInfo *)photoInfoWithImage:(UIImage *)image url:(NSString *)url{
    PhotoInfo *info = [[PhotoInfo alloc] init];
    info.image = image;
    info.url = url;
    return info;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------------------- Delegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.photo = _dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    PhotoInfo *photo = _dataSource[indexPath.row];
    
    TransitionAnimate *animate = [[TransitionAnimate alloc] init];
    animate.presentImageView = cell.imageView;
    if (photo.image) {
        animate.localImage = YES;
    }else{
        animate.currentImageURL = photo.url;
    }
    
    PhotoBrowseViewController *photoBrowseVC = [[PhotoBrowseViewController alloc] init];
    photoBrowseVC.photos = _dataSource;
    photoBrowseVC.index = indexPath.row;
    photoBrowseVC.animate = animate;
    photoBrowseVC.transitioningDelegate = animate;
    photoBrowseVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoBrowseVC animated:YES completion:nil];
}

@end
