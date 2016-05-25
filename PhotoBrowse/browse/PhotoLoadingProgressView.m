//
//  Created by ___lidp___ on 16/1/29.
//

#import "PhotoLoadingProgressView.h"

#define kDegreeToRadian(x) (M_PI/180.0 * (x))

@implementation PhotoLoadingProgressView{
    CGFloat         _radius;            /**< 半径 */
    CGFloat         _progressWidth;     /**< 进度条宽度 */
    CAShapeLayer    *_progressLayer;
    UILabel         *_progressLabel;
}

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        _radius = frame.size.width / 2;
        _progressWidth = 5;
        
        _progressLayer = [self shapeLayer];
        [self.layer addSublayer:_progressLayer];
    }
    return self;
}

- (void)setShowPercent:(BOOL)showPercent{
    _showPercent = showPercent;
    if (_showPercent) {
        _progressLabel = [self progressLabel];
        _progressLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [self addSubview:_progressLabel];
    }
}

- (UILabel *)progressLabel{
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"0%";
    label.numberOfLines = 1;
    [label sizeToFit];
    return label;
}

- (CAShapeLayer *)shapeLayer{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //layer宽高
    CGSize layerSize = CGSizeMake(_radius * 2, _radius * 2);
    
    //layer x值
    CGFloat layerX = (self.bounds.size.width - layerSize.width) / 2;
    
    //layer y值
    CGFloat layerY = (self.bounds.size.height - layerSize.height) / 2;
    
    shapeLayer.frame = CGRectMake(layerX, layerY, layerSize.width, layerSize.height);
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat raduis = _radius - _progressWidth / 2.0f;
    CGFloat staratAngle = -M_PI/2;
    CGFloat endAngle = M_PI/180*270;
    /**
     ArcCenter  ->  弧线中心点
     radius     ->  圆半径
     startAngle ->  弧线开始角度
     endAngle   ->  弧线结束角度
     clockwise  ->  是否为顺时针
     */
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_radius, _radius)
                                                        radius:raduis
                                                    startAngle:staratAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    shapeLayer.path = path.CGPath;
    //path起始位置
    shapeLayer.strokeStart = 0;
    //path结束位置
    shapeLayer.strokeEnd = 0;
    //path内部(内圆)填充颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //path颜色
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    //path宽度
    shapeLayer.lineWidth = _progressWidth;
    
    //path首尾样式(round为圆角)
    /* The cap style used when stroking the path. Options are `butt', `round'
     * and `square'. Defaults to `butt'. */
    shapeLayer.lineCap = @"round";
    return shapeLayer;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progressLayer.strokeEnd = _progress;
    
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%", _progress * 100.0f];
    [_progressLabel sizeToFit];
    _progressLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

@end
