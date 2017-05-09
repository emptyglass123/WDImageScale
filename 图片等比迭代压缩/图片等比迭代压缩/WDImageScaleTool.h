//
//  WDImageScaleTool.h
//  图片等比迭代压缩
//
//  Created by 朱辉 on 2017/5/9.
//  Copyright © 2017年 WD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDImageScaleTool : UIImage
/**
 三级图片等比(尺寸)压缩
 @第一级 : 转格式 降品质
 @第二级 : 尺寸压缩
 @第三级 : 迭代压缩
 
 @param beginImage 要压缩的原始图片
 @param maxSize 最大尺寸
 @param maxByte 最大字节数 单位KB
 @return 处理后的图片
 */
-(UIImage *)WDImageFormatAndScaleRecycleCompressionWithImage:(UIImage *)beginImage maxSize:(CGSize)maxSize maxDataByte:(CGFloat)maxByte;


/**
 尺寸压缩(size)
 
 @param targetSize 最大尺寸
 @param maxByte 最大字节 单位KB
 @param sourceImage 源图
 @return 处理后的Image
 */
- (UIImage*)WDRecycleScaleImageForMaxSize:(CGSize)targetSize maxDataByte:(CGFloat)maxByte withSourceImage:(UIImage *)sourceImage;

@end
