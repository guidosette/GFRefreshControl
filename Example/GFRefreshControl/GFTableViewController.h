//
//  GFTableViewController.h
//  GFRefreshControl_Example
//
//  Created by Guido Fanfani on 12/10/2019.
//  Copyright © 2019 guidosette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFRefreshControlProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GFTableViewController : UIViewController<GFRefreshControlProtocol, UITableViewDelegate, UITableViewDataSource>

@end

NS_ASSUME_NONNULL_END
