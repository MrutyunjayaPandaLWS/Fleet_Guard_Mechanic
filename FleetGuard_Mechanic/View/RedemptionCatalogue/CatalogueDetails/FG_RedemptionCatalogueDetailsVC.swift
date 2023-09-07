//
//  FG_CatalogueDetailsVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 23/01/2023.
//

import UIKit
import LanguageManager_iOS

class FG_RedemptionCatalogueDetailsVC: BaseViewController, popUpDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {
        
    }
    
    
    @IBOutlet weak var termsAndConditionTitleLbl: UILabel!
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var addedToDreamGiftLbl: UILabel!
    @IBOutlet weak var addToDreamGiftLbl: UILabel!
    @IBOutlet weak var addedToCartLbl: UILabel!
    @IBOutlet weak var addToCartLbl: UILabel!
    @IBOutlet weak var addedToDreamGiftView: UIView!
    @IBOutlet weak var addToDreamGiftView: UIView!
    @IBOutlet weak var addedToCartView: UIView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var productPoints: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var productImage: UIView!
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var headerText: UILabel!
    
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var termsAndConLbl: UILabel!
    
    @IBOutlet var productImag: UIImageView!
    @IBOutlet weak var addToCartBtn: UILabel!
    
    @IBOutlet var productBackgroundView: UIView!
    var productImages = ""
    var prodRefNo = ""
    var productCategory = ""
    var productName = ""
    var productPoint = ""
    var tdspercentage1 = 0.0
    var applicabletds = 0.0
    var productDetails = ""
    var termsandContions = ""
    var quantity = 0
    var categoryId = 0
    var catalogueId = 0
    var isComeFrom = ""
    var addCartBtnStatus = 0
    var addDreamGiftBtnStatus = 0
    var requestApis = RestAPI_Requests()
    var pointBalance = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? ""
   // var pointBalance = UserDefaults.standard.string(forKey: "RedeemablePointBalance") ?? ""
    let verifiedStatus = UserDefaults.standard.integer(forKey: "verificationStatus")
    var userID = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""

    var VM = RedemptionCatalogeDetailsVM()
    var myPlannerListArray = [ObjCatalogueList2]()
    
    //let verifiedStatus = UserDefaults.standard.integer(forKey: "VerifiedStatus")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.productImage.clipsToBounds = false
        print(catalogueId,"skjhdk")
        //  self.productImage.layer.borderWidth = 1
        
        self.productImage.layer.cornerRadius = 36
        self.productImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        productImage.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        productImage.layer.shadowOpacity = 0.4
        productImage.layer.shadowRadius = 0.4
        productImage.layer.shadowColor = UIColor.darkGray.cgColor
        
        
        self.productBackgroundView.layer.cornerRadius = 36
        self.productBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        self.categoryLbl.text = "\("Category".localiz()) : \(productCategory)"
        self.productNameLbl.text = productName
        self.productPoints.text = "\("points".localiz()) : \(productPoint)"
        self.descriptionLbl.text = productDetails
        self.termsAndConLbl.text = termsandContions
        let receivedImage = "\(String(describing: self.productImages.replacingOccurrences(of: " ", with: "%20")))"
        print(receivedImage)
        self.productImag.kf.setImage(with: URL(string: "\(imageUrl)\(receivedImage)"), placeholder: UIImage(named: "Humsafar Logo PNG"));
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localization()
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            plannerListing()
            myCartListApi()
        }
        
    }
    
    private func localization(){
        descriptionTitleLbl.text = "Description".localiz()
        termsAndConditionTitleLbl.text = "Terms_and_condition".localiz()
        headerText.text = "Redemption_Catalogue".localiz()
        addToCartBtn.text = "Add to cart".localiz()
        addedToCartLbl.text = "Added to cart".localiz()
        addToDreamGiftLbl.text = "Add to dreamgift".localiz()
        addedToDreamGiftLbl.text = "Added to dreamgift".localiz()
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cartBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyCartVC") as! FG_MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func addToDreamGiftBtn(_ sender: Any) {
        if addDreamGiftBtnStatus == 0{
        addtoDreamGift()
            addDreamGiftBtnStatus = 1
        }
    }
    
    @IBAction func addToCartBTN(_ sender: Any) {
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                return
                }
        
//        if addCartBtnStatus == 0{
        if self.verifiedStatus != 1{
            DispatchQueue.main.async{
                //                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                //                vc!.delegate = self
                //                vc!.titleInfo = ""
                //                vc!.descriptionInfo = "You are not allowled to redeem .Please contact your administrator"
                //                vc!.modalPresentationStyle = .overCurrentContext
                //                vc!.modalTransitionStyle = .crossDissolve
                //                self.present(vc!, animated: true, completion: nil)
                
                self.view.makeToast("redeem_failed_contact_to_admin".localiz(), duration: 3.0, position: .bottom)
            }
            
            
        }else{
            
            print(productPoint,"dskjkjd")
            print(pointBalance,"sndksjnd")
            self.myCartListApi()
            let filterArray = self.VM.redemptionCatalogueMyCartListArray.filter{$0.catalogueId == self.catalogueId}
            let datain = self.VM.redemptionCatalogueMyCartListArray.filter{$0.catalogueId == self.catalogueId}
            
            if Int(productPoint) ?? 0 <= Int(pointBalance) ?? 0 {
                if filterArray.count > 0 {
                    self.addedToCartView.isHidden = false
                    self.addToCartView.isHidden = true
                    
                }else{
                    self.addToCartApi()
                    self.myCartListApi()
                }
                
            }else{
                DispatchQueue.main.async{
                    //                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                    //                    vc!.delegate = self
                    //                    vc!.titleInfo = ""
                    //                    vc!.descriptionInfo = "Insufficent Point Balance"
                    //                    vc!.modalPresentationStyle = .overCurrentContext
                    //                    vc!.modalTransitionStyle = .crossDissolve
                    //                    self.present(vc!, animated: true, completion: nil)
                    
                    self.view.makeToast("Insufficent_Point_Balance".localiz(), duration: 3.0, position: .bottom)
                }
            }
        }
