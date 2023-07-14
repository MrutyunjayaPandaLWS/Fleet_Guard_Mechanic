//
//  FG_ProdCatalogueTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 24/01/2023.
//

import UIKit
import LanguageManager_iOS

protocol SendDataToDetailsDelegate: class{
    func sendDataToDetails(_ cell: FG_ProdCatalogueTVC)
    func didTappedImageViewBtn(cell: FG_ProdCatalogueTVC)
}

class FG_ProdCatalogueTVC: UITableViewCell {

    @IBOutlet weak var partNoTitleLbl: UILabel!
    @IBOutlet weak var imageViewBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mrpValue: UILabel!
    @IBOutlet weak var dapValue: UILabel!
    @IBOutlet weak var partNoLbl: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    var imageUrl: String = ""
    var delegate: SendDataToDetailsDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        partNoTitleLbl.text = "Part number".localiz()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTappedImageViewBtn(_ sender: Any) {
        delegate.didTappedImageViewBtn(cell: self)
    }
    @IBAction func nextBtn(_ sender: Any) {
        self.delegate.sendDataToDetails(self)
    }
}
