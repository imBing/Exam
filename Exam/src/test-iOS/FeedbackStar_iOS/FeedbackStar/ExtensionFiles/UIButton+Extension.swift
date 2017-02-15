//
//  UIButton+Extension.swift
//  WYWB
//
//  Created by Vin on 16/9/5.
//  Copyright © 2016年 daimler. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName: String, backImageName:String?) {
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named: backImageName), for: .normal)
            setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: UIControlState.highlighted)
        }
        sizeToFit()
}
    
    
    convenience init(title: String, color: UIColor, backImageName: String) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        sizeToFit()
    }
    
    
    
    convenience init(title: String, fontSize: CGFloat, color: UIColor, imageName: String) {
        self.init()
        
        setTitle(title, for: UIControlState())
        setTitleColor(color, for: UIControlState())
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setImage(UIImage(named: imageName), for: .normal)
        sizeToFit()
    }
    


    
}
