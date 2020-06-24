//
//  CollectionViewController.m
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import "CollectionViewController.h"

#import "CollectionViewCell.h"
#import <YYModel/YYModel.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionArray;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCellID"];
    [self.view addSubview:self.collectionView];
    [self loadData];
}

- (void)setType:(CollectionViewType)type {
    _type = type;
    
    switch (type) {
        case CollectionViewType_Delete:
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
        case CollectionViewType_MoreDelete:
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
        case CollectionViewType_Drag:
        {
            self.navigationItem.title = @"拖动";
        }
            break;
            
        default:
            break;
    }
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"textJson" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = [json objectForKey:@"data"];
    for (NSDictionary *dict in dataArray) {
        PhotoModel *model = [PhotoModel yy_modelWithDictionary:dict];
        model.isSelected = NO;
        [self.collectionArray addObject:model];
    }
}

- (void)deleteAction {
    if (self.type == CollectionViewType_Delete) {
        if ([self.selectIndexPath length] == 0) {
            NSLog(@"请选择要删除的图片");
            return;
        }
        PhotoModel *itemModel = [self.collectionArray objectAtIndex:self.selectIndexPath.row];
        [self.collectionArray removeObject:itemModel];
        [self.collectionView deleteItemsAtIndexPaths:@[self.selectIndexPath]];
        self.selectIndexPath = NULL;
    } else if (self.type == CollectionViewType_MoreDelete) {
        for (int i = 0; i < self.collectionArray.count; i++) {
            PhotoModel *itemModel = self.collectionArray[i];
            if (itemModel.isSelected == YES) {
                [self.collectionArray removeObject:itemModel];
                // 当有元素被删除的时候i的值回退1 从而抵消因删除元素而导致的元素下标位移的变化
                i--;
            }
        }
        [self.collectionView reloadData];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    PhotoModel *itemModel = self.collectionArray[indexPath.row];
    [cell setCellWithModel:itemModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == CollectionViewType_Drag) return;
    
    PhotoModel *itemModel = self.collectionArray[indexPath.row];
    itemModel.isSelected = !itemModel.isSelected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    if (self.type == CollectionViewType_Delete) {
        // 取消之前选中的 indexPath
        if ([self.selectIndexPath length] == 2) {
            PhotoModel *itemModel = [self.collectionArray objectAtIndex:self.selectIndexPath.row];
            itemModel.isSelected = !itemModel.isSelected;
            [collectionView reloadItemsAtIndexPaths:@[self.selectIndexPath]];
        }
        // 记录当前选择的 indexPath
        self.selectIndexPath = indexPath;
    } else if (self.type == CollectionViewType_MoreDelete) {
        
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    id obj = [self.collectionArray objectAtIndex:sourceIndexPath.item];
    [self.collectionArray removeObject:obj];
    [self.collectionArray insertObject:obj atIndex:destinationIndexPath.item];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    if (@available(iOS 9.0, *)) {
        UIGestureRecognizerState state = longPress.state;
        switch (state) {
            case UIGestureRecognizerStateBegan:{
                CGPoint pressPoint = [longPress locationInView:self.collectionView];
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pressPoint];
                if (!indexPath) {
                    break;
                }
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
                break;
            }
            case UIGestureRecognizerStateChanged:{
                CGPoint pressPoint = [longPress locationInView:self.collectionView];
                [self.collectionView updateInteractiveMovementTargetPosition:pressPoint];
                break;
            }
            case UIGestureRecognizerStateEnded:{
                [self.collectionView endInteractiveMovement];
                break;
            }
            default:
                [self.collectionView cancelInteractiveMovement];
                break;
        }
    }
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-32.0)/3.0, (SCREEN_WIDTH-32.0)/3.0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}

- (NSMutableArray *)collectionArray {
    if (!_collectionArray) {
        _collectionArray = [[NSMutableArray alloc] init];
    }
    return _collectionArray;
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
