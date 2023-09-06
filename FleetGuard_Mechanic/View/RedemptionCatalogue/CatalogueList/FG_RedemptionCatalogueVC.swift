//
//  FG_RedemptionCatalogueVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit
import ImageSlideshow
import Lottie
import LanguageManager_iOS

protocol SendDataDelegate: AnyObject{
    func moveToProductList(_ vc: FG_RedemptionCatalogueVC)
}

class FG_RedemptionCatalogueVC: BaseViewController, DidTapActionDelegate, popUpDelegate,sendProductDelegate {
    func addAndRemovePlannerList(_ cell: FG_RedemptionCatalogueTVC) {
        guard let tappedIndexPath = self.catalogueListTableView.indexPath(for: cell) else {return}
    }
    
    
    func addToDreamGift(_ cell: FG_RedemptionCatalogueTVC) {
        guard let tappedIndexPath = self.catalogueListTableView.indexPath(for: cell) else {return}
        self.addtoDreamGift(catalogueId: self.VM.redemptionCatalougeListArray[tappedIndexPath.row].catalogueId ?? 0)
        
    }
    
    func prodiuctDetails(_ vc: FG_CatalogueFilterView) {
        if vc.tableViewData == "Points Range"{
            self.VM.redemptionCatalougeListArray.removeAll()
            self.miniValue = vc.minimumValueTF.text ?? ""
            self.maximiumValue = vc.maximumValueTF.text ?? ""
            let a = "-"
            let minMax = "\(miniValue)"+"\(a)"+"\(maximiumValue)"
            print(minMax,"ksjdksnd")
            self.categoryIDs = "\(vc.categoryID)"
            self.pointsRangeDatas = "\(vc.collectionViewData)"
            
            if self.miniValue != "" && self.maximiumValue != "" {
                if maximiumValue <= miniValue{
                    self.view.makeToast("Maximum feild should be higher then Minimum field", duration: 3.0, position: .bottom)
                
                }else{
                   // if minMax != "-"{
                        self.pointsRangeDatas = "\(minMax)"
//                    }else{
//                        self.pointsRangeDatas = "\(vc.collectionViewData)"
//                    }
                }
            }
            self.redemptionCatalogueListApi(startIndex: startindex)
        }else{
            self.VM.redemptionCatalougeListArray.removeAll()
            self.pointsRangeDatas = "\(vc.collectionViewData)"
            self.categoryIDs = "\(vc.categoryID)"
            self.redemptionCatalogueListApi(startIndex: startindex)
        }
        //self.redemptionCatalogueListApi(startIndex: startindex)
    }
    
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    @IBOutlet weak var levelTwoView: UIView!
    @IBOutlet weak var passBookNumber: UILabel!
    @IBOutlet weak var passBookLbl: UILabel!
    @IBOutlet weak var totalPts: UILabel!
    @IBOutlet weak var totalPtsBalanceLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var headerTextLbl: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var catalogueListTableView: UITableView!
    
    @IBOutlet weak var noDataFoundLbl: UILabel!
    var VM = FG_RedemptionCatalogueVM()
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var totalPoints = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? ""
    
    var sortBy = ""
    var cartTotalPts = 0
    var catalogueId = 0
    var myCartIds = [Int]()
    var comingFrom = ""
    var categoryIDs = ""
    var pointsRangeDatas = ""
    
    var noofelements = 0
    var startindex = 1
    
