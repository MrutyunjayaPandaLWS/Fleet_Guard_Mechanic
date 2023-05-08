//
//  FG_MyRedemptionVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 18/01/2023.
//

import UIKit

class FG_MyRedemptionVC: BaseViewController, DateSelectedDelegate {
    func acceptDate(_ vc: FG_DOBVC) {
        if vc.isComeFrom == "1"{
            self.selectedFromDate = vc.selectedDate
            self.fromDateBtn.setTitle("\(vc.selectedDate)", for: .normal)
        }else{
            self.selectedToDate = vc.selectedDate
            self.toDateBtn.setTitle("\(vc.selectedDate)", for: .normal)
        }
    }
    func declineDate(_ vc: FG_DOBVC) {
        self.dismiss(animated: true)
    }
    

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var filterTitle: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var myRedemptionTableView: UITableView!
    @IBOutlet weak var fromDateBtn: UIButton!
    @IBOutlet weak var toDateBtn: UIButton!
    
    @IBOutlet weak var noteLbl: UILabel!
    
    @IBOutlet weak var filterByStatusLbl: UILabel!
    
    @IBOutlet weak var pendingBtn: UIButton!
    
    @IBOutlet weak var approvedBtn: UIButton!
    
    @IBOutlet weak var cancelledBtn: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var filterOPBTN: UIButton!
    
