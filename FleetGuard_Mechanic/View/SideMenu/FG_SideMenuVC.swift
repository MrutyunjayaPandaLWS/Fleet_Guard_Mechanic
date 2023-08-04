//
//  FG_SideMenuVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 18/01/2023.
//

import UIKit
import SlideMenuControllerSwift
import LanguageManager_iOS


class FG_SideMenuVC: BaseViewController, popUpDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {
        self.closeLeft()
        
        UserDefaults.standard.set(false, forKey: "IsloggedIn?")
        var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
        if #available(iOS 13.0, *) {
            DispatchQueue.main.async {
                let pushID = UserDefaults.standard.string(forKey: "UD_DEVICE_TOKEN") ?? ""
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.set(true, forKey: "AfterLog")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(pushID, forKey: "UD_DEVICE_TOKEN")
                UserDefaults.standard.set(languageStatus, forKey: "LanguageName")
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                sceneDelegate.setInitialViewAsRootViewController()
             //   self.clearTable2()
            }
        } else {
            DispatchQueue.main.async {
                let pushID = UserDefaults.standard.string(forKey: "UD_DEVICE_TOKEN") ?? ""
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.set(true, forKey: "AfterLog")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(pushID, forKey: "UD_DEVICE_TOKEN")
                UserDefaults.standard.set(languageStatus, forKey: "LanguageName")
                if #available(iOS 13.0, *) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.setInitialViewAsRootViewController()
                } else {
                    // Fallback on earlier versions
                }
                
              //  self.clearTable2()
            }
        }
    }
    

    @IBOutlet weak var GarageNameLbl: UILabel!
    @IBOutlet weak var garagenameTitleLbl: UILabel!
    @IBOutlet weak var sideMenuTableHeight: NSLayoutConstraint!
    @IBOutlet weak var passbookNumber: UILabel!
    @IBOutlet weak var passbookNum: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var totalBalanceLbl: UILabel!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    var requestApis = RestAPI_Requests()
    var sideMenuArray = ["profile", "My_Ledger", "My_Redemption_History", "Redemption_Catalogue", "Product_Catalogue", "Dream_Gift", "Offers_promotions", "Lodge_Query", "About", "FAQs", "T&C", "Logout","Delete"]
    var sideMenuTitleArray = [String]()
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var userSince = UserDefaults.standard.string(forKey: "MemberSince") ?? "-"
    var VM = FG_DashboardVM()
    
//    UserDefaults.standard.set(result?.objCustomerDashboardList?[0].redeemablePointsBalance, forKey: "redeemablePointsBalance")
//    self.VC?.totalValue.text = "\(result?.objCustomerDashboardList?[0].totalEarnedPoints ?? 0)"
//    UserDefaults.standard.set(result?.objCustomerDashboardList?[0].totalEarnedPoints, forKey: "totalEarnedPoints")
    let redeemablePointsBalance = UserDefaults.standard.string(forKey: "redeemablePointsBalance") ?? "0"
    let totalEarnedPoints = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC1 = self

        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        //self.sideMenuTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.menuTitleArray()
        print(CGFloat(sideMenuArray.count * 50))
        self.sideMenuTableHeight.constant = 650
        self.sinceLbl.text = "\("Since".localiz()) \(userSince)"
        totalBalanceLbl.text = "total_Point_bal".localiz()
        passbookNum.text = "passbook_number".localiz()
        garagenameTitleLbl.text = "Garage Name".localiz()
        dashboardApi()
    }
    
    
    func dashboardApi(){
        let parameter = [
            "ActorId":"\(self.userId)"
        ] as [String: Any]
        print(parameter)
        self.requestApis.dashboardApi(parameters: parameter) { (result, error) in
            if error == nil{
                self.stopLoading()
                if result != nil{
                    self.stopLoading()
                DispatchQueue.main.async {
                   let dashboardDetails = result?.objCustomerDashboardList ?? []
                    if dashboardDetails.count != 0 {
                        self.userNameLbl.text = result?.lstCustomerFeedBackJsonApi?[0].firstName ?? "-"
                        self.passbookNumber.text = result?.lstCustomerFeedBackJsonApi?[0].passBookNumber ?? "-"
                        self.totalBalance.text = "\(self.totalEarnedPoints)"
                    
                        let imageData = (result?.lstCustomerFeedBackJsonApi?[0].customerImage)?.dropFirst(1) ?? ""
                        self.profileImage.kf.setImage(with: URL(string: "\(Promo_ImageData)\(imageData)"), placeholder: UIImage(named: "ic_default_img"));
                        self.GarageNameLbl.text = "\(result?.lstCustomerFeedBackJsonApi?[0].ownerName ?? "-")"
                    }
                    self.stopLoading()
                }
                }else{
                    DispatchQueue.main.async {
                    self.stopLoading()
                    }
                }
            }else{
                DispatchQueue.main.async {
                self.stopLoading()
                }
            }
        }
        
    }
    
    func menuTitleArray(){
        self.sideMenuTitleArray.removeAll()
        for data in self.sideMenuArray{
            sideMenuTitleArray.append(data)
        }
        self.sideMenuTableView.reloadData()
       
    }
    
