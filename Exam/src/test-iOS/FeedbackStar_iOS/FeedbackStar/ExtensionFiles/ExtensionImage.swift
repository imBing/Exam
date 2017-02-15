//
//  ExtensionImage.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/6.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

extension UIImage {
    
    func transformtoSize(_ newSize: CGSize) -> UIImage {
        var fixSize = newSize
        let imageSize = self.size
        if imageSize.width > imageSize.height {
            fixSize = CGSize(newSize.width, imageSize.height / imageSize.width * newSize.width)
        }else {
            fixSize = CGSize(imageSize.width / imageSize.height * newSize.height, newSize.height)
        }
        // 创建一个bitmap的context
        UIGraphicsBeginImageContext(fixSize)
        // 绘制改变大小的图片
        self.draw(in: CGRect(x: 0, y: 0, width: fixSize.width, height: fixSize.height))
        // 从当前context中创建一个改变大小后的图片
        let TransformedImg = UIGraphicsGetImageFromCurrentImageContext()
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return TransformedImg!
    }
}

//Color-Image
func ImageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(0 ,0 ,1 ,1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    if let image = image {
        return image
    }
    return UIImage()
}
