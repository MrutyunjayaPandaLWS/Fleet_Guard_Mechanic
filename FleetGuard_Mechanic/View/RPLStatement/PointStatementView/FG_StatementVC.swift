//
//  FG_StatementVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 25/01/2023.
//

import UIKit
import LanguageManager_iOS

class FG_StatementVC: BaseViewController,StatementViewDelegate{
    func viewActBTN(_ cell: FG_StatementTVC) {
            guard let tappedIndexPath = statementTableView.indexPath(for: cell) else { return }
        let vcc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyLedgerClickViewVC") as! FG_MyLedgerClickViewVC
        let date = (VM.rlpStatemnetArray[tappedIndexPath.row].accessedDate ?? "").split(separator: " ")
        vcc.accessData = "\(date[0])"
        vcc.totalPoints = cell.totalPoints
        self.navigationController?.pushViewController(vcc, animated: true)
    }
    

    @IBOutlet weak var backBt: UIButton!
    @IBOutlet weak var statementTableView: UITableView!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var ptsEarnedLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var headerText: UILabel!
    var itsFrom: String = ""
    var VM = RPLStatmentViewVM()
    
    @IBOutlet var ledgerStackView: UIStackView!
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    @IBOutlet var nodataFoundLbl: UILabel!
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    let passBookNumber = UserDefaults.standard.string(forKey: "passBookNumber") ?? ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        if itsFrom == "SideMenu"{
            backBt.isHidden = false
        }else{
            backBt.isHidden = true
        }
        self.statementTableView.delegate = self
        self.statementTableView.dataSource = self
        self.ledgerStackView.clipsToBounds = true
        self.ledgerStackView.layer.cornerRadius = 15
        self.ledgerStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerText.text = "My_Ledger".localiz()
        monthLbl.text = "Date".localiz()
        ptsEarnedLbl.text = "points".localiz()
        balanceLbl.text = "Behaviour".localiz()
        viewLbl.text = "View".localiz()
        nodataFoundLbl.text = "noDataFound".localiz()
        self.rlpStatemnet()
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itsFrom = ""
    }

    
    func rlpStatemnet(){
        UserDefaults.standard.set(false, forKey: "AfterLog")
        UserDefaults.standard.synchronize()
        let parameters = [
            "ActionType": "3",
            "LoyaltyId":"\(loyaltyId)",
            "AccessDate": ""
        ] as [String: Any]
        print(parameters)
        self.VM.rplStatemnetViewAPI(parameters: parameters)
    }
    

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension FG_StatementVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.rlpStatemnetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FG_StatementTVC", for: indexPath) as! FG_StatementTVC
        cell.delegate = self
        cell.balanceLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].behaviour ?? "")"
        let date = (VM.rlpStatemnetArray[indexPath.row].accessedDate ?? "").split(separator: " ")
        cell.monthLbl.text = "\(date[0])"
        cell.pointEarnedLbl.text = "\(VM.rlpStatemnetArray[indexPath.row].overAllPoints ?? 0)"
        cell.totalPoints = VM.rlpStatemnetArray[indexPath.row].overAllPoints ?? 0
        cell.viewOutBtn.setTitle("View".localiz(), for: .normal)
        
        if (indexPath.row) % 2 == 0{
            cell.balanceLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.monthLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.pointEarnedLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.viewOutBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            cell.balanceLbl.backgroundColor = .lightGray
            cell.monthLbl.backgroundColor = .lightGray
            cell.pointEarnedLbl.backgroundColor = .lightGray
            cell.viewOutBtn.backgroundColor = .lightGray
        }
        return cell
    }
    
    
    
}
