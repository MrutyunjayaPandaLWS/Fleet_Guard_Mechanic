//
//  FG_DreamGiftTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 20/03/23.
//

import UIKit
import LanguageManager_iOS

protocol dreamGiftPlannerDelegate: AnyObject {
    func detailsButton(_ vc: FG_DreamGiftTVC)
    func removeProductButton(_ vc: FG_DreamGiftTVC)
}

class FG_DreamGiftTVC: UITableViewCell {
    
    
    @IBOutlet weak var pointsAvailableTitleLbl: UILabel!
    @IBOutlet weak var pointsRequiredTitlLbl: UILabel!
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
        localizartion()
    }
    
    private func localizartion(){
//        detailsOutBtn.setTitle("Details".localiz(), for: .normal)
        pointsRequiredTitlLbl.text = "Points Required".localiz()
        pointsAvailableTitleLbl.text = "Points Available".localiz()
    }
    
    @IBAction func detailsActBTN(_ sender: Any) {
        self.delegate?.detailsButton(self)
    }
    @IBAction func removeProductBRN(_ sender: Any) {
        self.delegate?.removeProductButton(self)
    }
    
}
