//
//  FG_MyLedgerClickViewVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 23/03/23.
//

import UIKit

class FG_MyLedgerClickViewVC: BaseViewController {

    @IBOutlet weak var MyLedgerTableView: UITableView!
    @IBOutlet weak var nodataFoundLbl: UILabel!
    @IBOutlet var dateLBL: UILabel!
    @IBOutlet var pointsLbl: UILabel!
    
    var VM = MyLedgerClickVM()
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var accessData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.MyLedgerTableView.delegate = self
        self.MyLedgerTableView.dataSource = self
        self.myLegderAPI()
        self.dateLBL.text = accessData
    }
    
    func myLegderAPI(){
        UserDefaults.standard.set(false, forKey: "AfterLog")
        UserDefaults.standard.synchronize()
        let parameters = [
                "ActionType": "4",
                "LoyaltyId": "\(loyaltyId)",
                "AccessDate":"\(accessData)"
        ] as [String: Any]
        print(parameters)
        self.VM.myLedgerClickViewAPI(parameters: parameters)
        }
}
extension FG_MyLedgerClickViewVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.rlpStatemnetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLedgerClickViewTVC", for: indexPath) as! MyLedgerClickViewTVC

        cell.pointsLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].points ?? "")"
        cell.remarksLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].behaviour ?? "")"
        
        cell.partNoLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].part_No ?? "")"
        cell.productNameLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].part_Desc ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
