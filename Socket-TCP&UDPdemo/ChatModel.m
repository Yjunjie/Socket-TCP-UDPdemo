//
//  ChatModel.m
//  UDPDemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import "ChatModel.h"
#import <UIKit/UIKit.h>
@implementation ChatModel

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentHeight = [_content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(220, 2000)].height;
}

@end