    var miniValue = ""
    var maximiumValue = ""
    var plannerListingData = ""
    var dreamGiftListArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        plannerListing()
        self.countLbl.isHidden = true
        self.catalogueListTableView.delegate = self
        self.catalogueListTableView.dataSource = self
        self.levelTwoView.clipsToBounds = true
        noDataFoundLbl.isHidden = true
        self.levelTwoView.layer.cornerRadius = 20
        self.levelTwoView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        searchTF.placeholder = "Search by product name".localiz()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.VM.redemptionCatalougeListArray.removeAll()
        localization()
        self.totalPts.text = "\(UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? "")"
        self.passBookNumber.text = self.loyaltyId
        catalogueListTableView.reloadData()
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            self.myCartListApi()
            self.plannerListing()
        }
        
    }
    
    func localization(){
        totalPtsBalanceLbl.text = "points".localiz()
        passBookLbl.text = "passbook_number".localiz()
        headerTextLbl.text = "redemption_catalogue".localiz()
        
    }

    @IBAction func filterBtn(_ sender: Any) {
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                return
                }
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_CatalogueFilterView") as! FG_CatalogueFilterView
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func backBtn(_ sender: Any) {
        
       // if comingFrom == "Statement"{
            self.navigationController?.popToRootViewController(animated: true)
//        }else{
//            self.navigationController?.popToRootViewController(animated: true)
//        }
    }
    @IBAction func cartBtn(_ sender: Any) {
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                return
                }
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyCartVC") as! FG_MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func redemptionCatalogueListApi(startIndex:Int){
        let parameter = [
                "ActionType": "6",
                "ActorId": "\(self.userId)",
                "NoOfRows": 20,
                "ObjCatalogueDetails": [
                    "MerchantId": 1,
                    "CatogoryId": "\(categoryIDs)",
                    "MultipleRedIds": "\(pointsRangeDatas)",
                ],
                "SearchText": "\(searchTF.text ?? "")",
                "Domain": "FLEETGUARD",
                "StartIndex": startIndex,
                "Sort": "",
                "VendorProductCode":"MLP"
        ] as [String: Any]
        print(parameter)
        self.VM.redemptionCatalogueListApi(parameter: parameter)
    }
    
    func myCartListApi(){
        let parameter = [
            "ActionType": "2",
            "LoyaltyID": "\(self.loyaltyId)"
        ] as [String: Any]
        self.VM.redemptionCatalogueMyCartListApi(parameter: parameter)
    }
    
    func addToCartApi(catalogueId: Int){
        
        let parameter = [
            "ActionType": "1",
            "ActorId": "\(self.userId)",
            "CatalogueSaveCartDetailListRequest": [
                [
                    "CatalogueId": catalogueId,
                    "DeliveryType": "1",
                    "NoOfQuantity": "1"
                ]
            ],
            "LoyaltyID": "\(self.loyaltyId)",
            "MerchantId": "1"
        ] as [String: Any]
        print(parameter)
        self.VM.redemptionCatalogueAddToCartApi(parameter: parameter)
    }
    
    func addtoDreamGift (catalogueId: Int) {
        let parameter = [
            "ActionType":0,
            "ActorId":"\(self.userId)",
            "ObjCatalogueDetails":[
                "CatalogueId":catalogueId
            ]
        ] as [String: Any]
        print(parameter)
        self.VM.addToDremGiftAPI(parameter: parameter)
    }
    
