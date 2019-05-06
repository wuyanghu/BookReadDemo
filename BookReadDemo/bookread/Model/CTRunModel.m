//
//  CTRunModel.m
//  BookReadDemo
//
//  Created by ruantong on 2019/5/5.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "CTRunModel.h"
#import "CTLineModel.h"
#import <UIKit/UIKit.h>
#import "CoreTextConstant.h"

@interface CTRunModel ()
{
    BOOL _didCalculateMetrics;
    CGFloat _offset; // x distance from line origin
}
@property (nonatomic, weak, readonly) CTLineModel *textLine;
@property (nonatomic, assign, readwrite) CTRunRef runRef;
@property (nonatomic, readwrite) CGFloat ascent;
@property (nonatomic, readwrite) CGFloat descent;
@property (nonatomic, readwrite) CGFloat leading;
@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, assign) NSInteger numberOfGlyphs;
@property (nonatomic, readwrite) NSDictionary *attributes;
@property (nonatomic, assign) const CGPoint *glyphPositionPoints;//指向一个CTRun内point的指针

@end

@implementation CTRunModel

- (instancetype)initWithRunRef:(CTRunRef)runRef textLine:(CTLineModel *)textLine{
    if (self = [super init]) {
        _textLine = textLine;
        self.runRef = runRef;
    }
    return self;
}

- (CGRect)frameOfGlyphAtIndex:(NSInteger)index{
    
    if (!_didCalculateMetrics) {
        [self calculateMetrics];
    }
    
    if (!_glyphPositionPoints) {
        _glyphPositionPoints = CTRunGetPositionsPtr(_runRef);//glyphPositonPoints并没有强持有，不需要释放
    }
    
    if (!_glyphPositionPoints || index < 0 || index > self.numberOfGlyphs) {
        return CGRectNull;
    }
    
    NSDictionary *attributes = self.attributes;
    CGFloat baselineOffset = 0;
    CMBadgeTextType badgeType = [attributes[CMTextBadgeTypeAttribute] integerValue];
    
    if (badgeType != CMBadgeTextTypeNone) {
        baselineOffset =  [attributes[NSBaselineOffsetAttributeName] floatValue];
    }
    CGPoint glyphPosition = _glyphPositionPoints[index];
    
    CGRect rect = CGRectMake(_textLine.baselineOrigin.x + glyphPosition.x, _textLine.baselineOrigin.y - _ascent - baselineOffset, _offset + _width - glyphPosition.x, _ascent + _descent);
    
    if (index < self.numberOfGlyphs-1)
    {
        rect.size.width = _glyphPositionPoints[index+1].x - glyphPosition.x;
    }
    return rect;
    
}

#pragma mark - drawing
- (void)drawInContext:(CGContextRef)context
{
    if (!_runRef || !context)
    {
        return;
    }
    
    CGAffineTransform textMatrix = CTRunGetTextMatrix(_runRef);
    
    if (CGAffineTransformIsIdentity(textMatrix))
    {
        CTRunDraw(_runRef, context, CFRangeMake(0, 0));
    }
    else
    {
        CGPoint pos = CGContextGetTextPosition(context);
        
        // set tx and ty to current text pos according to docs
        textMatrix.tx = pos.x;
        textMatrix.ty = pos.y;
        
        CGContextSetTextMatrix(context, textMatrix);
        
        CTRunDraw(_runRef, context, CFRangeMake(0, 0));
        
        // restore identity
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        
    }
}

#pragma mark - calculations
- (void)calculateMetrics
{
    // calculate metrics
    @synchronized(self)
    {
        if (!_didCalculateMetrics)
        {
            _width = (CGFloat)CTRunGetTypographicBounds((CTRunRef)_runRef, CFRangeMake(0, 0), &_ascent, &_descent, &_leading);
            _didCalculateMetrics = YES;
        }
    }
}

#pragma mark properties

- (NSInteger)numberOfGlyphs{
    if (_numberOfGlyphs == 0) {
        _numberOfGlyphs = CTRunGetGlyphCount(_runRef);
    }
    return _numberOfGlyphs;
}

- (NSDictionary *)attributes{
    if (!_attributes) {
        _attributes = (__bridge NSDictionary *)CTRunGetAttributes(_runRef);
    }
    return _attributes;
}

- (void)setRunRef:(CTRunRef)ctRun{
    if (_runRef != ctRun) {
        if (ctRun) CFRetain(ctRun);
        if (_runRef) CFRelease(_runRef);
        _runRef = ctRun;
    }
}

- (CGFloat)width
{
    if (!_didCalculateMetrics)
    {
        [self calculateMetrics];
    }
    
    return _width;
}

- (CGFloat)ascent
{
    if (!_didCalculateMetrics)
    {
        [self calculateMetrics];
    }
    
    return _ascent;
}

- (CGFloat)descent
{
    if (!_didCalculateMetrics)
    {
        [self calculateMetrics];
    }
    
    return _descent;
}

- (CGFloat)leading
{
    if (!_didCalculateMetrics)
    {
        [self calculateMetrics];
    }
    
    return _leading;
}


@end
