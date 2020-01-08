//
//  CTLineModel.h
//  BookReadDemo
//
//  Created by ruantong on 2019/5/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CTRunRefModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTLineRefModel : NSObject

@property (nonatomic, assign) NSRange stringRange; // string range

@property (nonatomic, assign) CGPoint baselineOrigin; // baseline position

@property (nonatomic, assign) CGFloat ascent; // needs to be modifiable

@property (nonatomic, readonly) CGFloat descent;  // line descent

@property (nonatomic, readonly) CGFloat width ; // line width

@property (nonatomic, readonly) CGFloat leading; // line leading

@property (nonatomic, readonly) CGFloat trailingWhitespaceWidth;

@property (nonatomic, readonly) CGFloat underlineOffset;

@property (nonatomic, readonly) CGFloat lineHeight;

@property (nonatomic, assign) CGFloat baseLine;

@property (nonatomic, assign) CGRect lineFrame;

@property (nonatomic, assign) CGRect selectFrame;

@property (nonatomic, copy) NSString *lineText;

@property (nonatomic, assign) CFRange textRange;

@property (nonatomic, assign) CFRange attributedRange;

@property (nonatomic,strong) NSMutableArray<CTRunRefModel *> * runArr;
@property (nonatomic, copy) NSAttributedString *attributedString;
//初始化textline
- (instancetype)initWithLineRef:(CTLineRef)lineRef;
- (void)buildGlyphRuns;

+ (CTLineRefModel *)createLineModel:(CGFloat)ascent cfAttributedString:(CFMutableAttributedStringRef)cfAttributedString cfRange:(const CFRange *)cfRange descent:(CGFloat)descent lineFrame:(const CGRect *)lineFrame lineRange:(const NSRange *)lineRange lineRef:(CTLineRef)lineRef maxIndex:(CFIndex)maxIndex;
@end

NS_ASSUME_NONNULL_END