@IBAction func searchByEditingTFAct(_ sender: Any) {
//        if self.searchTF.text!.count != 0 || self.searchTF.text ?? "" != ""{
//            if self.VM.redemptionCatalougeListArray.count > 0 {
//                let arr = self.VM.redemptionCatalougeListArray.filter{ ($0.productName!.localizedCaseInsensitiveContains(self.searchTF.text!))}
//                print(arr.count,"dsds")
//                if self.searchTF.text! != ""{
//                    if arr.count > 0 {
//                        self.VM.redemptionCatalougeListArray.removeAll(keepingCapacity: true)
//                        print(VM.redemptionCatalougeListArray.count,"jshdhs")
//                        self.VM.redemptionCatalougeListArray = arr
//                        self.catalogueListTableView.reloadData()
//                        self.catalogueListTableView.isHidden = false
//                        noDataFoundLbl.isHidden = true
//                    }else {
//                        self.VM.redemptionCatalougeListArray = self.VM.productArray
//                        self.catalogueListTableView.reloadData()
//                        self.catalogueListTableView.isHidden = true
//                        noDataFoundLbl.isHidden = false
//                    }
//                }else{
//                    self.VM.redemptionCatalougeListArray = self.VM.productArray
//                    self.catalogueListTableView.reloadData()
//                    catalogueListTableView.isHidden = true
//                    noDataFoundLbl.isHidden = false
//                }
//                let searchText = self.searchTF.text!
//                if searchText.count > 0 || self.VM.redemptionCatalougeListArray.count == self.VM.productArray.count {
//                    self.catalogueListTableView.reloadData()
//                }
//            }
//        }else{
//            self.VM.redemptionCatalougeListArray.removeAll()
//            self.catalogueListTableView.reloadData()
//            //self.itsFrom = "Category"
//            self.redemptionCatalogueListApi(startIndex: startindex)
//            noDataFoundLbl.isHidden = true
//        }
    if self.searchTF.text!.count != 0 || self.searchTF.text ?? "" != ""{
        self.VM.redemptionCatalougeListArray.removeAll()
        self.catalogueListTableView.reloadData()
        self.redemptionCatalogueListApi(startIndex: startindex)
    }else{
        self.VM.redemptionCatalougeListArray.removeAll()
        self.catalogueListTableView.reloadData()
        //self.itsFrom = "Category"
        self.redemptionCatalogueListApi(startIndex: startindex)
        noDataFoundLbl.isHidden = true
    }
  
        
    }
    
    
    // Delegate:-
    func addToCartDidTap(_ cell: FG_RedemptionCatalogueTVC) {
        guard let tappedIndexPath = self.catalogueListTableView.indexPath(for: cell) else {return}
        
        let totalPts = Int(totalPoints)!
        let pointsRequired = self.VM.redemptionCatalougeListArray[tappedIndexPath.row].pointsRequired ?? 0 + self.cartTotalPts
        print(pointsRequired)
        if pointsRequired <= totalPts{
            self.addToCartApi(catalogueId: self.VM.redemptionCatalougeListArray[tappedIndexPath.row].catalogueId ?? 0)
        }else{
            DispatchQueue.main.async{
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Insufficient point balance"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
                
                self.view.makeToast("Insufficent_Point_Balance".localiz(), duration: 3.0, position: .bottom)
            }
        }
        
    }
    
    func detailsDidTap(_ cell: FG_RedemptionCatalogueTVC) {
        guard let tappedIndex = self.catalogueListTableView.indexPath(for: cell) else {return}
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_RedemptionCatalogueDetailsVC") as! FG_RedemptionCatalogueDetailsVC
        vc.isComeFrom = "Catalogue"
        //vc.delegate = self
        vc.productImages = self.VM.redemptionCatalougeListArray[tappedIndex.row].productImage ?? ""
        vc.prodRefNo = self.VM.redemptionCatalougeListArray[tappedIndex.row].redemptionRefno ?? ""
        vc.productCategory = self.VM.redemptionCatalougeListArray[tappedIndex.row].catogoryName ?? ""
        vc.productName = self.VM.redemptionCatalougeListArray[tappedIndex.row].productName ?? ""
        print(self.VM.redemptionCatalougeListArray[tappedIndex.row].productName ?? "","dkjhsid")
        vc.productPoint = "\(self.VM.redemptionCatalougeListArray[tappedIndex.row].pointsRequired ?? 0)"
        vc.productDetails = self.VM.redemptionCatalougeListArray[tappedIndex.row].productDesc ?? ""
        vc.termsandContions = self.VM.redemptionCatalougeListArray[tappedIndex.row].termsCondition ?? ""
        vc.catalogueId = self.VM.redemptionCatalougeListArray[tappedIndex.row].catalogueId ?? 0
        print(self.VM.redemptionCatalougeListArray[tappedIndex.row].isPlanner!)
//        vc.myPlannerListArray = self.VM.myPlannerListArray
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func plannerListing(){
        let parameters = [
            "ActionType": "6",
            "Points": totalPoints,
            "ActorId": "\(userId)"
        ] as [String : Any]
        print(parameters)
        self.VM.plannerListingApi(parameters: parameters) { response in
            self.VM.myPlannerListArray = response?.objCatalogueList ?? []
            print(self.VM.myPlannerListArray.count, "Planner List Cout")
            DispatchQueue.main.async {
                self.catalogueListTableView.reloadData()
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
            }
        }
        
    }
    
}
extension FG_RedemptionCatalogueVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.redemptionCatalougeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FG_RedemptionCatalogueTVC", for: indexPath) as! FG_RedemptionCatalogueTVC
        cell.selectionStyle = .none
        cell.delegate = self
        cell.productNameLbl.text = self.VM.redemptionCatalougeListArray[indexPath.row].productName ?? ""
        cell.categoryLbl.text = "\("Category".localiz()) / \(self.VM.redemptionCatalougeListArray[indexPath.row].catogoryName ?? "")"
        cell.pointsLbl.text = "\(self.VM.redemptionCatalougeListArray[indexPath.row].pointsRequired ?? 0)"
        let image = VM.redemptionCatalougeListArray[indexPath.row].productImage ?? ""
        if image.count != 0{
            let images = ("\(imageUrl)\(image)").replacingOccurrences(of: " ", with: "%20")
            cell.productImage.kf.setImage(with: URL(string: "\(String(describing: images))"), placeholder: UIImage(named: "Humsafar Logo PNG 1"))
            print(images)
        }else{
            cell.productImage.image = UIImage(named: "Humsafar Logo PNG 1")
        }
        
        
        let filterArray = self.myCartIds.filter{$0 == self.VM.redemptionCatalougeListArray[indexPath.row].catalogueId ?? 0}
        let productPoints = self.VM.redemptionCatalougeListArray[indexPath.row].pointsRequired ?? 0
        var filterDreamGiftArray = [ObjCatalogueList2]()
        if (self.VM.myPlannerListArray.count != 0){
            filterDreamGiftArray = self.VM.myPlannerListArray.filter{$0.catalogueId == self.VM.redemptionCatalougeListArray[indexPath.row].catalogueId}
        }
         
