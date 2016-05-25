//
//  PhotoBrowseScrollView.h
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowseScrollViewDelegate <NSObject>

@optional
/**
 *  隐藏图片浏览器
 */
- (void)hidePhotoBrowse;

@end

@interface PhotoBrowseScrollView : UIScrollView<UIScrollViewDelegate>

@property (assign, nonatomic) id<PhotoBrowseScrollViewDelegate> photoBrowseDelegate;
@property (strong, nonatomic) UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL image:(UIImage *)image;

/**
 *  缩放到最小比例
 */
- (void)zoomToMinimumScale;

@end
