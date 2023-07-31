//
//  FG_ProductListVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 01/02/2023.
//

import UIKit

class FG_ProductListVM: popUpDelegate{
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    weak var VC: FG_ProductCatalogueListVC?
    var requestApis = RestAPI_Requests()
    var productListArray = [LsrProductDetails]()
    var productsArray = [LsrProductDetails]()
    
    func productListApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
//            self.productsArray.removeAll()
//            self.productListArray.removeAll()
        }
        self.requestApis.productListingApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        
                        
                        self.productsArray = result?.lsrProductDetails ?? []
                        self.VC?.noofelements = self.productsArray.count
                        self.productListArray = self.productListArray + self.productsArray
                        
//                        self.filteredArrayList = response?.customerBasicInfoList ?? []
//                        self.VC?.noofelements = self.filteredArrayList.count
//
//                        self.myPlumberArrayList = self.myPlumberArrayList + self.filteredArrayList
                        
                        print(self.productListArray.count,"skuhdsdj")
                        print(self.productsArray.count,"kdjdj")
                        if self.productListArray.count != 0{
                            self.VC?.productCatalgoueTableView.isHidden = false
                            self.VC?.nodatafoundLbl.isHidden = true
                            self.VC?.productCatalgoueTableView.reloadData()
                        }else{
                            self.VC?.nodatafoundLbl.isHidden = false
                            self.VC?.productCatalgoueTableView.isHidden = true
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
    
    func mycartListAPi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.myCartListApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        let myCartListArray = result?.lstCustomerCart ?? []
                        print(myCartListArray.count, "MyCart Count")
                        if myCartListArray.count != 0 {
                            self.VC?.countLbl.isHidden = false
                            self.VC?.countLbl.text = "\(myCartListArray.count)"
                        }else{
                            self.VC?.countLbl.isHidden = true
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

