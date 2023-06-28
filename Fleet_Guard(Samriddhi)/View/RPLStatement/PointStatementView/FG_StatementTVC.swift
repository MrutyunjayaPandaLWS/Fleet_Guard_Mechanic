//
//  FG_StatementTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 25/01/2023.
//

import UIKit
import LanguageManager_iOS

protocol StatementViewDelegate: AnyObject{
    func viewActBTN(_ cell: FG_StatementTVC)
}

class FG_StatementTVC: UITableViewCell {

    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var pointEarnedLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var viewOutBtn: UIButton!
    var totalPoints = 0
    weak var delegate: StatementViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        viewOutBtn.setTitle("View".localiz(), for: .normal)
    }
    
    @IBAction func viewBtn(_ sender: Any) {
        self.delegate.viewActBTN(self)
    }
}
