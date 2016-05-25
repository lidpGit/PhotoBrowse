//
//  PhotoBrowseViewController.h
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimate.h"

@interface PhotoBrowseViewController : UIViewController

@property (strong, nonatomic) TransitionAnimate *animate;       /**< 过度动画 */
@property (assign, nonatomic) NSInteger         index;          /**< 当前显示第几张图片 */

//2选1
@property (copy, nonatomic  ) NSArray           *imageUrlArray; /**< 图片地址数组 */
@property (copy, nonatomic  ) NSArray           *imageArray;    /**< 本地图片数组 */

@end
