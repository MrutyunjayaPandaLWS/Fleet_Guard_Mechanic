//
//  FG_DreamGiftDetailsVC.swift
//  Fleet_Guard(Samriddhi)
//
import UIKit
import Lottie
import Kingfisher
import LanguageManager_iOS

class FG_DreamGiftDetailsVC: BaseViewController, popUpDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var yourExpetedRedeemTitleLbl: UILabel!
    @IBOutlet weak var addedToCartBtn: GradientButton!
    @IBOutlet weak var redeemBtn: GradientButton!
    @IBOutlet weak var avaragePointsTitle: UILabel!
    @IBOutlet weak var RedeemablePointsTitle: UILabel!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    @IBOutlet weak var expectRedeemDate: UILabel!
    @IBOutlet weak var expectRedeemProductName: UILabel!
    @IBOutlet weak var progressBarCircleViewLeading: NSLayoutConstraint!
    @IBOutlet weak var progressBarValueLbl: UILabel!
    @IBOutlet weak var pointsRequiredLbl: UILabel!
    @IBOutlet var redemptionPlannerTitleLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var points: UILabel!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var todayPoints: UILabel!
    @IBOutlet var monthlyPointsLabel: UILabel!
    @IBOutlet var progressiveView: UIProgressView!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var redeemablePointsTodaytitle: UILabel!
    @IBOutlet weak var avaragePointstitle: UILabel!
    
    var addCartBtnStatus = 0
    var productImage = ""
    var productName = ""
    var quantity = ""
    var redemptionRefNo = ""
    var descDetails = ""
    var termsandContions = ""
    var redemptionPoints = ""
    var status = ""
    var redemptionsDate = ""
    var redemptionId = ""
    var totalPoint = ""
    var cartCounts = ""
    var productPoints = 0
    var categoryName = ""
    var selectedCatalogueID = 0
    var productId = 0
    var redeemNowStatus = 0
    
    var VM = RedemptionPlannerDetailsViewModel()
    var pointBalance = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? ""
    var userID = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var selectedPlannerID = 0
    var totalCartValue = 0
    var requiredPoints = 0
    var averageLesserDate = ""
    var redeemableAverageEarning = ""
    var dateOfSubmission = ""
    let verifiedStatus = UserDefaults.standard.integer(forKey: "VerifiedStatus")
    var checkAccountStatus = UserDefaults.standard.string(forKey: "SemiActiveAccount") ?? ""
    var tdspercentage1 = 0.0
    var applicabletds = 0.0
    var requestApis = RestAPI_Requests()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
       // NotificationCenter.default.addObserver(self, selector: #selector(checkVerificationStatus), name: Notification.Name.verificationStatus, object: nil)
        plannerListing()
        productNameLabel.text = self.productName
        categoryTitleLbl.text = "\("Category".localiz()) : \(categoryName)"
        
