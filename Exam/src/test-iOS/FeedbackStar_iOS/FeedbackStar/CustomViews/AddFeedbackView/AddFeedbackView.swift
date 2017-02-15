//
//  AddFeedbackView.swift
//  FeedbackStar
//
//  Created by James Xu on 16/11/22.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class AddFeedbackView: UIButton {
    var isPop = false
    lazy var askBtn = UIButton(type: .custom)
    lazy var giveBtn = UIButton(type: .custom)
    lazy var niceBtn = UIButton(type: .custom)
    var moduleClickClouser: ((Int) -> ())?
    var cancleClickClouser: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {
        let centerX = self.width / 2.0
        let centerY = self.height - (N_TabBarHeight - SPH(5))

        askBtn = UIButton(type: .custom)
        askBtn.setImage(UIImage(named: "askfor"), for: .normal)
        askBtn.setImage(UIImage(named:"askfor"), for: .highlighted)
        askBtn.backgroundColor = WhiteColor
        askBtn.frame = CGRect(0, 0, SPH(48), SPH(48))
        askBtn.center = CGPoint(centerX, centerY)
        askBtn.layer.cornerRadius = askBtn.width / 2.0
        askBtn.addTarget(self, action: #selector(askBtnClick), for: .touchUpInside)
        
        let askLabel = UILabel(0, 0, 60.s, 14.s, "Ask For", WhiteColor, 12.s)
        askLabel.textAlignment = .center
        askLabel.center = CGPoint(askBtn.width / 2.0, askBtn.height + 10.s)
        askBtn.addSubview(askLabel)
        
        giveBtn = UIButton(type: .custom)
        giveBtn.setImage(UIImage(named: "give"), for: .normal)
        giveBtn.setImage(UIImage(named:"give"), for: .highlighted)
        giveBtn.backgroundColor = WhiteColor
        giveBtn.frame = CGRect(0, 0, SPH(48), SPH(48))
        giveBtn.center = CGPoint(centerX, centerY)
        giveBtn.layer.cornerRadius = giveBtn.width / 2.0
        giveBtn.addTarget(self, action: #selector(giveBtnClick), for: .touchUpInside)
        
        let giveLabel = UILabel(0, 0, 60.s, 14.s, "Give", WhiteColor, 12.s)
        giveLabel.textAlignment = .center
        giveLabel.center = CGPoint(giveBtn.width / 2.0, giveBtn.height + 10.s)
        giveBtn.addSubview(giveLabel)
        
        niceBtn = UIButton(type: .custom)
        niceBtn.setImage(UIImage(named: "niceone"), for: .normal)
        niceBtn.setImage(UIImage(named:"niceone"), for: .highlighted)
        niceBtn.backgroundColor = WhiteColor
        niceBtn.frame = CGRect(0, 0, SPH(48), SPH(48))
        niceBtn.center = CGPoint(centerX, centerY)
        niceBtn.layer.cornerRadius = niceBtn.width / 2.0
        niceBtn.addTarget(self, action: #selector(niceBtnClick), for: .touchUpInside)
        
        let niceLabel = UILabel(0, 0, 60.s, 14.s, "Nice One", WhiteColor, 12.s)
        niceLabel.textAlignment = .center
        niceLabel.center = CGPoint(niceBtn.width / 2.0, niceBtn.height + 10.s)
        niceBtn.addSubview(niceLabel)
        
        self.addSubview(askBtn)
        self.addSubview(giveBtn)
        self.addSubview(niceBtn)
        
        self.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
    }
    
    func askBtnClick() {
        self.cancelClick()
        self.moduleClickClouser?(0)
    }
    
    func giveBtnClick() {
        self.cancelClick()
        self.moduleClickClouser?(1)
    }
    
    func niceBtnClick() {
        self.cancelClick()
        self.moduleClickClouser?(2)
    }
    
    func cancelClick() {
        self.cancleClickClouser?()
    }
    
    func presentOut() {
        self.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        }) { (_) in
            self.isPop = true
        }
        
        let centerX = self.width / 2.0
        let centerY = self.height - (N_TabBarHeight - SPH(5))
        
        self.askBtn.transform = CGAffineTransform.identity.rotated(by: -(CGFloat)(M_PI_2) * 0.3)
        self.askBtn.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
        self.askBtn.alpha = 0.5
        
        self.giveBtn.transform = CGAffineTransform.identity.rotated(by: 0)
        self.giveBtn.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
        self.giveBtn.alpha = 0.5

        self.niceBtn.transform = CGAffineTransform.identity.rotated(by: (CGFloat)(M_PI_2) * 0.3)
        self.niceBtn.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
        self.niceBtn.alpha = 0.5
        
        let timeInterval = 0.05
        self.doPresentAnimatiton(view: self.askBtn, targetCenter: CGPoint(centerX - SPH(70), centerY - SPH(58)))
        self.perform(DelayTime: timeInterval) { [unowned self] in
            self.doPresentAnimatiton(view: self.giveBtn, targetCenter: CGPoint(centerX, centerY - SPH(95)))
        }
        self.perform(DelayTime: timeInterval * 2) { [unowned self] in
            self.doPresentAnimatiton(view: self.niceBtn, targetCenter: CGPoint(centerX + SPH(70), centerY - SPH(58)))
        }
    }
    
    func disMiss() {
        self.isPop = false
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        }) { (_) in
            self.isHidden = true
        }
        
        let timeInterval = 0.05
        
        self.doDismissAnimation(view: self.niceBtn, rotate: (CGFloat)(M_PI_2) * 0.3)
        self.perform(DelayTime: timeInterval) { [unowned self] in
            self.doDismissAnimation(view: self.giveBtn, rotate: 0)
        }
        self.perform(DelayTime: timeInterval * 2) { [unowned self] in
            self.doDismissAnimation(view: self.askBtn, rotate: -(CGFloat)(M_PI_2) * 0.3)
        }
    }
    
    func doPresentAnimatiton(view: UIView, targetCenter: CGPoint) {
        UIView.animate(withDuration: 0.25, delay: 0.01, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            view.center = targetCenter
            }, completion: { _ in
        })
        
        UIView.animate(withDuration: 0.25) {
            view.transform = CGAffineTransform.identity
            view.alpha = 1
        }
    }
    
    func doDismissAnimation(view: UIView, rotate: CGFloat) {
        let centerX = self.width / 2.0
        let centerY = self.height - (N_TabBarHeight - SPH(5))
        
        UIView.animate(withDuration: 0.25, delay: 0.01, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            view.center = CGPoint(centerX, centerY)
            }, completion: { _ in
        })
        
        UIView.animate(withDuration: 0.25) {
            view.transform = CGAffineTransform.identity.rotated(by: rotate)
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)
            view.alpha = 0.5
        }

    }
}
