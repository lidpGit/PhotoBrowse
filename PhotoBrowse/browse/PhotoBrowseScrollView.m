//
//  PhotoBrowseScrollView.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "PhotoBrowseScrollView.h"
#import "PhotoLoadingProgressView.h"

@interface PhotoBrowseScrollView ()

@property (strong, nonatomic) PhotoLoadingProgressView *loadingView;

@end

@implementation PhotoBrowseScrollView

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL image:(UIImage *)image{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEvent)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapEvent:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        [self loadImageWithURL:imageURL];
        [self loadImage:image];
    }
    return self;
}

- (PhotoLoadingProgressView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[PhotoLoadingProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _loadingView.showPercent = YES;
        _loadingView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)loadImageWithURL:(NSString *)imageURL{
    if (imageURL) {
        self.userInteractionEnabled = NO;
        self.loadingView.progress = 0;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.loadingView.progress = (receivedSize + 0.0f) / (expectedSize + 0.0f);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.userInteractionEnabled = YES;
            _imageView.image = image;
            [self resetImageViewFrame];
            if (_loadingView) {
                [_loadingView removeFromSuperview];
                _loadingView = nil;
            }
        }];
    }
}

- (void)loadImage:(UIImage *)image{
    if (image) {
        _imageView.image = image;
        [self resetImageViewFrame];
    }
}

- (void)resetImageViewFrame{
    UIImage *image = _imageView.image;
    CGFloat scale = [UIScreen mainScreen].bounds.size.width / image.size.width;
    
    CGRect frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = scale * image.size.height;
    frame.origin.x = 0;
    if (frame.size.height > self.frame.size.height) {
        frame.origin.y = 0;
    }else{
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
    }
    _imageView.frame = frame;
    self.contentSize = CGSizeMake(0, frame.size.height);
    
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 3;
}

- (void)zoomToMinimumScale{
    if (self.zoomScale > self.minimumZoomScale) {
        self.zoomScale = self.minimumZoomScale;
    }
}

#pragma mark - ---------------------- Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (self.zoomScale > self.maximumZoomScale){
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }
    if (self.zoomScale < self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];	
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //放大过程中需要设置图片的中心点
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}

#pragma mark - ---------------------- 事件
- (void)singleTapEvent{
    if (self.photoBrowseDelegate && [self.photoBrowseDelegate respondsToSelector:@selector(hidePhotoBrowse)]) {
        [self.photoBrowseDelegate hidePhotoBrowse];
    }
}

- (void)doubleTapEvent:(UITapGestureRecognizer *)sender{
    if (self.zoomScale != self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        //放大倍数
        CGFloat scale = self.maximumZoomScale;
        CGFloat newWidth = self.bounds.size.width / scale;
        CGFloat newHeight = self.bounds.size.height / scale;
        
        //获取双击的点
        CGFloat touchX = [sender locationInView:sender.view].x;
        CGFloat touchY = [sender locationInView:sender.view].y;
        
        CGRect frame = CGRectMake(touchX - newWidth/2, touchY - newHeight/2, newWidth, newHeight);
        [self zoomToRect:frame animated:YES];
    }
}

@end
