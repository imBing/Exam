//
//  AddRequestView.swift
//  FeedbackStar
//
//  Created by Vin on 16/11/8.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class AddRequestView: UIView {

    @IBOutlet weak var fbButton: TabRequestButton!
    @IBOutlet weak var allBtnView: UIView!
    @IBOutlet weak var askFor: UILabel!
    @IBOutlet weak var giveOut: UILabel!
    
    var askForFeedbackClouser: (() -> ())?
    
    @IBAction func feedBackClick(_ sender: AnyObject) {
        self.askForFeedbackClouser?()
    }
    
    override func awakeFromNib() {
       autoConstrains()
    }
    
}

extension AddRequestView {
    // 自动适配
    fileprivate func autoConstrains() {
        fbButton.updateAllConstraintsToSPH()
        askFor.font = GetFont(SPH(21))
        giveOut.font = GetFont(SPH(21))
        allBtnView.updateAllConstraintsToSPH()
        askFor.updateAllConstraintsToSPH()
        giveOut.updateAllConstraintsToSPH()
    }
}






