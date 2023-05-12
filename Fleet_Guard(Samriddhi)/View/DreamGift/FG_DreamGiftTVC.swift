//
//  FG_DreamGiftTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 20/03/23.
//

import UIKit

protocol dreamGiftPlannerDelegate: AnyObject {
    func detailsButton(_ vc: FG_DreamGiftTVC)
    func removeProductButton(_ vc: FG_DreamGiftTVC)
}

class FG_DreamGiftTVC: UITableViewCell {
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarCircleViewLeading: NSLayoutConstraint!
    @IBOutlet weak var progressBarValueLbl: UILabel!
    @IBOutlet weak var progressBarCorcleView: UIView!
    @IBOutlet var categoryLbl: UILabel!
    @IBOutlet var productNameLbl: UILabel!
    @IBOutlet var detailsOutBtn: GradientButton!
    @IBOutlet var pointsAvailableLbl: UILabel!
    @IBOutlet var pointsRequiredLbl: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    weak var delegate:dreamGiftPlannerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailsOutBtn.semanticContentAttribute = .forceRightToLeft
    }
    
    @IBAction func detailsActBTN(_ sender: Any) {
        self.delegate?.detailsButton(self)
    }
    @IBAction func removeProductBRN(_ sender: Any) {
        self.delegate?.removeProductButton(self)
    }
    
}
