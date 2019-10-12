//
//  GFRefreshControl.m
//  // Fanfa
//
//  Created by Guido Fanfani on 06/12/17.
//  Copyright © 2017 Fanfa. All rights reserved.
//

#import "GFRefreshControl.h"

/**
 It's abstrat class
 You have to extend this class and implements GFRefreshControlBaseProtocol
 **/
@implementation GFRefreshControl {
    CGRect loadingViewBounds;
    CGSize tableViewBounds;
    bool isDragging;
    bool canSendAction;
    bool isRefreshing;
    int paddingTop;

    id target;
    SEL action;
    id<GFRefreshControlProtocol> tableProtocol;
    id<GFRefreshControlAnimationViewProtocol> animationViewProtocol;
    float initYScrollView;
}

const float maxDistancePulling = 100.0f;

- (id)initWithTableView:(UIScrollView*)tableView protocol:(id<GFRefreshControlProtocol>)protocol selector:(SEL)sel target:(id)tar {
    self = [super initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [self getHeightRefreshingControl])];
    if (self) {
        target = tar;
        action = sel;
        tableProtocol = protocol;
        animationViewProtocol = self;
		tableView.delegate = self;
        self.frame = CGRectMake(0, -[self getHeightRefreshingControl], tableView.frame.size.width, 0);
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.masksToBounds = true;
    [self setClipsToBounds:true];
    self.backgroundColor = [UIColor clearColor];

    CGRect rectLoading = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIView* animationView = [animationViewProtocol setupAnimationView];
    [animationViewProtocol updateRect:rectLoading];
    [self addSubview:animationView];

}

- (void)updateTableBounds:(CGSize)tableViewSize {
    tableViewBounds = tableViewSize;
    float width = tableViewSize.width/3;
    float x = (tableViewSize.width - width)/2;
    CGRect rectLoading = CGRectMake(x, 0, width, [self getHeightRefreshingControl]);
    UIView* animationView = [animationViewProtocol updateRect:rectLoading];
    loadingViewBounds = animationView.bounds;
}

- (void)setInitScrollY:(float)scrollY {
    initYScrollView = scrollY;
}

/**
 when is refreshing
 */
- (float)getHeightRefreshingControl {
    return 60;
}

- (float)getMaxDistancePulling {
    return maxDistancePulling;
}

- (void)beginRefreshing {
    isRefreshing = true;
    [animationViewProtocol startAnimation];
}

- (void)endRefreshing {
    isRefreshing = false;
    [animationViewProtocol stopAnimation];
    if (!isDragging) {
        [self setPaddingTopWithAnimation:paddingTop];
    }
}

- (bool)isRefreshing {
    return isRefreshing;
}

- (void)sendAction {
//    NSLog(@"sendAction");
    //        [target performSelector:action];
    [target performSelector:action withObject:nil afterDelay:0];
    [animationViewProtocol startAnimation];
}

- (void)setPaddingTopWithAnimation:(int)padding {
    UIScrollView* table = [tableProtocol getScrollViewForRefreshControl];
    [UIView animateWithDuration:0.3
                     animations:^ {
                         table.contentInset = UIEdgeInsetsMake(padding, table.contentInset.left, table.contentInset.bottom, table.contentInset.right);
                     }
     ];
}

-(void)scrollOffset:(CGFloat)offsetY table:(UIScrollView*)table {
//    NSLog(@"offsetY: %f", offsetY);

    self.frame = CGRectMake(0, +offsetY, tableViewBounds.width, -offsetY);
    CGRect rect = CGRectOffset(loadingViewBounds, tableViewBounds.width/3, self.bounds.size.height/2 - loadingViewBounds.size.height/2 -initYScrollView/2);
    [animationViewProtocol updateRect:rect];

    float perc = (- offsetY + initYScrollView) / maxDistancePulling;
    if (perc > 1.0f) {
        perc = 1.0f;
    }
//    NSLog(@"perc: %f", perc);

    if (isRefreshing && !isDragging && -offsetY+initYScrollView<=[self getHeightRefreshingControl]) {
        // set padding to table on refreshing on time
        if (table.contentInset.top < [self getHeightRefreshingControl]) {
            paddingTop = table.contentInset.top;
            [self setPaddingTopWithAnimation:table.contentInset.top + [self getHeightRefreshingControl]];
        }
    } else if (!isRefreshing && !isDragging) {
        if (table.contentInset.top >= [self getHeightRefreshingControl]) {
            // restore padding top
            [self setPaddingTopWithAnimation:paddingTop];
        }
    }

    if (perc>=1.0f && !isRefreshing) {
        //force refresh
        [self beginRefreshing];
        canSendAction = true;
    }

    if (isRefreshing && !isDragging && canSendAction) {
        canSendAction = false;
        [self sendAction];
    }

    // update viewAnimation view
    if (self.isRefreshing != animationViewProtocol.isAnimation) {
        if (self.isRefreshing) {
            [animationViewProtocol startAnimation];
        } else {
            [animationViewProtocol stopAnimation];
        }
    } else {
        [animationViewProtocol updateProgress:perc animation:false];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([tableProtocol respondsToSelector:@selector(scrollViewDidScroll:)]) {
		[tableProtocol scrollViewDidScroll:scrollView];
	}
	CGFloat offsetY = scrollView.contentOffset.y;
	[self scrollOffset:offsetY table:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isDragging = true;
	if ([tableProtocol respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
		[tableProtocol scrollViewWillBeginDragging:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView*)aScrollView willDecelerate:(BOOL)decelerate {
    isDragging = false;
	if ([tableProtocol respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		[tableProtocol scrollViewDidEndDragging:aScrollView willDecelerate:decelerate];
	}
}


#pragma mark - GFRefreshControlAnimationViewProtocol

- (UIView*)setupAnimationView {
	[NSException raise:@"setupAnimationView not implemented" format:@"GFRefreshControlAnimationViewProtocol is not valid"];
	return nil;
}

- (UIView*)updateRect:(CGRect)rect {
	[NSException raise:@"updateRect not implemented" format:@"GFRefreshControlAnimationViewProtocol is not valid"];
	return nil;
}

- (void)startAnimation {
	[NSException raise:@"startAnimation not implemented" format:@"GFRefreshControlAnimationViewProtocol is not valid"];
}

- (void)stopAnimation {
	[NSException raise:@"stopAnimation not implemented" format:@"GFRefreshControlAnimationViewProtocol is not valid"];
}

- (bool)isAnimation {
	[NSException raise:@"isAnimation not implemented" format:@"GFRefreshControlAnimationViewProtocol is not valid"];
	return nil;
}

- (void)updateProgress:(float)perc animation:(bool)isAnimation {
	[NSException raise:@"updateProgress not implemented" format:@"GFRefreshControlAnimationViewProtocol is not valid"];
}

@end
