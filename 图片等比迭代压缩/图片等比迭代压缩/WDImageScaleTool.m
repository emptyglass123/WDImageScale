//
//  WDImageScaleTool.m
//  图片等比迭代压缩
//
//  Created by 朱辉 on 2017/5/9.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "WDImageScaleTool.h"

@implementation WDImageScaleTool


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
-(UIImage *)WDImageFormatAndScaleRecycleCompressionWithImage:(UIImage *)beginImage maxSize:(CGSize)maxSize maxDataByte:(CGFloat)maxByte
{
    UIImage *image = beginImage;
    NSData *beginImageData;
    beginImageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"选择的图片的大小 === %luKB",(unsigned long)UIImageJPEGRepresentation(image, 1).length/1000);

    // 初始图片过大需要处理
    if(beginImageData.length/1000 > maxByte)
    {
        // 1.先进行格式/品质处理,如仍大于150KB  2. 进行等比缩放
        NSData *imageData = UIImageJPEGRepresentation(image,0.6);
        UIImage *newImage = [UIImage imageWithData:imageData];
        
        unsigned long imageData_Ya = imageData.length/1000 ;
        if (imageData_Ya > maxByte) {
            //裁剪
            
            CGSize scaleSize = maxSize;
            return [self WDRecycleScaleImageForMaxSize:scaleSize maxDataByte:maxByte withSourceImage:newImage ];
            
        }else{
            return newImage;
        }

    }else{
    

        return beginImage;
    }
    
}


/**
 尺寸压缩(size)

 @param targetSize 最大尺寸
 @param maxByte 最大字节 单位KB
 @param sourceImage 源图
 @return 处理后的Image
 */
- (UIImage*)WDRecycleScaleImageForMaxSize:(CGSize)targetSize maxDataByte:(CGFloat)maxByte withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    unsigned long imageData_recycle;
    CGSize imageSize = sourceImage.size;
    
    //原图宽高
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    //压缩后宽高 边界上限
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //处理后的宽高
    CGFloat scaledWidth ;
    CGFloat scaledHeight ;
    float rato;
    float widthRatio = width/targetWidth;
    float heighRatio = height/targetHeight;
    // 原图宽高均超限制
    if (width > targetWidth && height > targetHeight) {
        
        if (widthRatio >= heighRatio) {
            
            // 宽:600 高:
            rato = targetWidth/width;
            
        }else{
            
            // 高:800
            rato = targetHeight/height;
        }
        // 原图只有宽超限制
    }else if (width >targetWidth && height <= targetHeight){
        
        // 宽:600 高:
        rato = targetWidth/width;
        
        // 原图只有高超限制
    }else if(height > targetHeight && width <= targetWidth){
        
        // 高:800
        rato = targetHeight/height;
        
        // 原图宽高均未超限制
    }else{
        
        rato = 1.0;
        
    }
    
    scaledHeight = floor(height*rato);
    scaledWidth = floor(width*rato);
    
    do {
        CGSize beginSize = CGSizeMake(scaledWidth, scaledHeight);
        UIGraphicsBeginImageContext(beginSize); // this will crop
        CGRect thumbnailRect = CGRectZero;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width= scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect blendMode:kCGBlendModePlusDarker alpha:1.0];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        if(newImage == nil)
            NSLog(@"could not scale image");
        UIGraphicsEndImageContext();
        
        // 图片压缩后体积检查
        NSData *imageData_afterScale = UIImageJPEGRepresentation(newImage, 0.6) ;
        imageData_recycle = imageData_afterScale.length/1000 ;
        
        // 压缩率均值5%递减 根据需求可做调节
        rato = rato * 0.95;
        scaledHeight = floor(height*rato);
        scaledWidth = floor(width*rato);
        
        
        
    } while (imageData_recycle > maxByte);
    
    
    
    return newImage;
}



@end
