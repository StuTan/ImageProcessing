//
//  OpenShare+Weixin.h
//  openshare
//
//  Created by StuTan on 2021/4/30.

#import "OpenShare.h"

@interface OpenShare (Weixin)
/**
 *  https://open.weixin.qq.com 在这里申请
 *
 *  @param appId AppID
 */
+(void)connectWeixinWithAppId:(NSString *)appId miniAppId:(NSString *)miniAppId;
+(BOOL)isWeixinInstalled;

+(void)shareToWeixinSession:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)shareToWeixinTimeline:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)shareToWeixinFavorite:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)WeixinAuth:(NSString*)scope Success:(authSuccess)success Fail:(authFail)fail;
+(void)WeixinPay:(NSString*)link Success:(paySuccess)success Fail:(payFail)fail;
@end
