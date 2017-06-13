//
//  ServerViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AsyncSocket.h"


@interface ServerViewController : UIViewController<AsyncSocketDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AsyncSocket *serverSocket;

    UITableView *clientTableView;
    NSMutableArray *clientArray;
    NSMutableArray *socketArray;
}
@end






