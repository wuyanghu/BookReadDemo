//
//  CTRunModel.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@class CTLineModel;
NS_ASSUME_NONNULL_BEGIN

@interface CTRunModel : NSObject

/**
 The ascent (height above the baseline) of the receiver
 */
@property (nonatomic, readonly) CGFloat ascent;

/**
 The descent (height below the baseline) of the receiver
 */
@property (nonatomic, readonly) CGFloat descent;

/**
 The leading (additional space above the ascent) of the receiver
 */
@property (nonatomic, readonly) CGFloat leading;
@property (nonatomic, readonly) NSDictionary *attributes;
@property (nonatomic, assign) CGRect runFrame;

- (instancetype)initWithRunRef:(CTRunRef)runRef textLine:(CTLineModel *)textLine;
- (void)drawInContext:(CGContextRef)context;
- (CGRect)frameOfGlyphAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
