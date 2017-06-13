//
//  ClientViewController.h
//  Socket-TCPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
@interface ClientViewController : UIViewController<AsyncSocketDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    AsyncSocket *serverSocket;
    AsyncSocket *listenSocket;
    AsyncSocket *clientSocket;
    
    UITableView *clientTableView;
    NSMutableArray *clientArray;
    UITextField* messageTextField;
}
@end
