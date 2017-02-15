//
//  SearchCell.swift
//  searchSwift
//
//  Created by Vin on 16/11/9.
//  Copyright © 2016年 daimler. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var selectImgView: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!

    @IBOutlet weak var sqliteView: UIView!
    var searchModel: UserSearchModel? {
        didSet {
            nameLabel.text = searchModel?.name
            departmentLabel.text = searchModel?.department
            if searchModel?.isSelected == true {
                selectImgView.image = UIImage(named: "selected")
            }else {
                selectImgView.image = UIImage(named: "unselected")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.sqliteView.backgroundColor = HEXCOLOREA
//        self.backgroundColor = WhiteColor
        setupUI()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            selectImgView.image = UIImage(named: "selected")
//            searchModel?.isSelected = true
//        }else {
//            selectImgView.image = UIImage(named: "unselected")
////            searchModel?.isSelected = false
//        }
//    }

}
fileprivate extension SearchCell {
    func setupUI() {
        icon.layer.cornerRadius = 23.s
        icon.layer.masksToBounds = true
        self.adaptAllViewsToSPH()
    }
}







