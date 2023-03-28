//
//  RPLStatmentViewVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 24/02/23.
//

import UIKit

class RPLStatmentViewVM {
        
    weak var VC: FG_StatementVC?
    var requestAPIs = RestAPI_Requests()
    var rlpStatemnetArray = [ObjCustomerDashboardList3]()
    
    func rplStatemnetViewAPI(parameters: JSON) -> (){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.MyLedgerRestAPI(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        self.rlpStatemnetArray = result?.objCustomerDashboardList ?? []
                        print(self.rlpStatemnetArray.count,"dlskjdkj")
                        if self.rlpStatemnetArray.count != 0 {
                            self.VC?.statementTableView.isHidden = false
                            self.VC?.statementTableView.reloadData()
                            self.VC?.ledgerStackView.isHidden = false
                            self.VC?.nodataFoundLbl.isHidden = true
                            
                        }else{
                            self.VC?.statementTableView.isHidden = true
                            self.VC?.ledgerStackView.isHidden = true
                            self.VC?.nodataFoundLbl.isHidden = false
                        }
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
