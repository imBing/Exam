//
//  TabRequestButton.swift
//  FeedbackStar
//
//  Created by Vin on 16/11/8.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class TabRequestButton: UIButton {
    override func awakeFromNib() {
        self.titleLabel?.textAlignment = .center
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.originY = 0
        self.imageView?.originX = SPH(10)
        self.imageView?.width = self.width - SPH(15) * 2
        self.imageView?.height = self.width - SPH(15) * 2
        
        self.titleLabel?.originX = 0
        self.titleLabel?.originY = (self.imageView?.maxY)! + SPH(1)
        self.titleLabel?.width = self.width
        self.titleLabel?.height = self.height - (self.imageView?.height)!
        self.titleLabel?.font = UIFont.systemFont(ofSize: SPH(15))   
        
    }

}
