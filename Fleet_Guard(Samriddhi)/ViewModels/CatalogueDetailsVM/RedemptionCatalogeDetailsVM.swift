//
//  RedemptionCatalogeDetailsVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 25/02/23.
//

import UIKit

class RedemptionCatalogeDetailsVM: popUpDelegate {
    
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}

    weak var VC: FG_RedemptionCatalogueDetailsVC?
    
    
    
    var requestApis = RestAPI_Requests()
    var redemptionCatalougeListArray = [ObjCatalogueList]()
    var redemptionCatalogueMyCartListArray = [CatalogueSaveCartDetailListResponse]()
    func redemptionCatalogueListApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.redemptionCatalogueListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        self.redemptionCatalougeListArray = result?.objCatalogueList ?? []
                        if self.redemptionCatalougeListArray.count != 0 {
                            //                            self.VC?.catalogueListTableView.reloadData()
                            //                            self.VC?.catalogueListTableView.isHidden = false
                            //self.VC?.noDataFoundLbl.isHidden = true
                            
                        }else{
                            //                            self.VC?.catalogueListTableView.isHidden = true
                            //                            self.VC?.noDataFoundLbl.isHidden = false
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
                                vc!.descriptionInfo = "Product added into cart successfully."
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.VC?.present(vc!, animated: true, completion: nil)
                                self.VC?.addToCartView.isHidden = true
                                self.VC?.addedToCartView.isHidden = false
                                
                            }
                            self.VC?.myCartListApi()
                        }else{
                            DispatchQueue.main.async{
//                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                                vc!.delegate = self
//                                vc!.descriptionInfo = "Something went wrong! Try againg Later..."
//                                vc!.modalPresentationStyle = .overCurrentContext
//                                vc!.modalTransitionStyle = .crossDissolve
//                                self.VC?.present(vc!, animated: true, completion: nil)
                                
                                self.VC?.view.makeToast("Something went wrong! Try againg Later...", duration: 3.0, position: .bottom)
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
                                self.VC?.view.makeToast("Product added into dream gift  successfully.", duration: 3.0, position: .bottom)
                            }
                        }else{
                            DispatchQueue.main.async{
                                self.VC?.view.makeToast("Product faild to add into dream gift", duration: 3.0, position: .bottom)
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

