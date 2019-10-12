# GFRefreshControl

[![CI Status](https://img.shields.io/travis/guidosette/GFRefreshControl.svg?style=flat)](https://travis-ci.org/guidosette/GFRefreshControl)
[![Version](https://img.shields.io/cocoapods/v/GFRefreshControl.svg?style=flat)](https://cocoapods.org/pods/GFRefreshControl)
[![License](https://img.shields.io/cocoapods/l/GFRefreshControl.svg?style=flat)](https://cocoapods.org/pods/GFRefreshControl)
[![Platform](https://img.shields.io/cocoapods/p/GFRefreshControl.svg?style=flat)](https://cocoapods.org/pods/GFRefreshControl)

## Example

![Alt Text](https://github.com/guidosette/GFLoadingAnimationView/blob/master/photo.gif)

Custom and customizable refresh control animation for ScrollView and TableView.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

GFRefreshControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GFRefreshControl'
```

## How to use
	- (void)initRefreshControl:(UIScrollView*)scrollView {
		refreshControl = [[GFRefreshImageControl alloc] initWithTableView:scrollView protocol:self selector:@selector(callRequest) target:self];

		[scrollView addSubview:refreshControl];
		
		// customizable
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

## Author

guidosette, guido.fanfani7@gmail.com

## License

GFRefreshControl is available under the MIT license. See the LICENSE file for more info.
