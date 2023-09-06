//
//  FG_MyBillingDetailsVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 23/02/23.
//

import UIKit

class FG_MyBillingDetailsVC: BaseViewController {
    
    
        @IBOutlet var myOrdersHeaderLbl: UILabel!
        @IBOutlet var languageChangeOutBtn: UIButton!
        @IBOutlet var notificationOutBtn: UIButton!
        @IBOutlet var notificationCountLbl: UILabel!
        
        @IBOutlet var orderNumberHeadingLbl: UILabel!
        @IBOutlet var orderNumberLbl: UILabel!
        
        @IBOutlet var orderDateHeadingLbl: UILabel!
        @IBOutlet var orderDateLbl: UILabel!
        
        @IBOutlet var orderView: UIView!
        @IBOutlet var orderDetailsTV: UITableView!
        
        @IBOutlet var noDataFoundLbl: UILabel!
        
        
        var ordernumber = ""
        var orderDate = ""
        var invoiceNumber = ""
        var VM = MyBillingDetailsVM()
        var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.VM.VC = self
            self.orderDetailsTV.delegate = self
            self.orderDetailsTV.dataSource = self
            self.orderDetailsTV.separatorStyle = .none
            self.orderNumberHeadingLbl.text = "Order No"
            self.orderDateHeadingLbl.text = "Order Date"
            self.orderDateLbl.text = orderDate
            self.orderNumberLbl.text = ordernumber
            if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
                DispatchQueue.main.async{
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
            }else{
                self.myBillingDetailsAPI()
            }
        }

        func myBillingDetailsAPI() {
            let parameters = [
                    "ActionType": 23,
                    "ActorId": "\(userId)",
                    "invoiceNo": "\(invoiceNumber)"
            ] as [String: Any]
            self.VM.billingsDetailsAPI(parameters: parameters)
        }
        
        
        @IBAction func backBtn(_ sender: Any) {
            self.navigationController?.popToRootViewController(animated: true)
        }

    }

    extension FG_MyBillingDetailsVC: UITableViewDelegate,UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return VM.myBillingsDetailArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FG_MyBillingDetailsTVC") as! FG_MyBillingDetailsTVC
            cell.selectionStyle = .none
            cell.paetNumberLbl.text = VM.myBillingsDetailArray[indexPath.row].prodCode ?? "-"
            cell.productNameHeadingLbl.text = VM.myBillingsDetailArray[indexPath.row].prodName ?? "-"
            cell.qtyLbl.text = "\(VM.myBillingsDetailArray[indexPath.row].quantity ?? 0)"
            cell.valueLbl.text = VM.myBillingsDetailArray[indexPath.row].sellingPrice ?? "-"
            //cell.billingimageView.image = "\(VM.myBillingsDetailArray[indexPath.row].productImage)"
            let imageURL = VM.myBillingsDetailArray[indexPath.row].productImage ?? ""
            print(imageURL)
            if imageURL != ""{
                let filteredURLArray = imageURL.dropFirst(2)
                let urltoUse = String(PROMO_IMG1 + filteredURLArray).replacingOccurrences(of: " ", with: "%20")
                let urlt = URL(string: "\(urltoUse)")
                print(urlt)
                cell.billingimageView.kf.setImage(with: URL(string: "\(String(describing: urlt))"), placeholder: UIImage(named: "image_2022_12_20T13_15_20_335Z"));
            }
            
//                    if (indexPath.row) % 2 == 0{
//                        cell..backgroundColor = #colorLiteral(red: 1, green: 0.9647058824, blue: 0.8196078431, alpha: 1)
//                    }else{
//                        cell.orderIndexStackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                    }
            
            
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 170
        }
        
        
    }

