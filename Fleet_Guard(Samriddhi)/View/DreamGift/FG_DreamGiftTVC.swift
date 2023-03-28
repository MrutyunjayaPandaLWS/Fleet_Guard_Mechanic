//
//  FG_DreamGiftTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 20/03/23.
//

import UIKit

class FG_DreamGiftTVC: UITableViewCell {
    
    
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var productNameLbl: UILabel!
    @IBOutlet var detailsOutBtn: GradientButton!
    @IBOutlet var pointsAvailableLbl: UILabel!
    @IBOutlet var pointsRequiredLbl: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func detailsActBTN(_ sender: Any) {
    }
    
}
