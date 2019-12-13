//
//  CTLineModel.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "CTLineRefModel.h"
#import <UIKit/UIKit.h>
#import "CoreTextConstant.h"

@interface CTLineRefModel ()
{
    CTLineRef _lineRef;
    CGFloat _ascent;
    CGFloat _descent;
    CGFloat _leading;
    CGFloat _width;
    CGFloat _trailingWhitespaceWidth;
    CGFloat _underlineOffset;
    CGFloat _lineHeight;
    CGFloat _firstGlyphPos; // first glyph position for baseline, typically 0.
}
@property (nonatomic, assign, readwrite) CTLineRef lineRef;

@end

@implementation CTLineRefModel

//初始化textline
- (instancetype)initWithLineRef:(CTLineRef)lineRef{
    
    if (self = [super init]) {
        self.lineRef = lineRef;
    }
    return self;
}

- (void)setLineRef:(CTLineRef)ctLine{
    if (_lineRef != ctLine) {
        if (ctLine) CFRetain(ctLine);
        if (_lineRef) CFRelease(_lineRef);
        _lineRef = ctLine;
        if (_lineRef) {
            _width = CTLineGetTypographicBounds(_lineRef, &_ascent, &_descent, &_leading);
            CFRange range = CTLineGetStringRange(_lineRef);
            _stringRange = NSMakeRange(range.location, range.length);
            if (CTLineGetGlyphCount(_lineRef) > 0) {
                CFArrayRef runs = CTLineGetGlyphRuns(_lineRef);
                CTRunRef run = CFArrayGetValueAtIndex(runs, 0);
                CGPoint pos;
                CTRunGetPositions(run, CFRangeMake(0, 1), &pos);
                _firstGlyphPos = pos.x;
            } else {
                _firstGlyphPos = 0;
            }
            _trailingWhitespaceWidth = CTLineGetTrailingWhitespaceWidth(_lineRef);
        }else{
            _width = _ascent = _descent = _leading = _firstGlyphPos = _trailingWhitespaceWidth = 0;
            _stringRange = NSMakeRange(0, 0);
        }
    }
}

- (void)buildGlyphRuns{
    
    CFArrayRef runs = CTLineGetGlyphRuns(_lineRef);//获取lineRef中CTRunRef数组
    CFIndex runCount = CFArrayGetCount(runs);//获取数组runs中的个数
    
    for (int j = 0; j<runCount; j++) {
        CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CGFloat runWidth = (CGFloat)CTRunGetTypographicBounds((CTRunRef)runRef, CFRangeMake(0, 0), &ascent, &descent, &leading);
        CGFloat height = ascent + fabs(descent);
        
        CGPoint *positions = (CGPoint*)CTRunGetPositionsPtr(runRef);
        
        BOOL shouldFreePositions = NO;
        
        if (positions == NULL)
        {
            CFIndex glyphCount = CTRunGetGlyphCount(runRef);
            
            shouldFreePositions = YES;
            
            size_t positionsBufferSize = sizeof(CGPoint) * glyphCount;
            CGPoint *positionsBuffer = malloc(positionsBufferSize);
            CTRunGetPositions(runRef, CFRangeMake(0, 0), positionsBuffer);
            positions = positionsBuffer;
        }
        
        CGPoint runOrigin = positions[0];
        
        if (shouldFreePositions) {
            free(positions);
        }
        
        CGFloat originx = self.lineFrame.origin.x + runOrigin.x;
        CGFloat originy = CGRectGetMaxY(self.lineFrame) - runOrigin.y - height;
        CGRect runFrame = CGRectMake(originx, originy, runWidth, height);
        
        CTRunRefModel * runModel = [[CTRunRefModel alloc] initWithRunRef:runRef textLine:self];
        
        //有角标获取当前line的最小Y和最大height 选中用
        NSDictionary *attributes = runModel.attributes;

        CGFloat lineSpacing = 0;
        
        CTParagraphStyleRef paragraphRef =  (__bridge CFTypeRef)attributes[NSParagraphStyleAttributeName];
        CTParagraphStyleGetValueForSpecifier(paragraphRef, kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(lineSpacing), &lineSpacing);
        
        CMBadgeTextType badgeType = [attributes[CMTextBadgeTypeAttribute] integerValue];
        if (badgeType != CMBadgeTextTypeNone) {
            CGFloat baselineOffset = [attributes[NSBaselineOffsetAttributeName] floatValue];
            runFrame.origin.y -= baselineOffset;
        }
        
        runModel.runFrame = runFrame;
        
        [self.runArr addObject:runModel];
    }
}

#pragma mark - getter

- (NSMutableArray<CTRunRefModel *> *)runArr{
    if (!_runArr) {
        _runArr = [[NSMutableArray alloc] init];
    }
    return _runArr;
}

#pragma mark - static method

+ (CTLineRefModel *)createLineModel:(CGFloat)ascent cfAttributedString:(CFMutableAttributedStringRef)cfAttributedString cfRange:(const CFRange *)cfRange descent:(CGFloat)descent lineFrame:(const CGRect *)lineFrame lineRange:(const NSRange *)lineRange lineRef:(CTLineRef)lineRef maxIndex:(CFIndex)maxIndex {
    CTLineRefModel * lineModel = [[CTLineRefModel alloc] initWithLineRef:lineRef];
    lineModel.baseLine = (ascent + descent) /2 - descent;
    lineModel.baselineOrigin = CGPointMake(lineFrame->origin.x, lineFrame->origin.y + ascent);
    lineModel.lineFrame = *lineFrame;
    lineModel.textRange = *cfRange;
    lineModel.attributedRange = *cfRange;
    lineModel.stringRange = *lineRange;
    lineModel.selectFrame = *lineFrame;
    if (lineRange->location+lineRange->length <= maxIndex) {
        lineModel.attributedString = [(__bridge NSAttributedString *)cfAttributedString attributedSubstringFromRange:*lineRange];
        lineModel.lineText =  lineModel.attributedString.string;
    }
    [lineModel buildGlyphRuns];
    return lineModel;
}

@end
