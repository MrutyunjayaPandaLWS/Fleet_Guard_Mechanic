//
//  RedemptionPlannerDetailsViewController.swift
//  CenturyPly_JSON
//
//  Created by Arokia-M3 on 03/03/22.
//

import UIKit

class RedemptionPlannerDetailsViewModel{
    
    var requestAPIs = RestAPI_Requests()
    weak var VC: FG_DreamGiftDetailsVC?
    var myPlannerListArray = [ObjCatalogueList2]()
    
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
    
}