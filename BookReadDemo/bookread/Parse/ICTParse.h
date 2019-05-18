//
//  ICTParse.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITextCTParse <NSObject>

@required
- (NSAttributedString *)parseAttributeContentFromNSDictionary:(NSDictionary*)dict;

@end

@protocol IImageCTParse <NSObject>

- (NSAttributedString *)setImagePositionDelegate:(NSDictionary *)dict;

@end

@protocol IBdgeCTParse <NSObject>

- (void)insertBadgeAttributedElement:(NSDictionary*)dict result:(NSMutableAttributedString *)result contentRange:(CFRange)contentRange;

@end
