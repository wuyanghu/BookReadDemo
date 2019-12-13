//
//  CoreTextLinkData.m
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/26.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import "CoreTextLinkModel.h"

@implementation CoreTextLinkModel

+ (CoreTextLinkModel *)createLinkModel:(NSString *)title url:(NSString *)url range:(CFRange)range{
    CoreTextLinkModel * linkModel = [CoreTextLinkModel new];
    linkModel.title = title;
    linkModel.url   = url;
    linkModel.range = NSMakeRange(range.location, range.length);
    linkModel.cfrange = range;
    return linkModel;
}

@end
