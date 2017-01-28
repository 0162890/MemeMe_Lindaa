//
//  MemeTableViewCell.swift
//  MemeMe1.0
//
//  Created by 하연 on 2017. 1. 27..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableCellImage: UIImageView!
    @IBOutlet weak var tableCellLabel: UILabel!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    
    //MARK: - TextField Attributes
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black, //테두리 색
        NSForegroundColorAttributeName: UIColor.white, //글자 색
         NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 18)!,
        NSStrokeWidthAttributeName: -3.0]

    //MARK: - Set label style
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topLabel.defaultTextAttributes = memeTextAttributes
        topLabel.textAlignment = .center
        topLabel.isEnabled = false
        
        bottomLabel.defaultTextAttributes = memeTextAttributes
        bottomLabel.textAlignment = .center
        bottomLabel.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
