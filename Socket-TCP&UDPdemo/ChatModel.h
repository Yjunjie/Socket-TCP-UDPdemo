//
//  ChatModel.h
//  UDPDemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ChatModel : NSObject
// YES mine NO other

@property (nonatomic,assign) BOOL type;

@property (nonatomic,copy) NSString * content;

@property (nonatomic,assign,readonly) CGFloat contentHeight;

@end
