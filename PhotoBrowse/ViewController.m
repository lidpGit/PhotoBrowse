//
//  ViewController.m
//  PhotoBrowse
//
//  Created by lidp on 16/5/25.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "ViewController.h"
#import "WebImageViewController.h"
#import "LocalImageViewController.h"

static NSString *const identifier = @"cell";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = indexPath.row == 0 ? @"网络图片":@"本地图片";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[WebImageViewController new] animated:YES];
    }else{
        [self.navigationController pushViewController:[LocalImageViewController new] animated:YES];
    }
}

@end
