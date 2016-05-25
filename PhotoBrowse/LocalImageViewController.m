//
//  LocalImageViewController.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/25.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "LocalImageViewController.h"
#import "CollectionViewCell.h"
#import "PhotoBrowseViewController.h"
#import "TransitionAnimate.h"

@interface LocalImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation LocalImageViewController{
    NSArray             *_dataSource;
    UICollectionView    *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = @[[UIImage imageNamed:@"1.jpg"],
                    [UIImage imageNamed:@"2.jpg"],
                    [UIImage imageNamed:@"3.jpg"],
                    [UIImage imageNamed:@"4.jpg"],
                    [UIImage imageNamed:@"5.jpg"]];
    
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
    [cell.imageView setImage:_dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    TransitionAnimate *animate = [[TransitionAnimate alloc] init];
    animate.presentImageView = cell.imageView;
    animate.localImage = YES;
    
    PhotoBrowseViewController *photoBrowseVC = [[PhotoBrowseViewController alloc] init];
    photoBrowseVC.imageArray = _dataSource;
    photoBrowseVC.index = indexPath.row;
    photoBrowseVC.animate = animate;
    photoBrowseVC.transitioningDelegate = animate;
    photoBrowseVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoBrowseVC animated:YES completion:nil];
}

@end
