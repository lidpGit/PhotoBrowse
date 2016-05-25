//
//  ViewController.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "WebImageViewController.h"
#import "CollectionViewCell.h"
#import "PhotoBrowseViewController.h"
#import "TransitionAnimate.h"

@interface WebImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation WebImageViewController{
    NSArray             *_dataSource;
    UICollectionView    *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = @[@"http://p2.qhimg.com/t011fc13354f12d1a46.jpg",
                    @"http://pic23.nipic.com/20120808/10608426_165438049311_2.jpg",
                    @"http://f.hiphotos.baidu.com/image/pic/item/00e93901213fb80e0ee553d034d12f2eb9389484.jpg",
                    @"http://d.hiphotos.baidu.com/image/pic/item/55e736d12f2eb938e0ae49f5d7628535e4dd6ff1.jpg",
                    @"http://a.hiphotos.baidu.com/image/pic/item/f11f3a292df5e0fe0996ba065e6034a85edf722e.jpg",
                    @"http://f.hiphotos.baidu.com/image/pic/item/728da9773912b31b4ddcf22e8418367adab4e101.jpg",
                    @"http://d.hiphotos.baidu.com/image/pic/item/0823dd54564e92584a00b4e99e82d158ccbf4e84.jpg",
                    @"http://b.hiphotos.baidu.com/image/pic/item/738b4710b912c8fc027dc5cafe039245d688212e.jpg",
                    @"http://h.hiphotos.baidu.com/image/pic/item/d009b3de9c82d15853b66bb6820a19d8bc3e4284.jpg",
                    @"http://b.hiphotos.baidu.com/image/pic/item/9d82d158ccbf6c8121031eefbe3eb13533fa4084.jpg",
                    @"http://f.hiphotos.baidu.com/image/pic/item/fc1f4134970a304ec83a514ed4c8a786c9175c6e.jpg",
                    @"http://f.hiphotos.baidu.com/image/pic/item/fc1f4134970a304ec83a514ed4c8a786c9175c6e.jpg",
                    @"http://h.hiphotos.baidu.com/image/pic/item/8ad4b31c8701a18b68b007349b2f07082838fe76.jpg",
                    @"http://c.hiphotos.baidu.com/image/pic/item/78310a55b319ebc4856784ed8126cffc1e1716a2.jpg",
                    @"http://f.hiphotos.baidu.com/image/pic/item/21a4462309f79052cde894370ef3d7ca7acbd5c0.jpg",
                    @"http://c.hiphotos.baidu.com/image/pic/item/e850352ac65c1038d11a26ddb0119313b07e894d.jpg",
                    @"http://a.hiphotos.baidu.com/image/pic/item/8b82b9014a90f6038bd1a2583b12b31bb051ed48.jpg",
                    @"http://b.hiphotos.baidu.com/image/pic/item/78310a55b319ebc4761e7a978026cffc1e17165d.jpg",
                    @"http://c.hiphotos.baidu.com/image/pic/item/574e9258d109b3defeab9366cebf6c81800a4ca3.jpg",
                    @"http://g.hiphotos.baidu.com/image/pic/item/4afbfbedab64034f8ecf0a18adc379310a551daa.jpg",
                    @"http://e.hiphotos.baidu.com/image/pic/item/3bf33a87e950352a9a4311175143fbf2b2118b8a.jpg",
                    @"http://h.hiphotos.baidu.com/image/pic/item/a1ec08fa513d2697c6e7ac5d57fbb2fb4316d8fe.jpg",
                    @"http://e.hiphotos.baidu.com/image/pic/item/cb8065380cd7912303ff756baf345982b2b78096.jpg",
                    @"http://e.hiphotos.baidu.com/image/pic/item/b151f8198618367a8edaff302a738bd4b21ce588.jpg",
                    @"http://c.hiphotos.baidu.com/image/pic/item/6a63f6246b600c33c512e9ef1f4c510fd9f9a1a9.jpg",
                    @"http://b.hiphotos.baidu.com/image/pic/item/6159252dd42a2834bd82c47f58b5c9ea15cebf9a.jpg",
                    @"http://a.hiphotos.baidu.com/image/pic/item/f3d3572c11dfa9ecd236af3167d0f703918fc1f8.jpg"];
    
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
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[indexPath.row]] placeholderImage:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    TransitionAnimate *animate = [[TransitionAnimate alloc] init];
    animate.presentImageView = cell.imageView;
    animate.currentImageURL = _dataSource[indexPath.row];
    
    PhotoBrowseViewController *photoBrowseVC = [[PhotoBrowseViewController alloc] init];
    photoBrowseVC.imageUrlArray = _dataSource;
    photoBrowseVC.index = indexPath.row;
    photoBrowseVC.animate = animate;
    photoBrowseVC.transitioningDelegate = animate;
    photoBrowseVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoBrowseVC animated:YES completion:nil];
}

@end
