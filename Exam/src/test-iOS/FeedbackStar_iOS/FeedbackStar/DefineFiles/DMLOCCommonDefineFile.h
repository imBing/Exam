//
//  DMLOCCommonDefineFile.h
//  FeedbackStar
//
//  Created by James Xu on 16/12/28.
//  Copyright © 2016年 Daimler. All rights reserved.
//

#ifndef DMLOCCommonDefineFile_h
#define DMLOCCommonDefineFile_h

//缩小比例
#define AdaptFixValue 0.9
#define MULTI   1.15   //修改放大系数(针对于plus), 6自动适应大小
#define DeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define SPH(value) ((((DeviceWidth - 375.0) / 375.0) * ((MULTI - 1) / 0.27) + 1) * (value) * AdaptFixValue)

#endif /* DMLOCCommonDefineFile_h */