//        let catalogoueID = self.VM.redemptionCatalogueMyCartListArray[indexPath.row].catalogueId ?? 0
//        if dreamGiftListArray.contains(catalogoueID){
//            cell.addedToCartView.isHidden = true
//            cell.addToCartView.isHidden = true
//            cell.addedToDreamGiftView.isHidden = false
//            cell.addtoDreamGiftView.isHidden = true
//        }
//        let filterCategory = self.myCartIds.filter { $0 == self.VM.redemptionCatalougeListArray[indexPath.row].catalogueId ?? 0 }
//        let filterPlannerList = self.VM.myPlannerListArray.filter { $0.catalogueId == self.VM.redemptionCatalogueMyCartListArray[indexPath.row].catalogueId ?? 0 }
//        let productPoints = self.VM.redemptionCatalougeListArray[indexPath.row].pointsRequired ?? 0
//        if Int(self.totalPoints) ?? 0 >= productPoints{
//
//            cell.addedToCartView.isHidden = true
//            cell.addToCartView.isHidden = false
//            cell.addedToDreamGiftView.isHidden = true
//            cell.addtoDreamGiftView.isHidden = true
//        }else{
//            if self.VM.redemptionCatalogueMyCartListArray[indexPath.row].isPlanner! == true{
//                cell.addedToCartView.isHidden = true
//                cell.addToCartView.isHidden = true
//                cell.addedToDreamGiftView.isHidden = false
//                cell.addtoDreamGiftView.isHidden = true
//
//            }else{
//
//                cell.addedToCartView.isHidden = true
//                cell.addToCartView.isHidden = true
//                cell.addedToDreamGiftView.isHidden = true
//                cell.addtoDreamGiftView.isHidden = true
//
//
//            }
//        }
////        if filterCategory.count > 0 {
////            cell.addedToCart.isHidden = false
////            cell.addToPlanner.isHidden = true
////            cell.addToCartButton.isHidden = true
////            cell.addedToPlanner.isHidden = true
////        }
//        if filterPlannerList.count > 0 {
//            if Int(totalPoints) ?? 0 > Int(productPoints) {
//
//                cell.addedToCartView.isHidden = true
//                cell.addToCartView.isHidden = false
//                cell.addedToDreamGiftView.isHidden = true
//                cell.addtoDreamGiftView.isHidden = true
//
//            }else{
//
//                cell.addedToCartView.isHidden = true
//                cell.addToCartView.isHidden = true
//                cell.addedToDreamGiftView.isHidden = false
//                cell.addtoDreamGiftView.isHidden = true
//
//            }
//
//        }
        
        if Int(self.totalPoints) ?? 0 >= productPoints{
            if filterArray.count > 0 {
                cell.addedToCartView.isHidden = false
                cell.addToCartView.isHidden = true
            }else{
                cell.addedToCartView.isHidden = true
                cell.addToCartView.isHidden = false
            }
            cell.addtoDreamGiftView.isHidden = true
            cell.addedToDreamGiftView.isHidden = true
        }else{
            if filterDreamGiftArray.count > 0 {
                cell.addedToCartView.isHidden = true
                cell.addToCartView.isHidden = true
                cell.addedToDreamGiftView.isHidden = false
                cell.addToPlannerOutletBTN.setImage(UIImage(named: "favorite"), for: .normal)
                cell.addtoDreamGiftView.isHidden = true
            }else{
                cell.addedToCartView.isHidden = true
                cell.addToCartView.isHidden = true
                cell.addedToDreamGiftView.isHidden = true
                cell.addToPlannerOutletBTN.setImage(UIImage(named: "favorite-filled 1"), for: .normal)
                cell.addtoDreamGiftView.isHidden = false
            }
        }
     
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 160
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == VM.redemptionCatalougeListArray.count - 2{
                if noofelements == 20{
                    self.startindex = startindex + 1
                    self.redemptionCatalogueListApi(startIndex: startindex)
                }else if noofelements < 20{
                    return
                }else{
                    print("n0 more elements")
                    return
                }
            }
        }
    
}