    @IBOutlet weak var noDataLbl: UILabel!
    
    
    var itsFrom = ""
    var status = "-1"
    var selectedFromDate = ""
    var selectedToDate = ""
    
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    let pointBalance = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? "0"
    var VM = MyRedemptionListingVM()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        myRedemptionTableView.delegate = self
        myRedemptionTableView.dataSource = self
        self.filterView.isHidden = true
        
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 20
        subView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filterView.clipsToBounds = true
        filterView.layer.cornerRadius = 20
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if self.itsFrom == "SideMenu"{
            self.backBtn.isHidden = false
        }else{
            self.backBtn.isHidden = true
        }
        self.myRedemptionListing()
    }
    
    
    func myRedemptionListing(){
        let parameter = [
            "ActionType": "52",
            "ActorId": "\(self.userId)",
            "ObjCatalogueDetails": [
                "JFromDate": "\(selectedFromDate)",
                "JToDate": "\(selectedToDate)",
                "SelectedStatus": "\(self.status)"
            ]
            ]as [String: Any]
        print(parameter)
        self.VM.myRedemptionLists(parameters: parameter)
        }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func languageBtn(_ sender: Any) {
    }
    @IBAction func notificationBtn(_ sender: Any) {
    }
    @IBAction func filterBtn(_ sender: Any) {
        if self.filterView.isHidden == false{
            self.filterView.isHidden = true
        }else{
            self.filterView.isHidden = false
        }
    }
    @IBAction func closeBtn(_ sender: Any) {
        self.filterView.isHidden = true
    }
    
    @IBAction func fromDateButton(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DOBVC") as? FG_DOBVC
        vc!.delegate = self
        vc!.isComeFrom = "1"
        vc!.modalPresentationStyle = .overCurrentContext
        vc!.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func toDateButton(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DOBVC") as? FG_DOBVC
        vc!.delegate = self
        vc!.isComeFrom = "1"
        vc!.modalPresentationStyle = .overCurrentContext
        vc!.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func pendingButton(_ sender: Any) {
        self.status = "1"
        self.approvedBtn.backgroundColor = .white
        self.pendingBtn.backgroundColor = .systemOrange
        self.cancelledBtn.backgroundColor = .white
        self.cancelledBtn.backgroundColor = .white
//        self.reopenBtn.backgroundColor = .white
//        self.resolveFollowUpBtn.backgroundColor = .white
    }
    
    @IBAction func approvedButton(_ sender: Any) {
        self.status = "3"
        self.approvedBtn.backgroundColor = .systemOrange
        self.pendingBtn.backgroundColor = .white
        self.cancelledBtn.backgroundColor = .white
//        self.reopenBtn.backgroundColor = .white
//        self.resolveFollowUpBtn.backgroundColor = .white
    }
    
    @IBAction func cancelledButton(_ sender: Any) {
        self.status = "4"
        self.approvedBtn.backgroundColor = .white
        self.pendingBtn.backgroundColor = .white
        self.cancelledBtn.backgroundColor = .systemOrange
//        self.reopenBtn.backgroundColor = .white
//        self.resolveFollowUpBtn.backgroundColor = .white
    }
    
    @IBAction func applyButton(_ sender: Any) {
        print(status,"srjdh")
        print(self.selectedFromDate,"slkdls")
        print(selectedToDate,"lskdjsldm")
        //self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.selectedStatusId, StartIndex: startindex)
        
        self.filterView.isHidden = true
    }
    @IBAction func clearbtn(_ sender: Any) {
        
        self.status = ""
        self.fromDateBtn.setTitle("From Date", for: .normal)
        self.toDateBtn.setTitle("To Date", for: .normal)
        self.approvedBtn.backgroundColor = .white
        self.pendingBtn.backgroundColor = .white
        self.cancelledBtn.backgroundColor = .white
        self.filterView.isHidden = true
    }
   
}

extension FG_MyRedemptionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.myRedemptionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FG_MyRedemptionTVC", for: indexPath) as! FG_MyRedemptionTVC
        cell.selectionStyle = .none
        cell.categoryTitleLbl.text = VM.myRedemptionList[indexPath.row].productName ?? ""
        cell.refNoLbl.text = VM.myRedemptionList[indexPath.row].redemptionRefno
        cell.qtyLbl.text = "\(VM.myRedemptionList[indexPath.row].quantity ?? 0)"
        let date = (VM.myRedemptionList[indexPath.row].jRedemptionDate ?? "").split(separator: " ")
        cell.dateTitleLbl.text = "\(date[0])"
        cell.ptsLbl.text = "\(Int(VM.myRedemptionList[indexPath.row].redeemedPoints ?? 0))"
        
        let statusDtata = VM.myRedemptionList[indexPath.row].status ?? 0
//        if statusDtata == 0{
//            cell.statusLbl.setTitle("Pending",for: .normal)
//            cell.statusLbl.backgroundColor = .systemOrange
//        }else if statusDtata == 1{
//            cell.statusLbl.setTitle("Approved", for: .normal)
//            cell.statusLbl.backgroundColor = .systemGreen
//        }else{
//            cell.statusLbl.setTitle("Rejected", for: .normal)
//            cell.statusLbl.backgroundColor = .systemRed
//        }
        

        if statusDtata == 0{
            cell.statusLbl.setTitle("Pending",for: .normal)
            cell.statusLbl.backgroundColor = .systemYellow
        }else if statusDtata == 12{
            cell.statusLbl.setTitle("Processd", for: .normal)
            cell.statusLbl.backgroundColor = .systemBlue
        }else if statusDtata == 14{
            cell.statusLbl.setTitle("Processd",for: .normal)
            cell.statusLbl.backgroundColor = .systemBlue
        }else if statusDtata == 2{
            cell.statusLbl.setTitle("Processd", for: .normal)
            cell.statusLbl.backgroundColor = .systemBlue
        }else if statusDtata == 15{
            cell.statusLbl.setTitle("Processd",for: .normal)
            cell.statusLbl.backgroundColor = .systemBlue
        }else if statusDtata == 10{
            cell.statusLbl.setTitle("Dispatched", for: .normal)
            cell.statusLbl.backgroundColor = UIColor.systemGreen
        }else if statusDtata == 4{
            cell.statusLbl.setTitle("Delivered",for: .normal)
            cell.statusLbl.backgroundColor = .green
        }else if statusDtata == 24{
            cell.statusLbl.setTitle("In Transit", for: .normal)
            cell.statusLbl.backgroundColor = .systemBlue
        }else if statusDtata == 19{
            cell.statusLbl.setTitle("Delivery Confirmed",for: .normal)
            cell.statusLbl.backgroundColor = .systemGreen
        }else if statusDtata == 20{
            cell.statusLbl.setTitle("Return Requested", for: .normal)
            cell.statusLbl.backgroundColor = .systemYellow
        }else if statusDtata == 21{
            cell.statusLbl.setTitle("Return Pickup Schedule",for: .normal)
            cell.statusLbl.backgroundColor = .systemYellow
        }else if statusDtata == 22{
            cell.statusLbl.setTitle("Picked Up", for: .normal)
            cell.statusLbl.backgroundColor = .systemYellow
        }else if statusDtata == 23{
            cell.statusLbl.setTitle("Return Received", for: .normal)
            cell.statusLbl.backgroundColor = .systemGreen
        }else if statusDtata == 8{
            cell.statusLbl.setTitle("Re dispatched", for: .normal)
            cell.statusLbl.backgroundColor = .systemGreen
        }else if statusDtata == 5{
            cell.statusLbl.setTitle("Rejected", for: .normal)
            cell.statusLbl.backgroundColor = .systemRed
        }else if statusDtata == 3{
            cell.statusLbl.setTitle("Cancelled", for: .normal)
            cell.statusLbl.backgroundColor = .systemRed
        }else{
            cell.statusLbl.setTitle("Cancelled", for: .normal)
            cell.statusLbl.backgroundColor = .systemRed
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyRedemptionDetailsVC") as? FG_MyRedemptionDetailsVC
        vc?.redepmtionId = "\(self.VM.myRedemptionList[indexPath.row].redemptionId ?? 0)"
        vc?.productRefno = "\(self.VM.myRedemptionList[indexPath.row].redemptionRefno ?? "")"
        navigationController?.pushViewController(vc!, animated: true)
    }
}
