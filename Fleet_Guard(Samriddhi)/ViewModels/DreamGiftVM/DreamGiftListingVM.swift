//
//  DreamGiftListingVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 20/03/23.
//

import UIKit

class DreamGiftListingVM {

    weak var VC: FG_DreamGiftVC?
    var requestAPIs = RestAPI_Requests()
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var myPlannerListArray = [ObjCatalogueList2]()
    
    
    func plannerListingApi(parameters: JSON, completion: @escaping (PlannerListModels?) -> ()){
        self.VC?.startLoading()
        self.requestAPIs.plannerListApi(parameters: parameters) { (result, error) in
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
}
