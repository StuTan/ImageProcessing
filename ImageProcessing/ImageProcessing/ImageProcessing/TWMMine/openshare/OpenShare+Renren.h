//
//  OpenShare+Renren.h
//  openshare
//
//   

#import "OpenShare.h"

@interface OpenShare (Renren)
+(void)connectRenrenWithAppId:(NSString *)appId AndAppKey:(NSString*)appKey;
+(BOOL)isRenrenInstalled;

+(void)shareToRenrenSession:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;
+(void)shareToRenrenTimeline:(OSMessage*)msg Success:(shareSuccess)success Fail:(shareFail)fail;

@end
