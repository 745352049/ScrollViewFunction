//
//  TableViewCell.h
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDWebImage/SDWebImage.h>
#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectImageView;

- (void)setCellWithModel:(PhotoModel *)model;

@end

NS_ASSUME_NONNULL_END
