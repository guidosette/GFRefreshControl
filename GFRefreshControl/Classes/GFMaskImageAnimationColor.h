//
//  GFImageFillColor.h
//  // Fanfa
//
//  Created by Guido Fanfani on 06/12/17.
//  Copyright © 2017 GFribe plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFMaskImageAnimationColor : UIView

- (instancetype)initWithImageMask:(UIImage*)img backgroundColor:(UIColor*)colorBackground fillColor:(UIColor*)colorFill hideWhenStop:(bool)hide;

- (instancetype)initWithImageMask:(UIImage*)imgMask imgFix:(UIImage*)imgFix backgroundColor:(UIColor*)colorBackground fillColor:(UIColor*)colorFill hideWhenStop:(bool)hide;

- (void)updateRect:(CGRect)rect;

- (void)updateProgress:(float)perc animation:(bool)animation;

- (void)setAnimation:(bool)animation;

- (void)startAnimation;

- (void)stopAnimation;

- (bool)isAnimation;

- (void)setImage:(UIImage*)img;

- (void)setFillImageBackgroundColor:(UIColor*)color;

- (void)setFillColor:(UIColor*)color;

@end
