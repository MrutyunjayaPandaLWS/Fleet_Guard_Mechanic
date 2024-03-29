//
//  FG_MyLedgerClickViewVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 23/03/23.
//

import UIKit
import LanguageManager_iOS

class FG_MyLedgerClickViewVC: BaseViewController {

    @IBOutlet weak var dateTitleLbl: UILabel!
    @IBOutlet weak var pointsTitleLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var MyLedgerTableView: UITableView!
    @IBOutlet weak var nodataFoundLbl: UILabel!
    @IBOutlet var dateLBL: UILabel!
    @IBOutlet var pointsLbl: UILabel!
    
    var VM = MyLedgerClickVM()
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var accessData: String = ""
    var totalPoints = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.MyLedgerTableView.delegate = self
        self.MyLedgerTableView.dataSource = self
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            self.myLegderAPI()
        }
        
        self.dateLBL.text = accessData
        pointsLbl.text = "\(totalPoints)"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localization()
    }
    
    func localization(){
        nodataFoundLbl.text = "noDataFound".localiz()
        headerLbl.text = "My_Ledger".localiz()
        pointsTitleLbl.text = "points".localiz()
        dateTitleLbl.text = "Date".localiz()
    }
    
    @IBAction func selectBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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

        cell.partNoTitleLbl.text = "Part number".localiz()
        cell.pointsTitleLbl.text = "points".localiz()
        cell.pointsLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].points ?? "")"
        cell.remarksLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].behaviour ?? "")"
        
        cell.partNoLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].part_No ?? "")"
        cell.productNameLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].part_Desc ?? "")"
        cell.remarksTitleLbl.text = "Remarks".localiz()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}
