//
//  CollectionViewCell.h
//  CollectionViewMultiSelect
//
//  Created by 水晶岛 on 2018/6/20.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDWebImage/SDWebImage.h>
#import "PhotoModel.h"

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectImageView;
- (void)setCellWithModel:(PhotoModel *)model;

@end
