//
//  GFImageFillColor.m
//  // Fanfa
//
//  Created by Guido Fanfani on 06/12/17.
//  Copyright © 2017 GFribe plc. All rights reserved.
//

#import "GFMaskImageAnimationColor.h"

@implementation GFMaskImageAnimationColor {
    UIColor* fillColor;
    UIColor* backgroundColorMask;
    UIImage* maskImage;
    CGRect viewAnimationBounds;
    UIView *viewAnimation;
    bool animation;
    bool hideWhenStop;
    CALayer *maskImageLayer;
    UIImageView *viewMaskBase;
    UIImageView* fixImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)drawRect:(CGRect)rect {
    [self setup];
}

- (instancetype)initWithImageMask:(UIImage*)img backgroundColor:(UIColor*)colorBackground fillColor:(UIColor*)colorFill hideWhenStop:(bool)hide {
    self = [super init];
    if (self) {
        backgroundColorMask = colorBackground;
        fillColor = colorFill;
        maskImage = img;
        hideWhenStop = hide;
        if (hideWhenStop) {
            self.hidden = true;
        }

        maskImageLayer = [CALayer layer];
        maskImageLayer.contents = (id)maskImage.CGImage;
        maskImageLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

        viewMaskBase = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        viewMaskBase.backgroundColor = backgroundColorMask;
        viewMaskBase.layer.mask = maskImageLayer;
        [self addSubview:viewMaskBase];

        viewAnimation = [[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        viewAnimation.backgroundColor = fillColor;
        viewAnimationBounds = viewAnimation.bounds;
        [viewMaskBase addSubview:viewAnimation];

        [self setup];
    }
    return self;
}

- (instancetype)initWithImageMask:(UIImage*)imgMask imgFix:(UIImage*)imgFix backgroundColor:(UIColor*)colorBackground fillColor:(UIColor*)colorFill hideWhenStop:(bool)hide {
    self = [self initWithImageMask:imgMask backgroundColor:colorBackground fillColor:colorFill hideWhenStop:hide];
    if (self) {
        fixImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        fixImage.image = imgFix;
        [self addSubview:fixImage];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = true;
    self.backgroundColor = [UIColor clearColor];
    
    maskImageLayer.contents = (id)maskImage.CGImage;

    float heightImage = maskImage.size.height;
    float widthImage = maskImage.size.width;
    float ratio = widthImage / heightImage;
    if (heightImage == 0) {
        ratio = 1;
    }
    float height = self.frame.size.height;
    float width = ratio * height;

	float percImage = 1.0;
    maskImageLayer.frame = CGRectMake(width*(1-percImage)/2, height*(1-percImage)/2, width*percImage, height*percImage);

    float x = (self.frame.size.width - width) / 2;
    viewMaskBase.frame = CGRectMake(x, 0, width, height);
    viewMaskBase.backgroundColor = backgroundColorMask;
    viewMaskBase.layer.mask = maskImageLayer;
    [viewMaskBase removeFromSuperview];
    [self addSubview:viewMaskBase];

    viewAnimation.frame = CGRectMake(-width, 0, width, height);
    viewAnimation.backgroundColor = fillColor;
    viewAnimationBounds = viewAnimation.bounds;
    [viewAnimation removeFromSuperview];
    [viewMaskBase addSubview:viewAnimation];

    if (fixImage) {
        fixImage.frame = CGRectMake(x, 0, width, height);
        [fixImage removeFromSuperview];
        [self addSubview:fixImage];
    }


}

- (void)updateRect:(CGRect)rect {
    self.frame = rect;
    [self setup];
}

- (void)updateProgress:(float)perc animation:(bool)isAnimation {
    if (animation) {
        return;
    }
    if (isAnimation) {
        [UIView animateWithDuration:0.3f
                         animations:^{
							 self->viewAnimation.frame = CGRectOffset(self->viewAnimationBounds, self->viewAnimationBounds.size.width*(perc-1.0f), 0);
                         }
                         completion:^(BOOL finished) {
                         }];
    } else {
        viewAnimation.frame = CGRectOffset(viewAnimationBounds,viewAnimationBounds.size.width*(perc-1.0f), 0);
    }
}

- (void)setAnimation:(bool)animation {
    if (animation) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
}

- (void)startAnimation {
    if (animation) {
        return;
    }
    self.hidden = false;
    animation = true;
    CABasicAnimation* moveY = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveY.duration = 0.8;
    moveY.repeatCount = INFINITY;
    moveY.removedOnCompletion = NO;
    moveY.autoreverses = NO;
    moveY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    moveY.fromValue = [NSNumber numberWithFloat:-viewAnimationBounds.size.width/2];
    moveY.toValue = [NSNumber numberWithFloat:viewAnimationBounds.size.width*1.5f];
    [viewAnimation.layer addAnimation:moveY forKey:@"animateMoveX"];
}

- (void)stopAnimation {
    [viewAnimation.layer removeAnimationForKey:@"animateMoveX"];
    animation = false;
    if (hideWhenStop) {
        self.hidden = true;
    }
}

- (bool)isAnimation {
    return animation;
}

- (void)setImage:(UIImage*)img {
    maskImage = img;
    [self setup];
}

- (void)setFillImageBackgroundColor:(UIColor*)color {
    backgroundColorMask = color;
    [self setup];
}

- (void)setFillColor:(UIColor*)color {
    fillColor = color;
    [self setup];
}


@end
