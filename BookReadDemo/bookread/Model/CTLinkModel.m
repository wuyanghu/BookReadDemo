//
//  CoreTextLinkData.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/26.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CTLinkModel.h"

@implementation CTLinkModel

+ (CTLinkModel *)createLinkModel:(NSString *)title url:(NSString *)url range:(CFRange)range{
    CTLinkModel * linkModel = [CTLinkModel new];
    linkModel.title = title;
    linkModel.url   = url;
    linkModel.range = NSMakeRange(range.location, range.length);
    linkModel.cfrange = range;
    return linkModel;
}

@end
