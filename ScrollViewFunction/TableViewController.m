//
//  TableViewController.m
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import "TableViewController.h"

#import <YYModel/YYModel.h>
#import "TableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TableViewCellID"];
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"textJson" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = [json objectForKey:@"data"];
    for (NSDictionary *dict in dataArray) {
        PhotoModel *model = [PhotoModel yy_modelWithDictionary:dict];
        model.isSelected = NO;
        [self.tableArray addObject:model];
    }
}

- (void)setType:(TableViewType)type {
    _type = type;
    
    switch (type) {
        case TableViewType_Delete:
        {
            self.navigationItem.title = @"单选";
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 60, 44);
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem  *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barBtn;
        }
            break;
        case TableViewType_MoreDelete:
        {
            self.navigationItem.title = @"多选";
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 60, 44);
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem  *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = barBtn;
        }
            break;
        case TableViewType_Drag:
        {
            self.navigationItem.title = @"拖动";

            [self.tableView setEditing:YES animated:YES];
            self.tableView.allowsMultipleSelectionDuringEditing = YES;
        }
            break;
        case TableViewType_EditDelete:
        {
            self.navigationItem.title = @"编辑单选";
            
            self.tableView.allowsMultipleSelectionDuringEditing = NO;
            
            UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
            self.navigationItem.rightBarButtonItems = @[barBtn];
        }
            break;
        case TableViewType_EditMoreDelete:
        {
            self.navigationItem.title = @"编辑多选";
            
            self.tableView.allowsMultipleSelectionDuringEditing = YES;
            
            UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
            self.navigationItem.rightBarButtonItems = @[barBtn];
        }
            break;
            
        default:
            break;
    }
}

- (void)editAction:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"删除";
    } else if ([sender.title isEqualToString:@"删除"]) {
        for (int i = 0; i < self.tableArray.count; i++) {
            PhotoModel *itemModel = self.tableArray[i];
            if (itemModel.isSelected == YES) {
                [self.tableArray removeObject:itemModel];
                // 当有元素被删除的时候i的值回退1 从而抵消因删除元素而导致的元素下标位移的变化
                i--;
            }
        }
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"编辑";
        [self.tableView reloadData];
    }
}

- (void)deleteAction {
    if (self.type == TableViewType_Delete) {
        if ([self.selectIndexPath length] == 0) {
            NSLog(@"请选择要删除的图片");
            return;
        }
        PhotoModel *itemModel = [self.tableArray objectAtIndex:self.selectIndexPath.row];
        [self.tableArray removeObject:itemModel];
        [self.tableView deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        self.selectIndexPath = NULL;
    } else if (self.type == TableViewType_MoreDelete) {
        for (int i = 0; i < self.tableArray.count; i++) {
            PhotoModel *itemModel = self.tableArray[i];
            if (itemModel.isSelected == YES) {
                [self.tableArray removeObject:itemModel];
                // 当有元素被删除的时候i的值回退1 从而抵消因删除元素而导致的元素下标位移的变化
                i--;
            }
        }
        [self.tableView reloadData];
    } else if (self.type == TableViewType_Drag) {
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID" forIndexPath:indexPath];
    if (self.type == TableViewType_Delete || self.type == TableViewType_MoreDelete) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PhotoModel *model = [self.tableArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TableViewType_Drag) return;
    PhotoModel *itemModel = self.tableArray[indexPath.row];
    itemModel.isSelected = !itemModel.isSelected;
    if (self.type == TableViewType_Delete || self.type == TableViewType_MoreDelete) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    if (self.type == TableViewType_Delete) {
        // 取消之前选中的 indexPath
        if ([self.selectIndexPath length] == 2) {
            PhotoModel *model = [self.tableArray objectAtIndex:self.selectIndexPath.row];
            model.isSelected = !model.isSelected;
            [tableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        // 记录当前选择的 indexPath
        self.selectIndexPath = indexPath;
    }
}

/// 编辑单选模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableArray removeObjectAtIndex:indexPath.row];
    }
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TableViewType_EditDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

/// 编辑多选模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TableViewType_EditDelete || self.type == TableViewType_EditMoreDelete || self.type == TableViewType_Drag) return YES;
    return NO;
}
/// 编辑单选模式

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TableViewType_Delete || self.type == TableViewType_MoreDelete || self.type == TableViewType_Drag || self.type == TableViewType_EditDelete) return;
    PhotoModel *itemModel = self.tableArray[indexPath.row];
    itemModel.isSelected = !itemModel.isSelected;
}
/// 编辑多选模式

/// cell 拖动 canEditRowAtIndexPath return YES;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TableViewType_Drag) return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.tableArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}
/// cell 拖动

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)tableArray {
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
