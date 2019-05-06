//
//  CoreTextPageModel.m
//  DataStructureDemo
//
//  Created by ruantong on 2018/11/20.
//  Copyright © 2018 wupeng. All rights reserved.
//

#import "CoreTextPageModel.h"
#import "CTFrameConfigManager.h"
#import "CoreTextConstant.h"

@interface CoreTextPageModel ()

@end

@implementation CoreTextPageModel

- (void)setFrameRef:(CTFrameRef)frameRef{
    if (_frameRef != frameRef) {
        _frameRef = frameRef;
        [self ctFrameGetCtLine:frameRef];
    }
}

- (void)ctFrameGetCtLine:(CTFrameRef)frameRef{
    [self.lineArr removeAllObjects];
    
    CGPathRef path = CTFrameGetPath(frameRef);
    CGRect pathRect = CGPathGetBoundingBox(path);//获取CTFrameRef的CGRect
    
    CFMutableAttributedStringRef cfAttributedString = (__bridge CFMutableAttributedStringRef)(_content);
    CFIndex maxIndex = CFAttributedStringGetLength(cfAttributedString);

    CFArrayRef Lines = CTFrameGetLines(frameRef);//获取frame中CTLineRef数组
    CFIndex lineCount = CFArrayGetCount(Lines);//获取数组Lines中的个数
    
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);

    for (int i = 0; i<lineCount; i++) {
        //获取数组中第一个CTLineRef
        CTLineRef lineRef = CFArrayGetValueAtIndex(Lines, i);
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CGFloat width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        CGFloat height = ascent + descent;
        
        CGPoint origin = origins[i];
        CGFloat originx = origin.x + CGRectGetMinX(pathRect);
        CGFloat originy = origin.y + CGRectGetMinY(pathRect) - descent;
        
        CGRect lineFrame = CGRectMake(originx, originy, width, height);
        lineFrame = CGRectApplyAffineTransform(lineFrame,[self transform]);
        
        CFRange cfRange = CTLineGetStringRange(lineRef);
        NSRange lineRange = NSMakeRange(cfRange.location, cfRange.length);
        CTLineModel * lineModel = [[CTLineModel alloc] initWithLineRef:lineRef];
        lineModel.baseLine = (ascent + descent) /2 - descent;
        lineModel.baselineOrigin = CGPointMake(lineFrame.origin.x, lineFrame.origin.y + ascent);
        lineModel.lineFrame = lineFrame;
        lineModel.textRange = cfRange;
        lineModel.attributedRange = cfRange;
        lineModel.stringRange = lineRange;
        lineModel.selectFrame = lineFrame;
        if (lineRange.location+lineRange.length <= maxIndex) {
            lineModel.attributedString = [(__bridge NSAttributedString *)cfAttributedString attributedSubstringFromRange:lineRange];
            lineModel.lineText =  lineModel.attributedString.string;
        }
        [lineModel buildGlyphRuns];
        [self.lineArr addObject:lineModel];
        
    }
}

- (CGAffineTransform)transform
{
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];

    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, configManager.height);//向上平移
    transform = CGAffineTransformScale(transform, 1.f, -1.f);//x轴旋转180
    return transform;
}

#pragma mark - getter

- (NSMutableArray<CTLineModel *> *)lineArr{
    if (!_lineArr) {
        _lineArr = [[NSMutableArray alloc] init];
    }
    return _lineArr;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

#pragma mark - 简单工厂模式
+ (CoreTextPageModel *)createPageModel:(CTFrameRef)frameRef frameRefRange:(CFRange)frameRefRange path:(CGRect)path content:(NSAttributedString *)content{
    CoreTextPageModel * pageModel = [CoreTextPageModel new];
    pageModel.content = content;
    pageModel.frameRefRange = frameRefRange;
    pageModel.path = path;
    pageModel.frameRef = frameRef;
    
    return pageModel;
}

@end
