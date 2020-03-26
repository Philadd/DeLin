//
//  netWorkManagerManager.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/21.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "NetWorkManager.h"
#import <netdb.h>

///@brife 可判断的数据帧类型数量
#define LEN 10

static dispatch_once_t oneToken;

static NetWorkManager *_netWorkManager = nil;
static dispatch_once_t oneToken;


//用来判断手机与设备是否有信息交互的心跳，有交互后重新清零，心跳达到60就发送心跳帧
static int noUserInteractionHeartbeat = 0;

@implementation NetWorkManager
{
    UInt8 _frameCount; //帧计数器
    dispatch_queue_t _queue;//设备通信线程
    
    dispatch_semaphore_t _sendSignal;//设备通信锁
    
    NSMutableArray *_allMsg;//收到的帧处理沾包分帧后放入该数组
    
    dispatch_source_t _noUserInteractionHeartbeatTimer;//心跳时钟
    
    //测试用代码
    dispatch_source_t _testSendTimer;//测试时钟
}

+ (instancetype)shareNetWorkManager{
    if (_netWorkManager == nil) {
        _netWorkManager = [[self alloc] init];
    }
    return _netWorkManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    dispatch_once(&oneToken, ^{
        if (_netWorkManager == nil) {
            _netWorkManager = [super allocWithZone:zone];
        }
    });
    return _netWorkManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _queue = dispatch_queue_create("com.thingcom.queue", DISPATCH_QUEUE_SERIAL);
        if (!_recivedData68) {
            _recivedData68 = [[NSMutableArray alloc] init];
        }
        _frameCount = 0;
        _myTimer = [self myTimer];
        
    }
    return self;
}

+ (void)destroyInstance{
    _netWorkManager = nil;
    oneToken = 0l;
}

#pragma mark - Lazy load
- (NSTimer *)myTimer{
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(getTemp) userInfo:nil repeats:YES];
        [_myTimer setFireDate:[NSDate distantFuture]];
    }
    return _myTimer;
}

#pragma mark - Actions

- (void)getMainDeviceMsg{
    UInt8 controlCode = 0x01;
    NSArray *data = @[@0x00,@0x01,@0x00,@0x00];
    [self sendData68With:controlCode data:data failuer:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(getMainDeviceMsg) withObject:nil afterDelay:3.f];
    });
    
}
#pragma mark - 帧的发送

//帧的发送
- (void)send:(NSMutableArray *)msg withTag:(NSUInteger)tag
{
//    if ([GizManager shareInstance].device.netStatus == GizDeviceControlled)
//    {
//        NSUInteger len = msg.count;
//        UInt8 sendBuffer[len];
//        for (int i = 0; i < len; i++)
//        {
//            sendBuffer[i] = [[msg objectAtIndex:i] unsignedCharValue];
//        }
//
//        NSData *sendData = [NSData dataWithBytes:sendBuffer length:len];
//        NSLog(@"发送一条帧： %@",sendData);
//        _frameCount++;
//        //透传至机智云
//        NSDictionary *transparentData = @{@"binary":sendData};
//        [[GizManager shareInstance] sendTransparentDataByGizWifiSDK:transparentData];
//    }
//    else
//    {
//        NSLog(@"wifi未连接");
//    }
    NSUInteger len = msg.count;
    UInt8 sendBuffer[len];
    for (int i = 0; i < len; i++)
    {
        sendBuffer[i] = [[msg objectAtIndex:i] unsignedCharValue];
    }
    
    NSData *sendData = [NSData dataWithBytes:sendBuffer length:len];
    NSLog(@"发送一条帧： %@",sendData);
    _frameCount++;
    //透传至机智云
    NSDictionary *transparentData = @{@"binary":sendData};
    [[GizManager shareInstance] sendTransparentDataByGizWifiSDK:transparentData];
}

/*
 *发送帧组成模版
 */
- (void)sendData68With:(UInt8)controlCode data:(NSArray *)data failuer:(nullable void(^)(void))failure{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(self->_queue, ^{
            
            noUserInteractionHeartbeat = 0;//心跳清零
            
            NSMutableArray *data68 = [[NSMutableArray alloc] init];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x68]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:controlCode]];
            
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            [data68 addObject:[NSNumber numberWithUnsignedInteger:0x00]];
            
            [data68 addObject:[NSNumber numberWithInt:self->_frameCount]];
            [data68 addObject:[NSNumber numberWithInteger:data.count]];
            [data68 addObjectsFromArray:data];
            [data68 addObject:[NSNumber numberWithUnsignedChar:[NSObject getCS:data68]]];
            [data68 addObject:[NSNumber numberWithUnsignedChar:0x16]];
            
            [self send:data68 withTag:100];//机智云发送
            
        });
    });
}


