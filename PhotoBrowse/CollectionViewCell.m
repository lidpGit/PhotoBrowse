//
//  CollectionViewCell.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/24.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setPhoto:(PhotoInfo *)photo{
    _photo = photo;
    if (_photo.image) {
        _imageView.image = _photo.image;
    }else{
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_photo.url] placeholderImage:nil];
    }
}

@end
