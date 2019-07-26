//
//  ViewController.m
//  loadingViewDemo
//
//  Created by sunyazhou on 2019/7/22.
//  Copyright © 2019 www.sunyazhou.com. All rights reserved.
//

#import "ViewController.h"

#import <Masonry/Masonry.h>
#import "UILoadingView.h"

@interface ViewController ()

@property (nonatomic, strong) UILoadingView *loadingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loadingView = [[UILoadingView alloc] initWithFrame:CGRectZero];
    self.loadingView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.center.equalTo(self.view);
    }];
    
}

- (IBAction)onAnimationClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.loadingView startLoading];
    } else {
        [self.loadingView stopLoading];
    }
}

@end