//        print(tdsprice!)
//        tdsvalue.text = "\(applicabletds)"
//        tdsprice.text = "\(tdspercentage1)%"
        points.text = "\(Int(productPoints))"
        let totalImgURL = imageUrl + productImage.replacingOccurrences(of: " ", with: "%20")
       // productImageView.kf.setImage(with: URL(string: "\(String(describing: totalImgURL ))"), placeholder: UIImage(named: "Humsafar Logo PNG"))
        productImageView.kf.setImage(with: URL(string: "\(String(describing: totalImgURL ))"), placeholder: UIImage(named: "Humsafar Logo PNG"))
        self.todayPoints.text = "\(Int(pointBalance) ?? 0)"
        self.monthlyPointsLabel.text = "\(Int(pointBalance) ?? 0)"//"\(redeemableAverageEarning)"
        self.expectRedeemProductName.text = productName
        self.expectRedeemDate.text = dateOfSubmission
        
        if productPoints  > Int(pointBalance) ?? 0 {
            self.pointsRequiredLbl.text = "\((Int(productPoints) ) - (Int(pointBalance) ?? 0)) \("Points_more_to_redeem".localiz())"
            redeemBtn.isHidden = true
            //redeemButton.isEnabled = false
            //congratulationsImageView.isHidden = true
           // infoDetailsLbl.isHidden = false
            //            if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
            //infoDetailsLbl.text = "You need \(requiredPoints) more redeemable points to redeem this product"
            //giftLabel.text = "Your expected redemption of \(productName) is in \(dateOfSubmission)"
            //            }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
            //                infoDetailsLbl.text = "आप की जरूरत है \(requiredPoints) इस उत्पाद को भुनाने के लिए अधिक रिडीम करने योग्य अंक"
            //            }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
            //                infoDetailsLbl.text = "তোমার দরকার \(requiredPoints) এই পণ্যটি খালাস করার জন্য আরও খালাসযোগ্য পয়েন্ট"
            //            }else{
            //                infoDetailsLbl.text = "నీకు అవసరం \(requiredPoints) ఈ ఉత్పత్తిని రీడీమ్ చేయడానికి మరిన్ని రీడీమ్ చేయగల పాయింట్‌లు"
            //            }
            
            //redeemButton.backgroundColor = .lightGray
            let image =  imageUrl + productImage.replacingOccurrences(of: " ", with: "%20")
                productImageView.kf.setImage(with: URL(string: "\(String(describing: image ))"), placeholder: UIImage(named: "Humsafar Logo PNG 1"))
            var pointBal = Float(pointBalance) ?? 0.0
            var requiredBal = Float(productPoints)
            var progressPercent = CGFloat(pointBal/requiredBal) * 100.0
            progressiveView.progress = Float((progressPercent / 100.0) )
            
                progressBarValueLbl.text = "\(Int(progressPercent)) %"
            progressBarCircleViewLeading.constant = ((progressiveView.frame.width ) * CGFloat(progressPercent/100))
            
               
            
        }else{
            pointsRequiredLbl.text = ""
            progressBarValueLbl.text = "100 %"
            progressBarCircleViewLeading.constant = ((progressiveView.frame.width) + 8)
            progressiveView.progress = 1
           // congratulationsImageView.isHidden = true
//            infoDetailsLbl.isHidden = false
//            infoDetailsLbl.text = "Congratulations! You are eligible to redeem your Redemption planner product."
//            giftLabel.text = "You are eligible to redeem this product."
//            redeemButton.isEnabled = true
//            redeemButton.backgroundColor = .red
            redeemBtn.isHidden = false
        }
 
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
            myCartListApi()
        }
    }
    
    @IBAction func didTappedRedeemNowBtn(_ sender: Any) {
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        return
        }
        if addCartBtnStatus == 0{
//        if self.verifiedStatus != 1{
//            DispatchQueue.main.async{
//                self.view.makeToast("redeem_failed_contact_to_admin".localiz(), duration: 3.0, position: .bottom)
//            }
//
//
//        }else{
            
            print(productPoints,"dskjkjd")
            print(pointBalance,"sndksjnd")
//            self.myCartListApi()
            let filterArray = self.VM.redemptionCatalogueMyCartListArray.filter{$0.catalogueId == self.selectedCatalogueID}
            let datain = self.VM.redemptionCatalogueMyCartListArray.filter{$0.catalogueId == self.selectedCatalogueID}
            
            if Int(productPoints) <= Int(pointBalance) ?? 0 {
                if filterArray.count > 0 {
//                    self.addedToCartView.isHidden = false
//                    self.addToCartView.isHidden = true
//                    self.view.makeToast("Product is already added in the Redeem list",duration: 2.0,position: .bottom)
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyCartVC") as! FG_MyCartVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    self.addToCartApi()
                    self.myCartListApi()
                    addCartBtnStatus = 1
                }
                
            }else{
                DispatchQueue.main.async{
                    self.view.makeToast("Insufficent_Point_Balance".localiz(), duration: 3.0, position: .bottom)
                }
            }
//        }
        }

        
        
        
    }
    private func localization(){
        redemptionPlannerTitleLabel.text = "Dream_Gift".localiz()
        removeButton.setTitle("Remove".localiz(), for: .normal)
        redeemBtn.setTitle("Redeem now".localiz(), for: .normal)
        pointsTitleLbl.text = "points".localiz()
        redeemablePointsTodaytitle.text = "Redeemable Points as on Today".localiz()
        avaragePointstitle.text = "Average earning required per month".localiz()
        avaragePointsTitle.text = "points".localiz()
        RedeemablePointsTitle.text = "points".localiz()
        self.yourExpetedRedeemTitleLbl.text = "Your Expected Redemption".localiz()
    }
    
    //    func languagelocalization(){
    //        if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
    
    //            self.redemptionPlannerTitleLabel.text = "Redemption Planner Details"
    //            self.pointHeading.text = "Points"
    //            self.redeemButton.setTitle("Redeem", for: .normal)
    //            self.removeButton.setTitle("Remove", for: .normal)
    //            self.redemptionPlannerSummaryHEadingLabel.text = "Redemption Planner Summary"
    //            self.todayRedemablePoinsHEading.text = "Redeemable Points as on Today"
    //            self.todayRedemablePoinsHEading.text = "Points"
    //            self.avgEarningsLabel.text = "Average earning required per month"
    //            self.monthlyHeadingLabel.text = "Points"
    //        }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
    //            giftLabel.text = "आपका अपेक्षित मोचन \(productName) में है \(averageLesserDate)"
    //            self.redemptionPlannerTitleLabel.text = "मोचन योजनाकार विवरण"
    //            self.pointHeading.text = "पॉइंट्स"
    //            self.redeemButton.setTitle("भुनाना", for: .normal)
    //            self.removeButton.setTitle("हटाना", for: .normal)
    //            self.redemptionPlannerSummaryHEadingLabel.text = "मोचन योजनाकार सारांश"
    //            self.todayRedemablePoinsHEading.text = "आज के अनुसार रिडीम करने योग्य अंक"
    //            self.todayRedemablePoinsHEading.text = "पॉइंट्स"
    //            self.avgEarningsLabel.text = "प्रति माह औसत कमाई की आवश्यकता"
    //            self.monthlyHeadingLabel.text = "पॉइंट्स"
    //        }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
    //            giftLabel.text = "আপনার প্রত্যাশিত খালাস \(productName) মধ্যে আছে \(averageLesserDate)"
    //            self.redemptionPlannerTitleLabel.text = "রিডেম্পশন প্ল্যানারের বিবরণ"
    //            self.pointHeading.text = "পয়েন্ট"
    //            self.redeemButton.setTitle("রিডিম", for: .normal)
    //            self.removeButton.setTitle("অপসারণ", for: .normal)
    //            self.redemptionPlannerSummaryHEadingLabel.text = "রিডেম্পশন প্ল্যানার সারাংশ"
    //            self.todayRedemablePoinsHEading.text = "আজকের মত রিডিমেবল পয়েন্ট"
    //            self.todayRedemablePoinsHEading.text = "পয়েন্ট"
    //            self.avgEarningsLabel.text = "প্রতি মাসে গড় উপার্জন প্রয়োজন"
    //            self.monthlyHeadingLabel.text = "পয়েন্ট"
    //        }else{
    //            giftLabel.text = "మీరు ఆశించిన విముక్తి \(productName) లో ఉంది \(averageLesserDate)"
    //            self.redemptionPlannerTitleLabel.text = "విముక్తి ప్లానర్ వివరాలు"
    //            self.pointHeading.text = "వపాయింట్లు"
    //            self.redeemButton.setTitle("రీడీమ్ చేయండి", for: .normal)
    //            self.removeButton.setTitle("తొలగించు", for: .normal)
    //            self.redemptionPlannerSummaryHEadingLabel.text = "విముక్తి ప్లానర్ సారాంశం"
    //            self.todayRedemablePoinsHEading.text = "నేటికి రీడీమ్ చేయగల పాయింట్‌లు"
    //            self.todayRedemablePoinsHEading.text = "వపాయింట్లు"
    //            self.avgEarningsLabel.text = "నెలకు సగటు సంపాదన అవసరం"
    //            self.monthlyHeadingLabel.text = "వపాయింట్లు"
    //        }
    //    }
    @objc func checkVerificationStatus(){
        DispatchQueue.main.async{
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
//            vc!.delegate = self
//            vc!.titleInfo = ""
//            vc!.itsComeFrom = "AccountVerification"
//            vc!.descriptionInfo = "You are not allowled to redeem .Please contact your administrator"
//            vc!.modalPresentationStyle = .overCurrentContext
//            vc!.modalTransitionStyle = .crossDissolve
//            self.present(vc!, animated: true, completion: nil)
            self.view.makeToast("redeem_failed_contact_to_admin".localiz(), duration: 3.0, position: .bottom)
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func redeemButton(_ sender: Any) {
//
//
//        print(self.selectedCatalogueID)
//        for data in self.VM.myCartListArray{
//            print(data.catalogueId!, "sadjfkljsadfkjsadlfjasdf")
//        }
//
//        let filterCategory = self.VM.myCartListArray.filter { $0.catalogueId == self.selectedCatalogueID}
//
//        if filterCategory.count > 0{
//            DispatchQueue.main.async{
////                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
////                vc!.delegate = self
////                vc!.titleInfo = ""
////
////                vc!.descriptionInfo = "Product is already added in the Redeem list"
////
////                vc!.modalPresentationStyle = .overCurrentContext
////                vc!.modalTransitionStyle = .crossDissolve
////                self.present(vc!, animated: true, completion: nil)
//                self.view.makeToast("Product is already added in the Redeem list",duration: 2.0,position: .bottom)
//            }
//        }else{
//            print(self.totalCartValue)
//            print(self.pointBalance)
//            if self.totalCartValue <= (Int(self.pointBalance) ?? 0) {
//                let calcValue = self.totalCartValue + Int(self.productPoints)
//                if calcValue <= (Int(self.pointBalance) ?? 0) {
//                    if self.verifiedStatus != 1{
//
////                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
////                        vc!.delegate = self
////                        vc!.titleInfo = ""
////                        vc!.descriptionInfo = "You are not allowled to redeem .Please contact your administrator"
////                        vc!.modalPresentationStyle = .overCurrentContext
////                        vc!.modalTransitionStyle = .crossDissolve
////                        self.present(vc!, animated: true, completion: nil)
//                        self.view.makeToast("You are not allowled to redeem .Please contact your administrator",duration: 2.0,position: .bottom)
//
//                    }else{
//                       // self.verifyAdhaarExistencyApi()
//
//                    }
//                }else{
//                    DispatchQueue.main.async{
////                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
////                        vc!.delegate = self
////                        vc!.titleInfo = ""
////                        //  if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
////                        vc!.descriptionInfo = "Insufficent Point Balance"
////                        //                            }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
////                        //                                vc!.descriptionInfo = "अपर्याप्त अंक संतुलन"
////                        //                            }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
////                        //                                vc!.descriptionInfo = "অপর্যাপ্ত পয়েন্ট ব্যালেন্স"
////                        //                            }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "4"{
////                        //                                vc!.descriptionInfo = "సరిపోని పాయింట్లు బ్యాలెన్స్"
////                        //                            }
////                        vc!.modalPresentationStyle = .overCurrentContext
////                        vc!.modalTransitionStyle = .crossDissolve
////                        self.present(vc!, animated: true, completion: nil)
//                        self.view.makeToast("Insufficent Point Balance",duration: 2.0,position: .bottom)
//                    }
//                }
//            }else{
//                DispatchQueue.main.async{
////                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
////                    vc!.delegate = self
////                    vc!.titleInfo = ""
////                    //                        if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
////                    vc!.descriptionInfo = "Insufficent Point Balance"
////                    //                        }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
////                    //                            vc!.descriptionInfo = "अपर्याप्त अंक संतुलन"
////                    //                        }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
////                    //                            vc!.descriptionInfo = "অপর্যাপ্ত পয়েন্ট ব্যালেন্স"
////                    //                        }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "4"{
////                    //                            vc!.descriptionInfo = "సరిపోని పాయింట్లు బ్యాలెన్స్"
////                    //                        }
////                    vc!.modalPresentationStyle = .overCurrentContext
////                    vc!.modalTransitionStyle = .crossDissolve
////                    self.present(vc!, animated: true, completion: nil)
//                    self.view.makeToast("Insufficent Point Balance",duration: 2.0,position: .bottom)
//                }
//            }
//
//        }
//
//
//    }
    @IBAction func removeButton(_ sender: Any) {
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        return
        }
        removeProductInPlanner()
    }
    
    func plannerListing(){
        let parameters = [
            "ActionType": "6",
            "Points": "\(self.pointBalance)",
            "ActorId": "\(userID)"
        ] as [String : Any]
        print(parameters)
        self.VM.plannerListingApi(parameters: parameters) { response in
            self.VM.myPlannerListArray = response?.objCatalogueList ?? []
            print(self.VM.myPlannerListArray.count, "Planner List Cout")
            DispatchQueue.main.async {
                //self.loaderView.isHidden = true
                self.stopLoading()
            }
        }
        
    }

    
//    func addToCartApi(){
//        let parameters = [
//            "ActionType": "1",
//            "ActorId": "\(userID)",
//            "CatalogueSaveCartDetailListRequest": [
//                [
//                    "CatalogueId": "\(selectedCatalogueID)",
//                    "DeliveryType": "1",
//                    "NoOfQuantity": "1"
//                ]
//            ],
//            "LoyaltyID": "\(loyaltyId)",
//            "MerchantId": "1"
//        ] as [String: Any]
//        print(parameters)
//        self.VM.addToCart(parameters: parameters) { response in
//
//            print(response?.returnValue ?? 0, "Added TO Cart")
//
//            if response?.returnValue == 1{
//                DispatchQueue.main.async{
//
////                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
////                    vc!.delegate = self
////                    vc!.titleInfo = ""
////
////                    //                    if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
////                    vc!.descriptionInfo = "Product has been added to Cart"
////                    //                     }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
////                    //                         vc!.descriptionInfo = "उत्पाद कार्ट में जोड़ दिया गया है"
////                    //                    }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
////                    //                        vc!.descriptionInfo = "পণ্য কার্টে যোগ করা হয়েছে"
////                    //                    }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "4"{
////                    //                        vc!.descriptionInfo = "ఉత్పత్తి కార్ట్‌కి జోడించబడింది"
////                    //                      }
////                    vc!.modalPresentationStyle = .overCurrentContext
////                    vc!.modalTransitionStyle = .crossDissolve
////                    self.present(vc!, animated: true, completion: nil)
//                    self.view.makeToast("Product has been added to Cart",duration: 2.0,position: .bottom)
//                }
//            }else{
//                DispatchQueue.main.async{
////                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
////                    vc!.delegate = self
////                    vc!.titleInfo = ""
////                    //                    if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
////                    vc!.descriptionInfo = "Something went wrong!"
////                    //                     }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
////                    //                         vc!.descriptionInfo = "कुछ गलत हो गया!"
////                    //                    }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
////                    //                        vc!.descriptionInfo = "কিছু ভুল হয়েছে!"
////                    //                    }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "4"{
////                    //                        vc!.descriptionInfo = "ఎక్కడో తేడ జరిగింది!"
////                    //                      }
////                    vc!.modalPresentationStyle = .overCurrentContext
////                    vc!.modalTransitionStyle = .crossDissolve
////                    self.present(vc!, animated: true, completion: nil)
//                    self.view.makeToast("Something went wrong!",duration: 2.0,position: .bottom)
//                }
//            }
//            DispatchQueue.main.async {
//                self.loaderView.isHidden = true
//                self.stopLoading()
//            }
//
//        }
//
//    }
    func removeProductInPlanner(){
        let parameters = [
            "ActionType": 17,
            "ActorId": "\(userID)",
            "RedemptionPlannerId": "\(selectedPlannerID)"
        ] as [String: Any]
        print(parameters)
        self.VM.removePlannedProduct(parameters: parameters) { response in
            if response?.returnValue == 1{
                self.plannerListing()
                self.removedDreamGiftPop()
//                self.navigationController?.popViewController(animated: true)
                
            }else{
                DispatchQueue.main.async{
//                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
//                    vc!.delegate = self
//                    vc!.titleInfo = ""
//                    //                    if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "1"{
//                    vc!.descriptionInfo = "Something went wrong!"
//                    //                     }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "2"{
//                    //                         vc!.descriptionInfo = "कुछ गलत हो गया!"
//                    //                    }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "3"{
//                    //                        vc!.descriptionInfo = "কিছু ভুল হয়েছে!"
//                    //                    }else if UserDefaults.standard.string(forKey: "LanguageLocalizable") == "4"{
//                    //                        vc!.descriptionInfo = "ఎక్కడో తేడ జరిగింది!"
//                    //                      }
//                    vc!.modalPresentationStyle = .overCurrentContext
//                    vc!.modalTransitionStyle = .crossDissolve
//                    self.present(vc!, animated: true, completion: nil)
//                    self.loaderView.isHidden = true
                    
                    self.view.makeToast("Something_went_wrong_error".localiz(), duration: 3.0, position: .bottom)
                    self.stopLoading()
                }
            }
            
        }
    }
    
//    func myCartList(){
//        let parameters = [
//            "ActionType": "2",
//            "LoyaltyID": "\(loyaltyId)"
//        ] as [String: Any]
//        print(parameters)
//        self.VM.myCartList(parameters: parameters) { response in
//            self.VM.myCartListArray = response?.catalogueSaveCartDetailListResponse ?? []
//            print(self.VM.myCartListArray.count)
//            for data in self.VM.myCartListArray{
//                self.totalCartValue = Int(data.sumOfTotalPointsRequired ?? 0.0)
//                print(self.totalCartValue, "TotalValue")
//            }
//            self.loaderView.isHidden = true
//            self.stopLoading()
//        }
//    }
    
//    func verifyAdhaarExistencyApi(){
//
//        let parameter = [
//            "ActionType": 154,
//            "ActorId": self.userID
//        ] as [String: Any]
//        print(parameter)
//        self.VM.adhaarNumberExistsApi(parameters: parameter) { response in
//
//            let result = response?.lstAttributesDetails ?? []
//
//            if result.count != 0 {
//                let sortedValues = String(result[0].attributeValue ?? "").split(separator: ":")
//                print(sortedValues[0], "asdfsadfas")
//                print(self.verifiedStatus)
//                if sortedValues[0] == "1"{
//                    self.addToCartApi()
//                }else{
//                    DispatchQueue.main.async{
//                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
//                        vc!.delegate = self
//                        vc!.titleInfo = ""
//
//                        vc!.descriptionInfo = "\(sortedValues[1])"
//
//                        vc!.modalPresentationStyle = .overCurrentContext
//                        vc!.modalTransitionStyle = .crossDissolve
//                        self.present(vc!, animated: true, completion: nil)
//                        self.loaderView.isHidden = true
//                        self.stopLoading()
//                    }
//                }
//            }
//        }
//    }
//    func playAnimation(){
//        animationView11 = .init(name: "Loader_v4")
//        animationView11!.frame = loaderAnimatedView.bounds
//        // 3. Set animation content mode
//        animationView11!.contentMode = .scaleAspectFit
//        // 4. Set animation loop mode
//        animationView11!.loopMode = .loop
//        // 5. Adjust animation speed
//        animationView11!.animationSpeed = 0.5
//        loaderAnimatedView.addSubview(animationView11!)
//        // 6. Play animation
//        animationView11!.play()
//
//    }
    
}

extension FG_DreamGiftDetailsVC{
    
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
    
    
    
    func addToCartApi(){
        
        let parameter = [
            "ActionType": "1",
            "ActorId": "\(self.userID)",
            "CatalogueSaveCartDetailListRequest": [
                [
                    "CatalogueId": "\(selectedCatalogueID)",
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
    
    func removedDreamGiftPop(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
        vc!.delegate = self
        vc!.itsComeFrom = "LodgeQuery"
        vc!.descriptionInfo = "product_removed_success".localiz()
        vc!.modalPresentationStyle = .overCurrentContext
        vc!.modalTransitionStyle = .crossDissolve
        present(vc!, animated: true, completion: nil)
    }
}
