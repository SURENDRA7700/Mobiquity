//
//  AddressCell.swift
//  ketoGinik
//
//  Created by surendra kumar k on 18/06/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var sselectBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var topLabelAddres: UILabel!
    @IBOutlet weak var secLabelAddrInfo: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var modifyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyShadowOnView(shadowView)

    }

    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