#pragma mark - Frame68 接收处理

- (void)checkOutFrame:(NSData *)data{
    if (_allMsg && data) {
        [_allMsg removeAllObjects];
        
        //把读到的数据复制一份
        NSData *recvBuffer = [NSData dataWithData:data];
        NSUInteger recvLen = [recvBuffer length];
        //NSLog(@"%lu",(unsigned long)recvLen);
        UInt8 *recv = (UInt8 *)[recvBuffer bytes];
        if (recvLen > 1000) {
            return;
        }
        //把接收到的数据存放在recvData数组中
        NSMutableArray *recvData = [[NSMutableArray alloc] init];
        NSUInteger j = 0;
        while (j < recvLen) {
            [recvData addObject:[NSNumber numberWithUnsignedChar:recv[j]]];
            j++;
        }
        //每从recvData中取出正确的一帧就删除recvData中这段数据
        NSInteger i = 0;
        while (i < recvData.count) {
            //验证68帧的准确性
            //数据缓冲区中数据的长度
            NSUInteger recvDataLen = recvData.count;
            
            //数据不够一条完整的帧
            if (recvDataLen < 10) {
                return;
            }
            
            //1 帧头匹配
            if ([[recvData objectAtIndex:i] unsignedCharValue] == 0x68){
                //22,23位是数据域长度
                if ((i+7)>=recvLen) {
                    i++;
                    break;
                }
                int dataLen = [[recvData objectAtIndex:i+7] unsignedCharValue];
                
                NSInteger end = i + 7 + dataLen + 2;//帧尾所在位置
                //2.帧尾匹配
                if ([recvData count] > end) {
                    if ([[recvData objectAtIndex:end] unsignedIntegerValue] == 0x16) {
                        //计算CS位 8＋数据域长度 ＝ 校验位前数据长度
                        UInt8 cs = 0x00;
                        for (int j = 0; j < 8 + dataLen; j++)
                        {
                            cs += [[recvData objectAtIndex:i+j] unsignedCharValue];
                        }
                        
                        //3.校验位匹配
                        if (cs == [[recvData objectAtIndex:end - 1] unsignedCharValue])
                        {
                            //存储这个帧命令
                            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:8+dataLen+2];
                            for (int k = 0; k < 8+dataLen+2; k++)
                            {
                                //每次删后，后面位自动前移
                                [array addObject:[recvData objectAtIndex:i]];
                                //NSLog(@"%@", array);
                                [recvData removeObjectAtIndex:i];
                            }
                            [_allMsg addObject:array];
                            continue;
                        }
                    }else{
                        NSLog(@"计算的字节长度不对");
                    }
                }
            }
            i++;
        }
        
    }
    [self distributeFrame];
}

- (void)distributeFrame{
    if (!_allMsg) {
        return;
    }
    //把每条数据分别处理
    for (int i = 0; i < _allMsg.count; i++) {
        //取出一帧
        NSMutableArray *data = [[NSMutableArray alloc] init];
        [data addObjectsFromArray:_allMsg[i]];
        //NSLog(@"沾包解出的帧%d：%@",i,data);
        
        [self handle68Message:data];
    }
}

