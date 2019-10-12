//
//  GFRefreshImageControl.m
//  Pods
//
//  Created by Guido Fanfani on 24/10/2018.
//

#import "GFRefreshImageControl.h"
#import "GFMaskImageAnimationColor.h"

@implementation GFRefreshImageControl {
    GFMaskImageAnimationColor* animationView;
}

- (void)setImage:(UIImage*)img {
    [animationView setImage:img];
}

- (void)setFillImageBackgroundColor:(UIColor*)color {
    [animationView setFillImageBackgroundColor:color];
}

- (void)setFillColor:(UIColor*)color {
    [animationView setFillColor:color];
}

#pragma mark - GFRefreshControlAnimationViewProtocol

-(UIView*)setupAnimationView {
    animationView = [[GFMaskImageAnimationColor alloc] initWithImageMask:[UIImage new]
                                                     backgroundColor:[UIColor groupTableViewBackgroundColor]
                                                           fillColor:[UIColor greenColor]
                                                        hideWhenStop:false];
    return animationView;
}

- (UIView*)updateRect:(CGRect)rect {
    [animationView updateRect:rect];
    return animationView;
}

- (void)startAnimation {
    [animationView startAnimation];
}

- (void)stopAnimation {
    [animationView stopAnimation];
}

- (bool)isAnimation {
    return [animationView isAnimation];
}

- (void)updateProgress:(float)perc animation:(bool)isAnimation {
    [animationView updateProgress:perc animation:false];
}

@end
