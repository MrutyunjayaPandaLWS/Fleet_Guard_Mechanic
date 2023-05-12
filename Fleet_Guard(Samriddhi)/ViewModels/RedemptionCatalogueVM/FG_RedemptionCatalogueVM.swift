//
//  FG_RedemptionCatalogueVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 03/02/2023.
//

import UIKit
import LanguageManager_iOS

class FG_RedemptionCatalogueVM: popUpDelegate{
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    weak var VC: FG_RedemptionCatalogueVC?
    weak var VC1: FG_CatalogueFilterView?
    
    var requestApis = RestAPI_Requests()
   var redemptionCatalougeListArray = [ObjCatalogueList]()
    var redemptionCatalougeListArray1 = [ObjCatalogueList]()
    var redemptionCatalogueMyCartListArray = [CatalogueSaveCartDetailListResponse]()
    var productArray = [ObjCatalogueList]()
    var myPlannerListArray = [ObjCatalogueList2]()
    
    
    func plannerListingApi(parameters: JSON, completion: @escaping (PlannerListModels?) -> ()){
        self.VC?.startLoading()
        self.requestApis.plannerListApi(parameters: parameters) { (result, error) in
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
    
    
func redemptionCatalogueMyCartListApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
            self.VC?.myCartIds.removeAll()
        }
        self.requestApis.redemptionCatalogueMycartListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        self.redemptionCatalogueMyCartListArray = result?.catalogueSaveCartDetailListResponse ?? []
                        if self.redemptionCatalogueMyCartListArray.count != 0 {
                            self.VC?.countLbl.isHidden = false
                            self.VC?.cartTotalPts = Int(self.redemptionCatalogueMyCartListArray[0].sumOfTotalPointsRequired ?? 0.0)
                            self.VC?.countLbl.text = "\(self.redemptionCatalogueMyCartListArray.count)"
                            for data in self.redemptionCatalogueMyCartListArray{
                                self.VC?.myCartIds.append(data.catalogueId ?? 0)
                            }
                        }else{
                            self.VC?.countLbl.isHidden = true
                            
                        }
                        self.VC?.redemptionCatalogueListApi(startIndex: self.VC?.startindex ?? 0)
                    }

                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("\(error)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("\(error)")
                }
            }
        }
    }
    func redemptionCatalogueListApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.redemptionCatalogueListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        self.redemptionCatalougeListArray1 = result?.objCatalogueList ?? []
                        self.VC?.noofelements = self.redemptionCatalougeListArray1.count
                        
                        self.redemptionCatalougeListArray = self.redemptionCatalougeListArray + self.redemptionCatalougeListArray1
                        
                        if self.redemptionCatalougeListArray.count != 0 {
                            self.VC?.catalogueListTableView.isHidden = false
                            self.VC?.noDataFoundLbl.isHidden = true
                            self.VC?.plannerListing()
                            self.VC?.catalogueListTableView.reloadData()
                        }else{
                            self.VC?.catalogueListTableView.isHidden = true
                            self.VC?.noDataFoundLbl.isHidden = false
                        }
                        self.VC?.plannerListing()
                    }

                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("\(error)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("\(error)")
                }
            }
        }
    }
    
    
    func redemptionCatalogueAddToCartApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.redemptionCatalogueAddToCartApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print(result?.returnValue ?? 0)
                        if result?.returnValue ?? 0 == 1{
                            DispatchQueue.main.async{
                               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                               vc!.delegate = self
                                vc!.descriptionInfo = "added_to_cart_success_message".localiz()
                               vc!.modalPresentationStyle = .overCurrentContext
                               vc!.modalTransitionStyle = .crossDissolve
                                self.VC?.present(vc!, animated: true, completion: nil)
                            }
                            self.VC?.myCartListApi()
                        }else{
                            DispatchQueue.main.async{
                               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                               vc!.delegate = self
                                vc!.descriptionInfo = "Something_went_wrong_error".localiz()
                               vc!.modalPresentationStyle = .overCurrentContext
                               vc!.modalTransitionStyle = .crossDissolve
                                self.VC?.present(vc!, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("\(error)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("\(error)")
                }
            }
        }
    }
    
    //AddToDreamGift
    func addToDremGiftAPI(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.addToDreamGiftAPI(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print(result?.returnValue ?? 0)
                        if result?.returnValue ?? 0 != 0{
                            DispatchQueue.main.async{
                                self.VC?.view.makeToast("added_to_cart_success_message".localiz(), duration: 3.0, position: .bottom)
                                self.VC?.plannerListing()
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.VC?.view.makeToast("added_to_cart_success_message".localiz(), duration: 3.0, position: .bottom)
                            }
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print("\(error)")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                    print("\(error)")
                }
            }
        }
    }
    
   
}



