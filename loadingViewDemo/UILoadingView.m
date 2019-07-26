//
//  UILoadingView.m
//  loadingViewDemo
//
//  Created by sunyazhou on 2019/7/22.
//  Copyright © 2019 www.sunyazhou.com. All rights reserved.
//

#import "UILoadingView.h"

NSString *const kCircleName = @"LoadingCircleName";
NSString *const kScaleAnimationKey = @"ScaleAnimationKey";

@interface UILoadingView ()

@property(nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@end

@implementation UILoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

- (void)setupSubviews {
    if (self.replicatorLayer == nil) {
        self.replicatorLayer = [CAReplicatorLayer layer];
        self.replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.replicatorLayer];
        self.replicatorLayer.bounds = self.bounds;
        self.replicatorLayer.position = self.center;
        NSInteger instanceCount = 15;
        self.replicatorLayer.instanceCount = instanceCount;
        self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI * 2 / instanceCount, 0, 0, 1);
        self.replicatorLayer.instanceDelay = 1 / (instanceCount * 1.0); //注意除数不能为0 否则crash
        
    }
    
    CALayer *circle = [CALayer layer];
    circle.bounds = CGRectMake(0, 0, 10, 10);
    circle.cornerRadius = 5;
    circle.position = CGPointZero;
    circle.backgroundColor = [self randomColor].CGColor;
    circle.name = kCircleName; //设置layer的唯一标识
    [self.replicatorLayer addSublayer:circle];
    //小技巧 刚开始的动画不是很自然，那是因为小圆点的初始比例是1,让小圆点的初始比例为0.01
    circle.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.replicatorLayer.bounds = self.bounds;
    self.replicatorLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    
    CALayer *circleLayer = [self findCircleLayer];
    if (circleLayer) {
        circleLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 - 40); //距离圆心 40px
    }
    [CATransaction commit];
    [self.replicatorLayer layoutSublayers];
}

- (CALayer *)findCircleLayer {
    for (CALayer *layer in [self.replicatorLayer sublayers]) {
        if ([[layer name] isEqualToString:kCircleName]) {
            return layer;
        }
    }
    return nil;
}

- (void)startLoading {
    CALayer *circleLayer = [self findCircleLayer];
    if (circleLayer && ![[circleLayer animationKeys] containsObject:kScaleAnimationKey]) {
        //加动画
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @(1);
        scale.toValue = @(0.1);
        scale.duration = 1;
        scale.repeatCount = HUGE;
        [circleLayer addAnimation:scale forKey:kScaleAnimationKey];
    }
}

- (void)stopLoading {
    CALayer *circleLayer = [self findCircleLayer];
    if (circleLayer && [[circleLayer animationKeys] containsObject:kScaleAnimationKey]) {
        [circleLayer removeAnimationForKey:kScaleAnimationKey];
    }
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end
