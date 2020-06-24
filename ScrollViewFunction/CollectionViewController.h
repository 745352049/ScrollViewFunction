//
//  CollectionViewController.h
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CollectionViewType) {
    CollectionViewType_Delete = 0,
    CollectionViewType_MoreDelete,
    CollectionViewType_Drag
};

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController

@property (nonatomic, assign) CollectionViewType type;

@end

NS_ASSUME_NONNULL_END