- (void)handle68Message:(NSArray *)data
{
    //68帧格式判断
    if (![self frameIsRight:data])
    {
        //68帧数据错误
        return;
    }
    if (_recivedData68)
    {
        [_recivedData68 removeAllObjects];
        [_recivedData68 addObjectsFromArray:data];
        self.msg68Type = [self checkOutMsgType:data];
        self.frame68Type = [self checkOutFrameType:data];
        /*
         getMainDeviceMsg.... 0x00 获取主界面基本信息
         getHome.... 0x01 设置Home
         getStop,.... 0x02 设置Stop
         setCurrentTime,.... 0x03 设置机器当前时间
         getWorkTime,.... 0x04 设置割草机工作时间
         getWorkArea,.... 0x05 设置割草机工作面积
         inputPINCode,.... 0x06 APP输入割草机PIN码
         reSetPINCode,.... 0x07 修改割草机PIN码
         getLanguage,.... 0x08 读取割草机语言
         otherMsgType.... 0x09 获取主界面基本信息
         */
        switch (self.frame68Type) {
            case readReplyFrame:
            {
                /*[_recivedData68[12].... 电量
                 [_recivedData68[13].... 机器状态
                 [_recivedData68[14].... 故障信息
                 [_recivedData68[15]，[_recivedData68[16].... 下一次割草时间
                 [_recivedData68[17] [_recivedData68[18].... 割草面积
                 */
                if (self.msg68Type == getMainDeviceMsg) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    });
                    resendCount = 0;
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
                    NSNumber *robotPower = _recivedData68[12];
                    NSNumber *robotState = _recivedData68[13];
                    NSNumber *robotError = _recivedData68[14];
                    NSNumber *nextWorktime = [NSNumber numberWithInt:[_recivedData68[15] intValue] * 256 + [_recivedData68[16] intValue]];
                    NSNumber *nextWorkarea = [NSNumber numberWithInt:[_recivedData68[17] intValue] * 256 + [_recivedData68[18] intValue]];
                    
                    [dataDic setObject:robotPower forKey:@"robotPower"];
                    [dataDic setObject:robotState forKey:@"robotState"];
                    [dataDic setObject:robotError forKey:@"robotError"];
                    [dataDic setObject:nextWorktime forKey:@"nextWorktime"];
                    [dataDic setObject:nextWorkarea forKey:@"nextWorkarea"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getMainDeviceMsg" object:nil userInfo:dataDic];
                    
                }else if (self.msg68Type == getWorkTime){
                    
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                    NSNumber *monHour = _recivedData68[12];
                    NSNumber *tueHour = _recivedData68[13];
                    NSNumber *wedHour = _recivedData68[14];
                    NSNumber *thuHour = _recivedData68[15];
                    NSNumber *friHour = _recivedData68[16];
                    NSNumber *satHour = _recivedData68[17];
                    NSNumber *sunHour = _recivedData68[18];
                    NSNumber *monMinute = _recivedData68[19];
                    NSNumber *tueMinute = _recivedData68[20];
                    NSNumber *wedMinute = _recivedData68[21];
                    NSNumber *thuMinute = _recivedData68[22];
                    NSNumber *friMinute = _recivedData68[23];
                    NSNumber *satMinute = _recivedData68[24];
                    NSNumber *sunMinute = _recivedData68[25];
                    NSNumber *monState = _recivedData68[26];
                    NSNumber *tueState = _recivedData68[27];
                    NSNumber *wedState = _recivedData68[28];
                    NSNumber *thuState = _recivedData68[29];
                    NSNumber *friState = _recivedData68[30];
                    NSNumber *satState = _recivedData68[31];
                    NSNumber *sunState = _recivedData68[32];
                    [dataDic setObject:monHour forKey:@"monHour"];
                    [dataDic setObject:tueHour forKey:@"tueHour"];
                    [dataDic setObject:wedHour forKey:@"wedHour"];
                    [dataDic setObject:thuHour forKey:@"thuHour"];
                    [dataDic setObject:friHour forKey:@"friHour"];
                    [dataDic setObject:satHour forKey:@"satHour"];
                    [dataDic setObject:sunHour forKey:@"sunHour"];
                    [dataDic setObject:monMinute forKey:@"monMinute"];
                    [dataDic setObject:tueMinute forKey:@"tueMinute"];
                    [dataDic setObject:wedMinute forKey:@"wedMinute"];
                    [dataDic setObject:thuMinute forKey:@"thuMinute"];
                    [dataDic setObject:friMinute forKey:@"friMinute"];
                    [dataDic setObject:satMinute forKey:@"satMinute"];
                    [dataDic setObject:sunMinute forKey:@"sunMinute"];
                    [dataDic setObject:monState forKey:@"monState"];
                    [dataDic setObject:tueState forKey:@"tueState"];
                    [dataDic setObject:wedState forKey:@"wedState"];
                    [dataDic setObject:thuState forKey:@"thuState"];
                    [dataDic setObject:friState forKey:@"friState"];
                    [dataDic setObject:satState forKey:@"satState"];
                    [dataDic setObject:sunState forKey:@"sunState"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recieveWorkingTime" object:nil userInfo:dataDic];
                    
                }else if (self.msg68Type == getWorkArea){
                    
                    NSNumber *workArea = [NSNumber numberWithInt:[_recivedData68[12] intValue] * 256 + [_recivedData68[13] intValue]];
                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                    [dataDic setObject:workArea forKey:@"workArea"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"recieveWorkArea" object:nil userInfo:dataDic];
                    
                }else if (self.msg68Type == getLanguage){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    });
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLanguage" object:nil userInfo:nil];
                }
                
            }
                break;
            case writeReplyFrame:
            {
                if (self.msg68Type == getHome){
                    resendCount = 0;
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getHome" object:nil userInfo:nil];
                    
                }else if (self.msg68Type == getStop){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getStop" object:nil userInfo:nil];
                }else if (self.msg68Type == setCurrentTime){
                    resendCount = 0;
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setCurrentTime" object:nil userInfo:nil];
                    
                }else if (self.msg68Type == getWorkTime){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getWorkTime" object:nil userInfo:nil];
                    
                }else if (self.msg68Type == getWorkArea){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"setWorkArea" object:nil userInfo:nil];
                    
                }else if (self.msg68Type == inputPINCode){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    
                }else if (self.msg68Type == reSetPINCode){
                    
                    if ([_recivedData68[12] unsignedIntegerValue] == 1) {
                        [NSObject showHudTipStr:LocalString(@"Set up successfully")];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetPINCode" object:nil userInfo:nil];
                }else if (self.msg68Type == getLanguage){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLanguage" object:nil userInfo:nil];
                }
                
                
            }
                break;
                
            default:
                break;
                
        }
        
        
    }
    
}

