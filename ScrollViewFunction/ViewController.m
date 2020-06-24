//
//  ViewController.m
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import "ViewController.h"

#import "CollectionViewController.h"
#import "TableViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"滑动列表";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELLID"];
    [self.tableArray addObjectsFromArray:@[@[@"单选",
                                             @"多选",
                                             @"拖动Cell"],
                                           @[@"单选",
                                             @"多选",
                                             @"拖动Cell",
                                             @"编辑模式下单选",
                                             @"编辑模式下多选"]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.tableArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self.tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CollectionViewController *vc = [[CollectionViewController alloc] init];
        vc.type = indexPath.item;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        TableViewController *vc = [[TableViewController alloc] init];
        vc.type = indexPath.item;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"UICollectionView";
    } else if (section == 1) {
        return @"UITableView";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSMutableArray *)tableArray {
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}

@end
