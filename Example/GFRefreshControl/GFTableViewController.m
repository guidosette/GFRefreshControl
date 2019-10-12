//
//  GFTableViewController.m
//  GFRefreshControl_Example
//
//  Created by Guido Fanfani on 12/10/2019.
//  Copyright © 2019 guidosette. All rights reserved.
//

#import "GFTableViewController.h"
#import "GFRefreshImageControl.h"

@interface GFTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation GFTableViewController {
	GFRefreshImageControl* refreshControl;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_tableview.dataSource = self;
	_tableview.backgroundColor = [UIColor whiteColor];
	[self initRefreshControl:_tableview];
}

- (void)initRefreshControl:(UIScrollView*)scrollView {
	refreshControl = [[GFRefreshImageControl alloc] initWithTableView:scrollView protocol:self selector:@selector(callRequest) target:self];
	
	[scrollView addSubview:refreshControl];
	
	[refreshControl setImage:[UIImage imageNamed:@"first"]];
	[refreshControl setFillImageBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	[refreshControl setFillColor:[UIColor greenColor]];
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
	[refreshControl updateTableBounds:_tableview.frame.size];
}

#pragma mark - GFRefreshControlProtocol

- (UIScrollView *)getScrollViewForRefreshControl {
	return _tableview;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
	cell.textLabel.text = [NSString stringWithFormat:@"Cell n° %ld", (long)indexPath.row];
	return cell;
}

@end
