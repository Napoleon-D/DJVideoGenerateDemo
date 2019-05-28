//
//  MainViewController.m
//  ViedeoMakeDemo
//
//  Created by Tommy on 2018/12/25.
//  Copyright © 2018年 Tommy. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableView.h"

@interface MainViewController ()

@property(nonatomic,strong)MainTableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

-(void)setupUI{
    [self.view addSubview:self.mainTableView];
}

#pragma mark 懒加载

- (MainTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [MainTableView mainTableView];
    }
    return _mainTableView;
}

@end
