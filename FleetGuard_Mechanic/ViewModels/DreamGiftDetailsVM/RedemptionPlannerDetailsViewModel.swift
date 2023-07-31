//
//  RedemptionPlannerDetailsViewController.swift
//  CenturyPly_JSON
//
//  Created by Arokia-M3 on 03/03/22.
//

import UIKit
import LanguageManager_iOS

class RedemptionPlannerDetailsViewModel: popUpDelegate{
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: FG_DreamGiftDetailsVC?
    var myPlannerListArray = [ObjCatalogueList2]()
    var redemptionCatalogueMyCartListArray = [CatalogueSaveCartDetailListResponse]()
    func plannerListingApi(parameters: JSON, completion: @escaping (PlannerListModels?) -> ()){
        DispatchQueue.main.async {
              self.VC?.startLoading()
         }
        self.requestAPIs.plannerListApi(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        self.VC?.stopLoading()
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
    
    
//    func addToCart(parameters: JSON, completion: @escaping (AddToCartModels?) -> ()){
//        DispatchQueue.main.async {
//              self.VC?.startLoading()
//              self.VC?.loaderView.isHidden = false
//              self.VC?.playAnimation()
//         }
//        self.requestAPIs.addToCartApi(parameters: parameters) { (result, error) in
//            if error == nil{
//                if result != nil {
//                    DispatchQueue.main.async {
//                        completion(result)
//                        self.VC?.loaderView.isHidden = true
//                        self.VC?.stopLoading()
//                    }
//                } else {
//                    print("No Response")
//                    DispatchQueue.main.async {
//                        self.VC?.loaderView.isHidden = true
//                        self.VC?.stopLoading()
//                    }
//                }
//            }else{
//                print("ERROR_Login \(error)")
//                DispatchQueue.main.async {
//                    self.VC?.loaderView.isHidden = true
//                    self.VC?.stopLoading()
//                }
//
//        }
//    }
//
//    }
    
    func removePlannedProduct(parameters: JSON, completion: @escaping (RemovePlannedProduct?) -> ()){
        DispatchQueue.main.async {
              self.VC?.startLoading()
         }
        self.requestAPIs.removePlannedProduct(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        self.VC?.stopLoading()
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
    
//    func myCartList(parameters: JSON, completion: @escaping (MyCartModels?) -> ()){
//        DispatchQueue.main.async {
//              self.VC?.startLoading()
//              self.VC?.loaderView.isHidden = false
//              self.VC?.playAnimation()
//         }
//        self.requestAPIs.myCartList(parameters: parameters) { (result, error) in
//            if error == nil{
//                if result != nil {
//                    DispatchQueue.main.async {
//                        completion(result)
//                        self.VC?.loaderView.isHidden = true
//                        self.VC?.stopLoading()
//                    }
//                } else {
//                    print("No Response")
//                    DispatchQueue.main.async {
//                        self.VC?.loaderView.isHidden = true
//                        self.VC?.stopLoading()
//                    }
//                }
//            }else{
//                print("ERROR_Login \(error)")
//                DispatchQueue.main.async {
//                    self.VC?.loaderView.isHidden = true
//                    self.VC?.stopLoading()
//                }
//
//        }
//    }
//
//    }
    
    
//    func adhaarNumberExistsApi(parameters: JSON, completion: @escaping (AdhaarCardExistsModels?) -> ()){
//        DispatchQueue.main.async {
//              self.VC?.startLoading()
//              self.VC?.loaderView.isHidden = false
//              self.VC?.playAnimation()
//         }
//        self.requestAPIs.adhaarCardExistApi(parameters: parameters) { (result, error) in
//            if error == nil{
//                if result != nil {
//                    DispatchQueue.main.async {
//                        completion(result)
//
//                    }
//                } else {
//                    print("No Response")
//                    DispatchQueue.main.async {
//                        self.VC?.loaderView.isHidden = true
//                        self.VC?.stopLoading()
//                    }
//                }
//            }else{
//                print("ERROR_Login \(error)")
//                DispatchQueue.main.async {
//                    self.VC?.loaderView.isHidden = true
//                    self.VC?.stopLoading()
//                }
//
//        }
//    }
//
//    }
    func redemptionCatalogueAddToCartApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
            
        }
        self.requestAPIs.redemptionCatalogueAddToCartApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        print(result?.returnValue ?? 0)
                        if result?.returnValue ?? 0 == 1{
                            DispatchQueue.main.async{
//                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                                vc!.delegate = self
//                                vc!.descriptionInfo = "add_to_cart_success_message".localiz()
//                                vc!.modalPresentationStyle = .overCurrentContext
//                                vc!.modalTransitionStyle = .crossDissolve
//                                self.VC?.present(vc!, animated: true, completion: nil)
////                                self.VC?.addToCartView.isHidden = true
////                                self.VC?.addedToCartView.isHidden = false
                                self.VC?.addCartBtnStatus = 1
                                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyCartVC") as! FG_MyCartVC
                                self.VC?.navigationController?.pushViewController(vc, animated: true)
                                
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
                                self.VC?.addCartBtnStatus = 0
                                self.VC?.view.makeToast("Something_went_wrong_error".localiz(), duration: 3.0, position: .bottom)
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
