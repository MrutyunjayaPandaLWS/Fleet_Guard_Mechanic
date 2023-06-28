//
//  FG_RedemptionCatalogueTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 23/01/2023.
//

import UIKit
import LanguageManager_iOS

protocol DidTapActionDelegate: AnyObject{
    func addToCartDidTap(_ cell: FG_RedemptionCatalogueTVC)
    func detailsDidTap(_ cell: FG_RedemptionCatalogueTVC)
    func addToDreamGift(_ cell: FG_RedemptionCatalogueTVC)
    func addAndRemovePlannerList(_ cell: FG_RedemptionCatalogueTVC)
}

class FG_RedemptionCatalogueTVC: UITableViewCell {

    @IBOutlet weak var detailsBtn: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var addToDreamGiftLbl: UILabel!
    @IBOutlet weak var addedToDreamGiftLbl: UILabel!
    @IBOutlet weak var addedTocartLbl: UILabel!
    @IBOutlet weak var addCartLbl: UILabel!
    @IBOutlet weak var addedToCartView: UIView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var pointView: UIView!
    
    @IBOutlet var addedToDreamGiftView: UIView!
    @IBOutlet var addtoDreamGiftView: UIView!
    
    @IBOutlet var addToPlannerOutletBTN: UIButton!
    @IBOutlet weak var pointsLbl: UILabel!
    
    var delegate: DidTapActionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.pointView.clipsToBounds = true
        self.pointView.layer.cornerRadius = 16
        self.pointView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.productImage.clipsToBounds = true
        self.productImage.layer.cornerRadius = 16
        self.productImage.layer.maskedCorners = [.layerMinXMinYCorner]
        localization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    private func localization(){
        detailsBtn.text = "Details".localiz()
        pointsTitleLbl.text = "points".localiz()
        addToDreamGiftLbl.text = "Added to dreamgift".localiz()
        addedTocartLbl.text = "Added to cart".localiz()
        addToDreamGiftLbl.text = "Add to dreamgift".localiz()
        addCartLbl.text = "Add to cart".localiz()
    }

    @IBAction func addToCartButton(_ sender: Any) {
        self.delegate.addToCartDidTap(self)
    }
    @IBAction func addedToCartButton(_ sender: Any) {
    }
    @IBAction func addToDreamGiftButton(_ sender: Any) {
        self.delegate.addToDreamGift(self)
    }
    @IBAction func addedToDreamGiftButton(_ sender: Any) {
    }
    @IBAction func detailsBtn(_ sender: Any) {
        self.delegate.detailsDidTap(self)
    }
    
    @IBAction func addPlannerDreamGiftBtn(_ sender: Any) {
    }
}
