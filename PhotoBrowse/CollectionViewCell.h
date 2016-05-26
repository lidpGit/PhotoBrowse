//
//  CollectionViewCell.h
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) PhotoInfo *photo;

@end
