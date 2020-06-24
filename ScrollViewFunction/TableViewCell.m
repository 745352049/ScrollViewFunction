//
//  TableViewCell.m
//  ScrollViewFunction
//
//  Created by iOS开发 on 2020/6/23.
//  Copyright © 2020 陕西文投教育科技有限公司. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithModel:(PhotoModel *)model {
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:model.galary_item_path]];
    self.itemLabel.text = model.galary_item_path;
    self.isSelectImageView.image = [UIImage imageNamed:model.isSelected ? @"select" : @"normal"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
