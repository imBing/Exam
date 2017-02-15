//
//  DMLPopCoverView.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/1.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class DMLPopCoverView: NSObject {
    static let coverView = PopCoverView()
    
    class func shareView() -> PopCoverView {
        self.coverView.backgroundColor = UIColor.lightGray
        self.coverView.isHidden = false
        self.coverView.alpha = 0.35
        return self.coverView
    }
    
    class func setHidden() {
        self.coverView.isHidden = true
    }
}

class PopCoverView: UIView {
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI() {
        self.frame = CGRect(x: 0, y: 0, width: DeviceWidth, height: DeviceHeight)
        self.backgroundColor = UIColor.lightGray
    }

}
