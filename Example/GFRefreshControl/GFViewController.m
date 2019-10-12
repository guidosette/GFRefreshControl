//
//  GFViewController.m
//  GFRefreshControl
//
//  Created by guidosette on 10/11/2019.
//  Copyright (c) 2019 guidosette. All rights reserved.
//

#import "GFViewController.h"
#import "GFRefreshImageControl.h"

@interface GFViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation GFViewController {
    GFRefreshImageControl* refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl:_scrollView];
}

- (void)initRefreshControl:(UIScrollView*)scrollView {
    refreshControl = [[GFRefreshImageControl alloc] initWithTableView:scrollView protocol:self selector:@selector(callRequest) target:self];

	[scrollView addSubview:refreshControl];
    

    [refreshControl setImage:[UIImage imageNamed:@"test"]];
    [refreshControl setFillImageBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [refreshControl setFillColor:[UIColor redColor]];
	//    [refreshControl setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)callRequest {
    NSLog(@"callRequest");
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self->refreshControl endRefreshing];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [refreshControl updateTableBounds:_scrollView.frame.size];
}

#pragma mark - GFRefreshControlProtocol

- (UIScrollView *)getScrollViewForRefreshControl {
    return _scrollView;
}

@end