//    func dashboardAPI() {
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
//          self.startLoading()
//        let parameters = [
//            "ActorId":"\(userId)"
//        ] as [String: Any]
//        print(parameters,"Dash")
//        self.VM.dashboardApi(parameters: parameters) { (response, error) in
//
//            DispatchQueue.main.async {
//                self.userNameLbl.text = response?.lstCustomerFeedBackJsonApi?[0].firstName ?? "-"
//                let customerImage = String(response?.lstCustomerFeedBackJsonApi?[0].customerImage ?? "").dropFirst(1)
//
//                let imageData = customerImage.split(separator: "~")
//                if imageData.count >= 2 {
//                    print(imageData[1],"jdsnjkdn")
//                    let totalImgURL = PROMO_IMG1 + (imageData[1])
//                    print(totalImgURL, "Total Image URL")
//                    //self.profileImage.kf_setImage(with: URL(string: totalImgURL), placeholderImage: UIImage(named: "icons8-life-cycle-96"))
//                }else{
//                    let totalImgURL = PROMO_IMG1 + customerImage
//                    print(totalImgURL, "Total Image URL")
//                    self.userImage.sd_setImage(with: URL(string: totalImgURL), placeholderImage: UIImage(named: "icons8-life-cycle-96"))
//                }
//                self.customerIDLbl.text = response?.lstCustomerFeedBackJsonApi?[0].loyaltyId ?? ""
//                self.totalPointsLbl.text = "Total Points \(response?.objCustomerDashboardList?[0].totalRedeemed ?? 0)"
//                self.loaderView.isHidden = true
//                self.stopLoading()
//            }
//        }
//    })
//}
    
    
    
    
}
extension FG_SideMenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FG_SideMenuTVC", for: indexPath) as! FG_SideMenuTVC
        cell.titleLbl.text = self.sideMenuTitleArray[indexPath.row].localiz()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //"Profile", "My Ledger", "My Redemption History", "Redemption Catalogue", "Product Catalogue", "Dream Gift", "My Promotions", "Lodge Query", "About", "FAQs", "T&C", "Logout"
        if indexPath.row == 0{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyProfileVC") as! FG_MyProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_StatementVC") as! FG_StatementVC
            vc.itsFrom = "SideMenu"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyRedemptionVC") as! FG_MyRedemptionVC
            vc.itsFrom = "SideMenu"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_RedemptionCatalogueVC") as! FG_RedemptionCatalogueVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_ProductCatalogueListVC") as! FG_ProductCatalogueListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 5{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DreamGiftVC") as! FG_DreamGiftVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 6{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyPromotionsVC") as! FG_MyPromotionsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_LodgeQueryVC") as! FG_LodgeQueryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 8{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_AboutVC") as! FG_AboutVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 9{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_FAQsVC") as! FG_FAQsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 10{
            self.closeLeft()
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_TermsandconditionsVC") as! FG_TermsandconditionsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 11{
            self.closeLeft()
            
            UserDefaults.standard.set(false, forKey: "IsloggedIn?")
            var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
            
            if #available(iOS 13.0, *) {
                DispatchQueue.main.async {
                    let pushID = UserDefaults.standard.string(forKey: "UD_DEVICE_TOKEN") ?? ""
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.setValue(pushID, forKey: "UD_DEVICE_TOKEN")
                    UserDefaults.standard.set(true, forKey: "AfterLog")
                    UserDefaults.standard.set(languageStatus, forKey: "LanguageName")
                    UserDefaults.standard.synchronize()
                    let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                    sceneDelegate.setInitialViewAsRootViewController()
                 //   self.clearTable2()
                }
            } else {
                DispatchQueue.main.async {
                    let pushID = UserDefaults.standard.string(forKey: "UD_DEVICE_TOKEN") ?? ""
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.setValue(pushID, forKey: "UD_DEVICE_TOKEN")
                    UserDefaults.standard.set(true, forKey: "AfterLog")
                    UserDefaults.standard.set(languageStatus, forKey: "LanguageName")
                    UserDefaults.standard.synchronize()
                    if #available(iOS 13.0, *) {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.setInitialViewAsRootViewController()
                    } else {
                        // Fallback on earlier versions
                    }
                    
                  //  self.clearTable2()
                }
            }
        }else if indexPath.row == 12{
            print("Your accout is deleted")
            deleteAccount()
        }
        
    }
    
    func deleteAccount(){
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{

                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                vc!.descriptionInfo = "No_Internet".localiz()
                vc!.itsComeFrom = ""
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
                
            }
        }else{
            let alert = UIAlertController(title: "", message: "are_sure_delete_account".localiz(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { UIAlertAction in
            let parameters = [
                "ActionType": 1,
                "userid":"\(self.userId)"
            ] as [String : Any]
            print(parameters)
                self.VM.deleteAccount(parameters: parameters) { response in
                    DispatchQueue.main.async {
                        print(response?.returnMessage ?? "-1")
                        if response?.returnMessage ?? "-1" == "1"{
                            DispatchQueue.main.async{
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                vc!.delegate = self
                                vc!.descriptionInfo = "Account_deleted_successfully".localiz()
                                vc!.itsComeFrom = "AccounthasbeenDeleted"
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.present(vc!, animated: true, completion: nil)
                                }
                        }else{
                            DispatchQueue.main.async{
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                vc!.delegate = self
                                vc!.descriptionInfo = "Something_went_wrong_error".localiz()
                                vc!.itsComeFrom = ""
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.present(vc!, animated: true, completion: nil)
                                
                                }
                        }
                      self.stopLoading()
                        }
                }
        }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        }

    }
}