-(BOOL)frameIsRight:(NSArray *)data
{
    NSUInteger count = data.count;
    UInt8 front = [data[0] unsignedCharValue];
    UInt8 end3 = [data[count-1] unsignedCharValue];
    
    //判断帧头帧尾
    if (front != 0x68 || end3 != 0x16)
    {
        NSLog(@"帧头帧尾错误");
        return NO;
    }
    //判断cs位
    UInt8 csTemp = 0x00;
    for (int i = 0; i < count - 2; i++)
    {
        csTemp += [data[i] unsignedCharValue];
    }
    if (csTemp != [data[count-2] unsignedCharValue])
    {
        NSLog(@"校验错误");
        return NO;
    }
    return YES;
}

//判断是什么信息
- (MsgType68)checkOutMsgType:(NSArray *)data{
    unsigned char dataType;
    
    unsigned char type[LEN] = {
        0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09
    };
    /*
     getMainDeviceMsg.... 0x00 获取主界面基本信息
     getHome.... 0x01 设置Home
     getStop,.... 0x02 设置Stop
     setCurrentTime,.... 0x03 设置机器当前时间
     getWorkTime,.... 0x04 设置割草机工作时间
     getWorkArea,.... 0x05 设置割草机工作面积
     inputPINCode,.... 0x06 APP输入割草机PIN码
     reSetPINCode,.... 0x07 修改割草机PIN码
     getLanguage,.... 0x08 读取割草机语言
     otherMsgType.... 0x09 获取主界面基本信息
     */
    dataType = [data[10] unsignedIntegerValue];
    //NSLog(@"%d",dataType);
    
    MsgType68 returnVal = otherMsgType;
    
    for (int i = 0; i < LEN; i++) {
        if (dataType == type[i]) {
            switch (i) {
                case 0:
                    returnVal = getMainDeviceMsg;
                    break;
                    
                case 1:
                    returnVal = getHome;
                    break;
                    
                case 2:
                    returnVal = getStop;
                    break;
                    
                case 3:
                    returnVal = setCurrentTime;
                    break;
                    
                case 4:
                    returnVal = getWorkTime;
                    break;
                    
                case 5:
                    returnVal = getWorkArea;
                    break;
                    
                case 6:
                    returnVal = inputPINCode;
                    break;
                    
                case 7:
                    returnVal = reSetPINCode;
                    break;
                    
                case 8:
                    returnVal = getLanguage;
                    break;
                    
                default:
                    returnVal = otherMsgType;
                    break;
            }
        }
    }
    return returnVal;
}

//判断是命令帧还是回复帧
- (FrameType68)checkOutFrameType:(NSArray *)data{
    unsigned char dataType;
    
    unsigned char type[2] = {
        0x00,0x01
    };
    //命令标识
    dataType = [data[11] unsignedIntegerValue];
    //NSLog(@"%d",dataType);
    
    FrameType68 returnVal = otherFrameType;
    
    for (int i = 0; i < 2; i++) {
        if (dataType == type[i]) {
            switch (i) {
                case 0:
                    returnVal = readReplyFrame;
                    break;
                    
                case 1:
                    returnVal = writeReplyFrame;
                    break;
                    
                default:
                    returnVal = otherFrameType;
                    break;
            }
        }
    }
    return returnVal;
}


@end
