//
//  TransitionAnimate.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "TransitionAnimate.h"
#import "PhotoBrowseViewController.h"

static const CGFloat duration = 0.5 ; /**< 动画持续时间 */

@implementation TransitionAnimate{
    BOOL _isPresent;
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

//过度时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _isPresent = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresent = NO;
    return self;
}

//过度动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    (_isPresent ? [self presentAnimation:transitionContext] : [self dismissAnimation:transitionContext]);
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //获取photoBrowseView  ==>  PhotoBrowseViewController.view
    UIView *photoBrowseView = [transitionContext viewForKey:UITransitionContextToViewKey];
    photoBrowseView.backgroundColor = [UIColor clearColor];
    photoBrowseView.alpha = 0;

    //显示photoBrowseView
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:photoBrowseView];
    
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    
    //加载本地图片或者已下载的网络图片
    if (self.localImage || (self.currentImageURL && [imageManager diskImageExistsForURL:[NSURL URLWithString:self.currentImageURL]])) {
        //显示过度的imageView
        UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:self.presentImageView.image];
        transitionImageView.frame = [self.presentImageView convertRect:self.presentImageView.bounds toView:nil];
        transitionImageView.clipsToBounds = YES;
        transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
        [containerView addSubview:transitionImageView];
        
        //过度动画
        [UIView animateWithDuration:duration animations:^{
            transitionImageView.frame = [self fullScreenFrameForImage:transitionImageView.image];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            photoBrowseView.alpha = 1;
            photoBrowseView.backgroundColor = [UIColor blackColor];
            [transitionImageView removeFromSuperview];
        }];
    }else{
        [transitionContext completeTransition:YES];
        photoBrowseView.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            photoBrowseView.backgroundColor = [UIColor blackColor];
        }];
    }
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *photoBrowseView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint center = photoBrowseView.center;

    [UIView animateWithDuration:duration animations:^{
        photoBrowseView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        photoBrowseView.center = center;
        photoBrowseView.alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

//获取图片在屏幕居中显示的frame
- (CGRect)fullScreenFrameForImage:(UIImage *)image{
    if (image) {
        CGFloat scale = [UIScreen mainScreen].bounds.size.width / image.size.width;
        
        CGRect frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = scale * image.size.height;
        frame.origin.x = 0;
        if (frame.size.height > [UIScreen mainScreen].bounds.size.height) {
            frame.origin.y = 0;
        }else{
            frame.origin.y = ([UIScreen mainScreen].bounds.size.height - frame.size.height) / 2;
        }
        return frame;
    }
    return CGRectZero;
}

@end
