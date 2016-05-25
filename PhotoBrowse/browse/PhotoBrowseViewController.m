//
//  PhotoBrowseViewController.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "PhotoBrowseViewController.h"
#import "PhotoBrowseScrollView.h"

static CGFloat const margin = 10.0f; /**< 图片之间间距 */

@interface PhotoBrowseViewController ()<UIScrollViewDelegate, PhotoBrowseScrollViewDelegate>

@end

@implementation PhotoBrowseViewController{
    NSInteger               _totalCount;
    UIScrollView            *_scrollView;
    NSMutableDictionary     *_photoViewList;
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------------------- UI
- (void)initUI{
    self.view.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-margin, 0, self.view.frame.size.width + margin * 2, self.view.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _photoViewList = [[NSMutableDictionary alloc] init];
    
    _totalCount = self.imageUrlArray ? self.imageUrlArray.count : self.imageArray.count;
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * _totalCount, 0)];
    [_scrollView addSubview:[self photoViewWithIndex:self.index]];
    _scrollView.contentOffset = CGPointMake(self.index * _scrollView.frame.size.width, 0);
}

- (PhotoBrowseScrollView *)photoViewWithIndex:(NSInteger)index{
    //计算photoView的frame
    CGRect frame = CGRectZero;
    frame.size = _scrollView.bounds.size;
    frame.origin.x = frame.size.width * index;
    frame = CGRectInset(frame, margin, 0);
    
    //本地图片
    UIImage *image = nil;
    if (self.imageArray) {
        image = self.imageArray[index];
    }
    
    //网络图片
    NSString *imageURL = nil;
    if (self.imageUrlArray) {
        imageURL = self.imageUrlArray[index];
    }
    
    PhotoBrowseScrollView *photoView = [[PhotoBrowseScrollView alloc] initWithFrame:frame imageURL:imageURL image:image];
    photoView.photoBrowseDelegate = self;
    [_photoViewList setObject:photoView forKey:@(index)];
    return photoView;
}

#pragma mark - ---------------------- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat viewWidth = _scrollView.bounds.size.width;
    CGFloat contentOffsetX = _scrollView.contentOffset.x;
    
    NSInteger fromPage = (contentOffsetX / viewWidth);
    NSInteger toPgae = fromPage + 1;
    
    if (fromPage < 0) {
        fromPage = 0;
    }
    if (toPgae > _totalCount - 1) {
        toPgae = _totalCount - 1;
    }
    
    NSRange pageRange = NSMakeRange(fromPage, (toPgae - fromPage + 1));
    NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSetWithIndexesInRange:pageRange];
    
    for (NSNumber *key in [_photoViewList allKeys]) {
        NSInteger page = [key integerValue];
        if ([pageSet containsIndex:page] == NO) {
            PhotoBrowseScrollView *photoView = [_photoViewList objectForKey:key];
            if (photoView) {
                [photoView removeFromSuperview];
                [_photoViewList removeObjectForKey:key];
                photoView = nil;
            }
        } else {
            [pageSet removeIndex:page];
        }
    }
    
    if (pageSet.count > 0) {
        [pageSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:
         ^(NSUInteger page, BOOL *stop) {
             [_scrollView addSubview:[self photoViewWithIndex:page]];
         }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat viewWidth = scrollView.bounds.size.width;
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    NSInteger page = (contentOffsetX / viewWidth);
    page++;
    
    //其它的photoView缩放到最小比例
    [_photoViewList enumerateKeysAndObjectsUsingBlock:
     ^(NSNumber *key, PhotoBrowseScrollView *contentView, BOOL *stop) {
         if ([key integerValue] != page) {
             [contentView zoomToMinimumScale];
         }
     }];
}

#pragma mark - ---------------------- PhotoBrowseScrollViewDelegate
- (void)hidePhotoBrowse{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
