//
//  TableViewController.h
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TableViewType) {
    TableViewType_Delete = 0,
    TableViewType_MoreDelete,
    TableViewType_Drag,
    TableViewType_EditDelete,
    TableViewType_EditMoreDelete
};

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UIViewController

@property (nonatomic, assign) TableViewType type;

@end

NS_ASSUME_NONNULL_END
