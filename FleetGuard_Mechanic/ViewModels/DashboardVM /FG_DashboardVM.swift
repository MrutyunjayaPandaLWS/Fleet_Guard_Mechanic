//
//  FG_DashboardVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 01/02/2023.
//

import UIKit
import LanguageManager_iOS

class FG_DashboardVM: popUpDelegate{
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    
    weak var VC: FG_DashBoardVC?
    weak var VC1: FG_SideMenuVC?
    var requestApis = RestAPI_Requests()
    var pushID = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
    var categoryListArray = [LstAttributesDetails]()
    var pointBalence = [ObjCustomerDashboardList11]()
    var myPlannerListArray = [ObjCatalogueList2]()
    var totalPointBalence = 0
    var deviceID =  UserDefaults.standard.string(forKey: "deviceID") ?? ""
    
    func dashboardApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.dashboardApi(parameters: parameter) { (result, error) in
            if error == nil{
                self.VC?.stopLoading()
                if result != nil{
                    self.VC?.stopLoading()
                    print(self.deviceID,"skjns")
                    print(result?.deviceID,"kshjk")
                    if self.deviceID != result?.deviceID{
                        DispatchQueue.main.async {
                            self.VC?.stopLoading()
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                            vc!.delegate = self
                            vc!.descriptionInfo = "other_device_Login_error".localiz()
                            vc!.itsComeFrom = "DeviceLogedIn"
                            vc!.modalPresentationStyle = .overCurrentContext
                            vc!.modalTransitionStyle = .crossDissolve
                            self.VC?.present(vc!, animated: true, completion: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            let dashboardDetails = result?.objCustomerDashboardList ?? []
                            if dashboardDetails.count != 0 {
                                UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].memberSince, forKey: "MemberSince")
                                print(result?.objCustomerDashboardList?[0].memberSince ?? "", "Membersince")
                                print(result?.objCustomerDashboardList?[0].notificationCount ?? "", "NotificationCount")
                                print(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? "", "totalpoints")
                                UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? "", forKey: "TotalPoints")
                                UserDefaults.standard.setValue(result?.totalPendingCount ?? 0, forKey: "totalPendingCount")
                                self.VC?.plannerPointsLbl.text = "\(Int(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? 0) - (result?.totalPendingCount ?? 0))"
                                self.VC?.pendingRedemptionBal = Int(result?.objCustomerDashboardList?[0].redeemablePointsBalance ?? 0)
                                UserDefaults.standard.synchronize()
                                
                                
                            }
                            let customerFeedbakcJSON = result?.lstCustomerFeedBackJsonApi ?? []
                            if customerFeedbakcJSON.count != 0 {
                                if result?.lstCustomerFeedBackJsonApi?[0].customerStatus ?? 0 != 1{
                                    DispatchQueue.main.async{
                                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                        vc!.delegate = self
                                        vc!.descriptionInfo = "account_deactivated_error".localiz()
                                        vc!.modalPresentationStyle = .overCurrentContext
                                        vc!.modalTransitionStyle = .crossDissolve
                                        self.VC?.present(vc!, animated: true, completion: nil)
                                        self.VC?.stopLoading()
                                    }
                                }else{
                                    self.VC?.welcomeNameLbl.text = result?.lstCustomerFeedBackJsonApi?[0].firstName ?? ""
                                    //self.VC?.rplValueLbl.text = result?.lstCustomerFeedBackJsonApi?[0].passBookNumber ?? ""
                                    //self.VC?.retailerCodeLbl.text = result?.lstCustomerFeedBackJsonApi?[0].loyaltyId ?? ""
                                    //  self.VC?.totalValue.text = result?.lstCustomerFeedBackJsonApi?[0].loyaltyId ?? ""
                                    self.VC?.passbookLbl.text = "\(result?.lstCustomerFeedBackJsonApi?[0].passBookNumber ?? "")"
                                    UserDefaults.standard.setValue(result?.lstCustomerFeedBackJsonApi?[0].passBookNumber, forKey: "passBookNumber")
                                    UserDefaults.standard.setValue(result?.lstCustomerFeedBackJsonApi?[0].firstName, forKey: "FirstName")
                                    
                                    UserDefaults.standard.setValue(result?.lstCustomerFeedBackJsonApi?[0].loyaltyId, forKey: "LoyaltyId")
                                    self.VC?.loyaltyId = result?.lstCustomerFeedBackJsonApi?[0].loyaltyId ?? ""
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].merchantEmail ?? "", forKey: "MerchantEmail")
                                    print(result?.lstCustomerFeedBackJsonApi?[0].verifiedStatus ?? "")
                                    
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].verifiedStatus ?? "4", forKey: "verificationStatus")
                                    
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].customerMobile ?? "", forKey: "Mobile")
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].firstName ?? "", forKey: "FirstName")
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].lastName ?? "", forKey: "LastName")
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].customerEmail ?? "", forKey: "CustomerEmail")
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].merchantId ?? "", forKey: "MerchantID")
                                    UserDefaults.standard.set(result?.lstCustomerFeedBackJsonApi?[0].referralCode ?? "", forKey: "ReferralCode")
                                    UserDefaults.standard.synchronize()
                                }
                            }
                            self.VC?.stopLoading()
                        }
                    }
                    //                    self.VC?.dashboardPointsApi()
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
            }
        }
    }
    
    func dashboardTotalPointsApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.dashboardTotalPointsApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        let dashboardDetails = result?.objCustomerDashboardList ?? []
                        if dashboardDetails.count != 0 {
                            print("\(result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0), Total Earned Points")
                            UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0, forKey: "TotalPoints")
                            //self.VC?.totalValue.text = "\(result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0)"
                            UserDefaults.standard.synchronize()
                        }
                        self.VC?.stopLoading()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
            }
        }
    }
    
    func productCategoryListingApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.productsCategoryListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        self.categoryListArray = result?.lstAttributesDetails ?? []
                        if self.categoryListArray.count != 0 {
                            self.VC?.noDatafoundLbl.isHidden = true
                            self.VC?.categoryCollectionView.isHidden = false
                            self.VC?.categoryCollectionView.reloadData()
                        }else{
                            self.VC?.noDatafoundLbl.isHidden = false
                            self.VC?.categoryCollectionView.isHidden = true
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.noDatafoundLbl.isHidden = true
                        self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.noDatafoundLbl.isHidden = true
                    self.VC?.stopLoading()
                }
            }
        }
    }
    
    func pointBalenceAPI(parameter: JSON){
                DispatchQueue.main.async {
                    self.VC?.startLoading()
                }
        self.requestApis.pointBalenceAPI(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                                            self.VC?.stopLoading()
                        
                        if result?.objCustomerDashboardList?.count != 0 {
                            self.pointBalence = result?.objCustomerDashboardList ?? []
                            self.totalPointBalence = result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0
                            let totalPendingCount = UserDefaults.standard.string(forKey: "totalPendingCount")
                            
                            
                            let totalPointsData = (self.totalPointBalence) - Int(totalPendingCount ?? "0")!
                            
//                            UserDefaults.standard.setValue(result?.objCustomerDashboardList?[0].totalEarnedPoints, forKey: "totalEarnedPoints")
                            UserDefaults.standard.setValue(totalPointsData, forKey: "totalEarnedPoints")
                            UserDefaults.standard.setValue(self.totalPointBalence, forKey: "totalPointsBal11")
                            UserDefaults.standard.set(result?.objCustomerDashboardList?[0].redeemablePointsBalance, forKey: "redeemablePointsBalance")
                            self.VC?.totalPtsBalance.text = "\(result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0)"
                            
                            
                           
                            
                            UserDefaults.standard.set(true, forKey: "AfterLog")
                            UserDefaults.standard.synchronize()
                            
                            self.VC?.plannerListing(totalPointBalence: "\(result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0)" )
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                                            self.VC?.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                                    self.VC?.stopLoading()
                }
            }
        }
        
    }
    func dreamGiftAPI(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.plannerListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        self.myPlannerListArray = result?.objCatalogueList ?? []
                        print(self.myPlannerListArray.count, "Planner List Cout")
                        
                            if self.myPlannerListArray.count > 0 {
                                self.VC?.dreamGiftDetailsOutBtn.isHidden = true
                                self.VC?.dreamGiftImageView.isHidden = true
                                self.VC?.addYourDreamLbl.isHidden = true
                                self.VC?.productViewHeight.constant = 170
                                self.VC?.heightOfTheView.constant = 627
                                //UserDefaults.standard.setValue(result?.totalPendingCount ?? 0, forKey: "totalPendingCount")
                                let totalPoints = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? ""
                                let totalPendingCount = UserDefaults.standard.string(forKey: "totalPendingCount")
                                
                                let totalPointsData = Int(totalPoints)! - Int(totalPendingCount ?? "")!
                                self.VC?.plannerPointsLbl.text = "\(totalPoints)"
//                                let totalPoints = Int(totalPoints)! - Int(totalPendingCount ?? "")!
//                                self.totalPts.text = "\(totalPoints)"
                                
                                
                                //self.VC?.plannerPointsLbl.text = "\(Int(result?.objCatalogueList?[0].pointBalance ?? 0))"
                                self.VC?.plannerCategoryLbl.text = "\("Category".localiz()) : \(result?.objCatalogueList?[0].catogoryName ?? "-")"
                                self.VC?.plannerProductLbl.text = "\(result?.objCatalogueList?[0].productName ?? "-")"
                                // self.VC?.plannerPointsRequiredLbl.text = "\(result?.objCatalogueList?[0].productName ?? "-")"
                                let image =  imageUrl + (result?.objCatalogueList?[0].productImage ?? "").replacingOccurrences(of: " ", with: "%20")
                                self.VC?.plannerImageView.kf.setImage(with: URL(string: "\(String(describing: image ))"), placeholder: UIImage(named: "Humsafar Logo PNG 1"))
                                self.VC?.plannerPointsReqPointsLbl.text = "\(Int(result?.objCatalogueList?[0].pointsRequired ?? 0))"
                                var pointBal = CGFloat(result?.objCatalogueList?[0].pointBalance ?? 0)
                                var requiredBal = CGFloat(result?.objCatalogueList?[0].pointsRequired ?? 0)
                                var progressPercent = CGFloat(pointBal/requiredBal) * 100.0
                                self.VC?.progressViewDreamGift.progress = Float((progressPercent / 100.0) )
                                if progressPercent < 100.0{
                                    self.VC?.progressBarLbl.text = "\(Int(progressPercent)) %"
                                    self.VC?.progressCircleViewLeading.constant = ((self.VC?.progressViewDreamGift.frame.width ?? 0) * CGFloat(progressPercent/100))
                                }else{
                                    self.VC?.progressBarLbl.text = "100 %"
                                    self.VC?.progressCircleViewLeading.constant = self.VC?.progressViewDreamGift.frame.width ?? 0
                                }
                                
                                
                            }else{
                                self.VC?.dreamGiftDetailsOutBtn.isHidden = false
                                self.VC?.dreamGiftImageView.isHidden = false
                                self.VC?.addYourDreamLbl.isHidden = false
                                self.VC?.productViewHeight.constant = 100
                                self.VC?.heightOfTheView.constant = 550
                                
                            }
                        self.VC?.stopLoading()
                        }
                }else{
                    DispatchQueue.main.async {
                        print(error?.localizedDescription)
                        self.VC?.stopLoading()
                    }
                    
                }
            }else{
                DispatchQueue.main.async {
                    print(error?.localizedDescription)
                    self.VC?.stopLoading()
                }
            }
                
            }
        
    }
    
    
    func dashboardImagesAPICall(parameters: JSON, completion: @escaping (DashboardBannerImageModels?) -> ()) {
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.dashboardBanner_API(parameters: parameters) { (result, error) in
            if error == nil {
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        print(result)
                        //self.VC?.stopLoading()
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        completion(result)
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    self.VC?.bannerImage.isHidden = true
                    self.VC?.emptyImageView.isHidden = false
                    self.VC?.stopLoading()
                }
                
            }
            
        }
    }
    
    func offersandPromotions(parameters: JSON, completion: @escaping (PromotionListingModels?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.promotionsListingAPI(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
                
            }
        }
        
    }
    
    
    func deleteAccount(parameters: JSON, completion: @escaping (DeleteAccountModels?) -> ()) {
        self.VC1?.startLoading()
        self.requestApis.deleteAccountApi(parameters: parameters) { (result, error) in
            if error == nil {
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        self.VC1?.stopLoading()
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        self.VC1?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    completion(result)
                    self.VC1?.stopLoading()
                }
                
            }
            
        }
    }
    
}
