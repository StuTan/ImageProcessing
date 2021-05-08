//
//  OpenShare+Alipay.h
//  openshare
//
//  Created by StuTan on 2021/4/30.
//

#import "OpenShare.h"

@interface OpenShare (Alipay)
+(void)connectAlipay;
+(void)AliPay:(NSString*)link Success:(paySuccess)success Fail:(payFail)fail;
@end