//        }
    }
    
    func plannerListing(){
        let parameters = [
            "ActionType": "6",
            "Points": pointBalance,
            "ActorId": "\(userID)"
        ] as [String : Any]
        print(parameters)
        self.VM.plannerListingApi(parameters: parameters) { response in
            self.myPlannerListArray = response?.objCatalogueList ?? []
            print(self.myPlannerListArray.count, "Planner List Cout")
            DispatchQueue.main.async {
//                if self.VM.myPlannerListArray.count != 0 {
//                    self.ad
//                }else{
//                    self.VM?.countLbl.isHidden = true
//
//                }

                
                //if self.VM.myPlannerListArray.count != 0 {
                    
//                    UserDefaults.standard.set(self.VM.myPlannerListArray[0].is_Redeemable ?? 0, forKey: "PlannerIsRedeemable")
//                    UserDefaults.standard.synchronize()
//                    print(UserDefaults.standard.integer(forKey: "PlannerIsRedeemable"))
//                    self.myDreamGiftTV.isHidden = false
//                    self.noDataFoundLbl.isHidden = true
//                    self.myDreamGiftTV.reloadData()
                //}else{
//                    self.myDreamGiftTV.isHidden = true
//                    self.noDataFoundLbl.isHidden = false
//                }
//                self.stopLoading()
                self.configure()
            }
        }
        
    }
    
    func addtoDreamGift () {
        let parameter = [
            "ActionType":0,
            "ActorId":"\(self.userID)",
            "ObjCatalogueDetails":[
                "CatalogueId": "\(catalogueId)"
            ]
        ] as [String: Any]
        print(parameter)
        self.VM.addToDremGiftAPI(parameter: parameter)
    }
    
    func addToCartApi(){
        
        let parameter = [
            "ActionType": "1",
            "ActorId": "\(self.userID)",
            "CatalogueSaveCartDetailListRequest": [
                [
                    "CatalogueId": "\(catalogueId)",
                    "DeliveryType": "1",
                    "NoOfQuantity": "1"
                ]
            ],
            "LoyaltyID": "\(loyaltyId)",
            "MerchantId": "1"
        ] as [String: Any]
        print(parameter)
        self.VM.redemptionCatalogueAddToCartApi(parameter: parameter)
    }
    
    
    func myCartListApi(){
        self.VM.redemptionCatalogueMyCartListArray.removeAll()
        let parameter = [
            "ActionType": "2",
            "LoyaltyID": "\(self.loyaltyId)"
        ] as [String: Any]
       // self.VM.redemptionCatalogueMyCartListApi(parameter: parameter)
        self.requestApis.redemptionCatalogueMycartListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.VM.redemptionCatalogueMyCartListArray = result?.catalogueSaveCartDetailListResponse ?? []
                        
                        if self.VM.redemptionCatalogueMyCartListArray.count != 0 {
                            self.countLbl.isHidden = false
                            self.countLbl.text = "\(self.VM.redemptionCatalogueMyCartListArray.count)"
                        }else{
                            self.countLbl.isHidden = true
                            
                        }

                        self.configure()
                    }

                }else{
                    DispatchQueue.main.async {
                        self.stopLoading()
                        print("\(error)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.stopLoading()
                    print("\(error)")
                }
            }
        }
    }
        

    
    func configure(){
        let filterArray = self.VM.redemptionCatalogueMyCartListArray.filter{$0.catalogueId == self.catalogueId}
        
        print(filterArray.count,"skhask")
        
        var filterDreamGiftArray = [ObjCatalogueList2]()
        if (self.myPlannerListArray.count != 0){
            filterDreamGiftArray = self.myPlannerListArray.filter{$0.catalogueId == self.catalogueId}
        }
        
        if Int(self.pointBalance) ?? 0 >= Int(self.productPoint) ?? 0 {
       
            if filterArray.count > 0 {
                self.addedToCartView.isHidden = false
                self.addToCartView.isHidden = true
            }else{
                self.addedToCartView.isHidden = true
                self.addToCartView.isHidden = false
            }
            self.addedToDreamGiftView.isHidden = true
            self.addToDreamGiftView.isHidden = true
            
        }else{
            if filterDreamGiftArray.count > 0 {
                self.addedToCartView.isHidden = true
                self.addToCartView.isHidden = true
                self.addedToDreamGiftView.isHidden = false
                self.addToDreamGiftView.isHidden = true
                
            }else{
                self.addedToCartView.isHidden = true
                self.addToCartView.isHidden = true
                self.addedToDreamGiftView.isHidden = true
                self.addToDreamGiftView.isHidden = false
            }
        }
    }
    
}
