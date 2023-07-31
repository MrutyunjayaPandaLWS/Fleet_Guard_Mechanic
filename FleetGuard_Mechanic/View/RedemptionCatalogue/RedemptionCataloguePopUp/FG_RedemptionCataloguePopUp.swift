//
//  FG_RedemptionCataloguePopUp.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 24/02/23.
//

import UIKit
import LanguageManager_iOS

 protocol RedemptionPopUpMessageDelegate{
    func didTappedDasbordBtn()
}
class FG_RedemptionCataloguePopUp: BaseViewController {
    
    @IBOutlet weak var goToDashBoatrdBtn: GradientButton!
    @IBOutlet weak var infoLbl: UILabel!
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var delegate: RedemptionPopUpMessageDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func localize(){
        self.infoLbl.text = "Your order placed successfully !".localiz()
        self.goToDashBoatrdBtn.setTitle("Go to Dashboard".localiz(), for: .normal)
    }
    
    @IBAction func dashBoardBtn(_ sender: Any) {
//        NotificationCenter.default.post(name: .navigateToDashboard, object: nil)
        self.delegate?.didTappedDasbordBtn()
        self.dismiss(animated: true)
    }
    
}
