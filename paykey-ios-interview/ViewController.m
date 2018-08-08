//
//  ViewController.m
//  paykey-ios-interview
//
//  Created by Ishay Weinstock on 2/15/16.
//  Copyright © 2016 Ishay Weinstock. All rights reserved.
//

#import "ViewController.h"
#import "paykey_ios_interview-Swift.h"

@interface ViewController () <HorizontalTableViewDataSource>

@property (strong) HorizontalTableView *horizontalTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.horizontalTableView = [[HorizontalTableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.horizontalTableView];
    self.horizontalTableView.dataSource = self;
    self.horizontalTableView.backgroundColor = [UIColor redColor];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.horizontalTableView.frame = CGRectMake(0,100,CGRectGetWidth(self.view.bounds),100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark HorizontalTableViewDelegate


- (NSInteger)horizontalTableViewNumberOfCellsWithTableView:(HorizontalTableView * )tableView {
    return 100;
}

- (UIView * )horizontalTableViewWithTableView:(HorizontalTableView * )tableView cellForIndex:(NSInteger)index {
    UILabel* cell = (UILabel*)[tableView dequeueCell];
    if (!cell){
        cell = [[UILabel alloc] init];
    }
    cell.text = [@(index) description];
    cell.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}



@end
