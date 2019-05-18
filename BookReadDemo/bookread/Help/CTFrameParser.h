//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by 夏远全 on 16/12/25.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTModel;

@interface CTFrameParser : NSObject
- (void)parseBookReadFile:(NSString *)path;
- (CTModel *)getCTModel;
@end
