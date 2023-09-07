//
//  ViewController.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 23/03/23.
//

import UIKit

class MyLedgerClickVM {
            
        weak var VC: FG_MyLedgerClickViewVC?
        var requestAPIs = RestAPI_Requests()
        var rlpStatemnetArray = [ObjCustomerDashboardList12]()
        
        func myLedgerClickViewAPI(parameters: JSON) -> (){
            DispatchQueue.main.async {
                self.VC?.startLoading()
            }
            self.requestAPIs.MyLedgerClickViewRestAPI(parameters: parameters) { (result, error) in
                if error == nil{
                    if result != nil {
                        DispatchQueue.main.async {
                            self.rlpStatemnetArray = result?.objCustomerDashboardList ?? []
                            print(self.rlpStatemnetArray.count,"dlskjdkj")
                            if self.rlpStatemnetArray.count != 0 {
                                self.VC?.MyLedgerTableView.isHidden = false
                                self.VC?.MyLedgerTableView.reloadData()
                                self.VC?.nodataFoundLbl.isHidden = true
//                                self.VC?.pointsLbl.text = "\(self.rlpStatemnetArray[0].overAllPoints ?? 0)"
                                
                            }else{
                                self.VC?.MyLedgerTableView.isHidden = true
                                self.VC?.nodataFoundLbl.isHidden = false
                            }
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
    }
