//
//  GFRefreshControl.h
//  // Fanfa
//
//  Created by Guido Fanfani on 06/12/17.
//  Copyright © 2017 Fanfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFRefreshControlProtocol.h"

/**
 It's a protocol for GFRefreshControlAnimationViewProtocol
 */
@protocol GFRefreshControlAnimationViewProtocol <NSObject>

- (UIView*)setupAnimationView;
- (UIView*)updateRect:(CGRect)rect;
- (void)startAnimation;
- (void)stopAnimation;
- (bool)isAnimation;
- (void)updateProgress:(float)perc animation:(bool)isAnimation;

@end

/**
 It's abstrat class
 You have to extend this class and implements GFRefreshControlBaseProtocol
 **/
@interface GFRefreshControl : UIView<GFRefreshControlAnimationViewProtocol, UIScrollViewDelegate>

- (id)initWithTableView:(UIScrollView*)tableView protocol:(id<GFRefreshControlProtocol>)protocol selector:(SEL)sel target:(id)tar;

- (void)updateTableBounds:(CGSize)tableViewSize;

- (void)setInitScrollY:(float)scrollY;

- (float)getHeightRefreshingControl;

- (float)getMaxDistancePulling;

- (void)beginRefreshing;

- (void)endRefreshing;

- (bool)isRefreshing;

@end
