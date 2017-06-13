//
//  ViewController.m
//  Socket-UDPdemo
//
//  Created by 🍎应俊杰🍎 doublej on 2017/6/10.
//  Copyright © 2017年 doublej. All rights reserved.

//

#import "ViewController.h"

#define Screen_Width ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height ([UIScreen mainScreen].bounds.size.height)
#import "ViewController.h"
#import "AsyncUdpSocket.h"
#import "ChatModel.h"
#import "TableViewCell.h"

@interface ViewController ()<AsyncUdpSocketDelegate,UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITextField *destIPField;
    __weak IBOutlet UITableView *chatTableView;
    __weak IBOutlet UIView *inputView;
    __weak IBOutlet UITextField *inputField;
    __weak IBOutlet UIButton *sendBt;
    
    // 收发套接字对象
    AsyncUdpSocket * _sendSocket;
    AsyncUdpSocket * _recvSocket;
    
    NSMutableArray * _dataArr;
}

@end

@implementation ViewController
- (void)dealloc
{
    // ARC中 KVO和通知中心必须手动在dealloc中移除观察者
    // 移除观察者身份
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)sendMsg:(UIButton *)sender {
    // 发送消息
    // 发送消息对应的二进制 目标主机 目标主机对应的端口号 超时时间 消息的标签
    // 消息必须发送到接受端绑定的端口之上才能收到数据
    [_sendSocket sendData:[inputField.text dataUsingEncoding:NSUTF8StringEncoding] toHost:destIPField.text port:0x4321 withTimeout:60 tag:100];
    
    ChatModel * m = [[ChatModel alloc] init];
    m.type = YES;
    m.content = inputField.text;
    [_dataArr addObject:m];
    [self refreshUI];
    [self.view endEditing:YES];
}

- (void)refreshUI
{
    [chatTableView reloadData];
    //将聊天内容滚动到最后一行
    [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 监听键盘
    /*
     UIKeyboardWillShowNotification
     UIKeyboardWillHideNotification
     使用通知中心监听键盘即将显示 或者 即将隐藏时的事件
     点击UITextFiled 或者 UITextView时 触发keyboardWillShow方法
     键盘即将消失调用keyboardWillHidden方法
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTap:)];
    [self.view addGestureRecognizer:tap];
    // tableView挡住了
    [self.view bringSubviewToFront:inputView];
    
    [self initSocket];
    
    [chatTableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    // 去掉表格分割线
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    inputField.frame = CGRectMake(10,5, Screen_Width-60, 34);
    inputView.frame  = CGRectMake(0, inputView.frame.origin.y, Screen_Width, 44);
    sendBt.frame     = CGRectMake(Screen_Width-50, 5, 40, 35);

}

- (void)initSocket
{
    _sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    // 绑定一个端口 发数据
    [_sendSocket bindToPort:0x1234 error:nil];
    _recvSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [_recvSocket bindToPort:0x4321 error:nil];
    // 0x1234端口做数据发送  0x4321端口接受数据
    // 开始监听
    [_recvSocket receiveWithTimeout:-1 tag:200];
    // 将聊天内容展示在表格上 自己说的显示在左边 别人说的现在在右边 聊天内容越长Cell高度越高
}

- (void)myTap:(UITapGestureRecognizer *)tap
{
    // 键盘掉下
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    // 通知中心中返回的字典中 UIKeyboardFrameEndUserInfoKey 该KEY对应的值就是键盘的Frame
    // NSLog(@"note is %@",note);
    CGRect rect = [[note userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        // 键盘UIView的纵坐标rect.origin.y
        inputView.frame = CGRectMake(0, rect.origin.y-44, Screen_Width, 44);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)note
{
    [UIView animateWithDuration:0.25 animations:^{
        inputView.frame = CGRectMake(0, Screen_Height-44, Screen_Width, 44);
    }];
}

#pragma mark - AsyncUdpSocketDelegate
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"消息发送成功回调");
}

// 成功接受到数据回调
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    // data发送内容的二进制  tag消息标签 host发送消息的主机IP port发送方对应的端口
    NSString * content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到目标IP%@端口%x说:%@",host,port,content);
    // _recvSocket对象接受完数据后 必须继续监听 否则不能收到数据
    // -1 表示一直等 直到有数据到来
    [_recvSocket receiveWithTimeout:-1 tag:200];
    
    ChatModel * m = [[ChatModel alloc] init];
    m.type = NO;
    m.content = content;
    [_dataArr addObject:m];
    [self refreshUI];
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ChatModel * m = _dataArr[indexPath.row];
    cell.contentLabel.text = m.content;
    if (m.type) {
        cell.contentLabel.frame = CGRectMake(20, 14, Screen_Width-40, m.contentHeight);
        cell.contentLabel.backgroundColor = [UIColor grayColor];
    }else{
        cell.contentLabel.frame = CGRectMake(80, 14, Screen_Width-40, m.contentHeight);
        cell.contentLabel.backgroundColor = [UIColor greenColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatModel * m = _dataArr[indexPath.row];
    return m.contentHeight + 28;
}

@end
