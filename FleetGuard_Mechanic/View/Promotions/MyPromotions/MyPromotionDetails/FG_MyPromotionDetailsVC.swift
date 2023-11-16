//
//  FG_MyPromotionDetailsVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit
import Kingfisher
import LanguageManager_iOS

class FG_MyPromotionDetailsVC: BaseViewController {

    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var offersPromotionTitleLbl: UILabel!
    @IBOutlet weak var termsandconditionLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var offerNameLbl: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    
    var promotionId = 0
    var selectedTitle = ""
    var selectedOfferId = ""
    var selectedLongDesc = ""
    var selectedShortDesc = ""
    var selectedImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerText.text = "Offers_promotions".localiz()
//        self.termsandconditionLbl.text = selectedLongDesc
        //self.descriptionLbl.text = self.selectedLongDesc
        self.categoryTitle.text  = self.selectedTitle
        self.descriptionData()
        let imageURL = self.selectedImage
        if imageURL != ""{
            let filteredURLArray = imageURL.dropFirst(3)
            let urltoUse = String(Promo_ImageData + filteredURLArray).replacingOccurrences(of: " ", with: "%20")
            let urlt = URL(string: "\(urltoUse)")
            print(urlt)
            self.headerImage.kf.setImage(with: urlt!, placeholder: UIImage(named: "Asset 2"));
        }
        
        self.subView.clipsToBounds = false
        self.subView.layer.cornerRadius = 36
        self.subView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        subView.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        subView.layer.shadowOpacity = 0.4
        subView.layer.shadowRadius = 0.4
        subView.layer.shadowColor = UIColor.darkGray.cgColor
        localization()
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func languageBtn(_ sender: Any) {
    }
    
    private func localization(){
        offersPromotionTitleLbl.text = "Offers_promotions".localiz()
        descriptionTitleLbl.text = "Description".localiz()
    }
    
    func convertHTMLToPlainText(htmlString: String) -> String {
            if let attributedString = NSAttributedString(htmlString: htmlString) {
                return attributedString.string
            } else {
                return ""
            }
        }
    
    
    func descriptionData(){
          let plainText = convertHTMLToPlainText(htmlString: selectedLongDesc)
          self.descriptionLbl.text = plainText
      }
    
}
extension NSAttributedString {
    convenience init?(htmlString: String) {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        try? self.init(data: data, options: options, documentAttributes: nil)
    }
}
