//
//  TableViewCell.m
//  UDPDemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib
{
    // Initialization code
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 220, 30)];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
