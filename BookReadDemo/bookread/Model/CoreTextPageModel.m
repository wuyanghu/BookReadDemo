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
        CGRect lineFrame = [self getLineFrame:&ascent descent:&descent lineRef:lineRef origin:origins[i]];//这个变量可放置LineModel内部计算
        
        CFRange cfRange = [self rangeFromLineRef:lineRef];
        NSRange lineRange = NSMakeRange(cfRange.location, cfRange.length);
        CTLineModel * lineModel = [CTLineModel createLineModel:ascent cfAttributedString:cfAttributedString cfRange:&cfRange descent:descent lineFrame:&lineFrame lineRange:&lineRange lineRef:lineRef maxIndex:maxIndex];
        [self.lineArr addObject:lineModel];
        
    }
}

#pragma mark - private method

- (CGRect)getLineFrame:(CGFloat *)ascent descent:(CGFloat *)descent lineRef:(CTLineRef)lineRef origin:(CGPoint)origin {
    
    CGFloat leading;
    CGFloat width = CTLineGetTypographicBounds(lineRef, ascent, descent, &leading);
    CGFloat height = *ascent + *descent;
    
    CGFloat originx = origin.x + CGRectGetMinX([self getDrawRect]);
    CGFloat originy = origin.y + CGRectGetMinY([self getDrawRect]) - *descent;
    
    return CGRectApplyAffineTransform(CGRectMake(originx, originy, width, height),[self transform]);
    
}

- (CGAffineTransform)transform
{
    CTFrameConfigManager * configManager = [CTFrameConfigManager shareInstance];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, configManager.height);//向上平移
    transform = CGAffineTransformScale(transform, 1.f, -1.f);//x轴旋转180
    return transform;
}

- (CFRange)rangeFromLineRef:(CTLineRef)lineRef{
    return CTLineGetStringRange(lineRef);
}

- (CGRect)getDrawRect{
    CGPathRef path = CTFrameGetPath(_frameRef);
    return CGPathGetBoundingBox(path);
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
+ (CoreTextPageModel *)createPageModel:(CTFrameRef)frameRef content:(NSAttributedString *)content{
    CoreTextPageModel * pageModel = [CoreTextPageModel new];
    pageModel.content = content;
    pageModel.frameRef = frameRef;
    
    return pageModel;
}

@end
