//
//  CoreTextLinkData.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/26.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTLinkModel : NSObject

@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *url;
@property (assign, nonatomic)NSRange range;
@property (assign, nonatomic)CFRange cfrange;
+ (CTLinkModel *)createLinkModel:(NSString *)title url:(NSString *)url range:(CFRange)range;
@end
