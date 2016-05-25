//
//  TransitionAnimate.h
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionAnimate : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) UIImageView   *presentImageView;
@property (copy, nonatomic  ) NSString      *currentImageURL;   /**< 当前显示图片的地址,显示本地图片不传此值 */
@property (assign, nonatomic) BOOL          localImage;         /**< 是否加载本地图片 */

@end
