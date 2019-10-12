//
//  GFRefreshControlProtocol.h
//  // Fanfa
//
//  Created by Guido Fanfani on 17/01/18.
//  Copyright © 2018 GFribe plc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 It's a protocol for GFRefreshControl
 */
@protocol GFRefreshControlProtocol <NSObject>

/**
 A currently table view that view controller use it.
 */
- (UIScrollView*)getScrollViewForRefreshControl;

@optional

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView*)aScrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
