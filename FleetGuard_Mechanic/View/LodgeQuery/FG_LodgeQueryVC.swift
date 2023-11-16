//
//  FG_LodgeQueryVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit
import LanguageManager_iOS

class FG_LodgeQueryVC: BaseViewController, DateSelectedDelegate {
    
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
    

    @IBOutlet weak var nodatafoundLbl: UILabel!
    @IBOutlet weak var filterShadowView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var filterTitle: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var lodgeQueryListTableView: UITableView!

    @IBOutlet weak var fromDateBtn: UIButton!

    @IBOutlet weak var toDateBtn: UIButton!

    @IBOutlet weak var filterByStatusLbl: UILabel!

    @IBOutlet weak var pendingBtn: UIButton!

    @IBOutlet weak var approvedBtn: UIButton!

    @IBOutlet weak var cancelledBtn: UIButton!

    @IBOutlet weak var lodgeQueryBtn: GradientButton!
    @IBOutlet weak var resolveFollowUpBtn: UIButton!
    @IBOutlet weak var reopenBtn: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var filterClickBTN: UIButton!
    
    var itsFrom = ""
    var VM = FG_QueryListVM()
    var selectedQueryTopic = ""
    var selectedQueryTopicId = -1
    var selectedStatusId = -1
    var selectedFromDate = ""
    var selectedToDate = ""
    var status = "-1"
    var noofelements = 0
    var startindex = 1
    
    
    
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        lodgeQueryListTableView.delegate = self
        lodgeQueryListTableView.dataSource = self
        nodatafoundLbl.isHidden = true
        self.filterShadowView.isHidden = true
//        self.filterView.isHidden = true
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 20
        subView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        filterView.clipsToBounds = true
        filterView.layer.cornerRadius = 20
        filterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        lodgeQueryBtn.clipsToBounds = true
        lodgeQueryBtn.layer.cornerRadius = 16
        lodgeQueryBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        if self.itsFrom == "SideMenu"{
            self.backBtn.isHidden = false
        }else{
            self.backBtn.isHidden = false
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        localization()
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }else{
            self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.status, StartIndex: startindex)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == filterShadowView{
            filterShadowView.isHidden = true
        }
    }
    
    func localization(){
        nodatafoundLbl.text = "noDataFound".localiz()
        headerText.text = "Lodge_Query".localiz()
        lodgeQueryBtn.setTitle("Lodge_Query".localiz(), for: .normal)
        self.fromDateBtn.setTitle("from_Date".localiz(), for: .normal)
        self.toDateBtn.setTitle("To_Date".localiz(), for: .normal)
        self.filterTitle.text = "filter".localiz()
        self.filterByStatusLbl.text = "Filter_By_Status".localiz()
        self.clearButton.setTitle("Clear_All".localiz(), for: .normal)
        self.applyBtn.setTitle("Apply".localiz(), for: .normal)
    }
    
//
//    "ActionType": "1",
//               "ActorId": "45822",
//               "HelpTopicID": ""

    func queryListApi(queryTopic: Int, statusId: String,StartIndex: Int){
        let parameter = [
            "ActionType": "1",
            "ActorId": "\(self.userId)",
            "HelpTopicID": queryTopic,
            "JFromDate":"\(selectedFromDate)",
            "JToDate":"\(selectedToDate)",
//            "PageSize": 20,
            "StartIndex": StartIndex,
            "TicketStatusId": "\(self.status)"
        ] as [String: Any]
        print(parameter)
        self.VM.querListsApi(parameter: parameter)
    }
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func languageBtn(_ sender: Any) {
    }
    @IBAction func notificationBtn(_ sender: Any) {
    }
    @IBAction func filterBtn(_ sender: Any) {
        
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                   let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                   vc.modalTransitionStyle = .crossDissolve
                   vc.modalPresentationStyle = .overFullScreen
                   self.present(vc, animated: true)
               return
               }
        filterShadowView.isHidden = false
}
@IBAction func closeBtn(_ sender: Any) {
    self.filterShadowView.isHidden = true
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
    vc!.isComeFrom = "2"
    vc!.modalPresentationStyle = .overCurrentContext
    vc!.modalTransitionStyle = .coverVertical
    self.present(vc!, animated: true, completion: nil)
}

@IBAction func pendingButton(_ sender: Any) {
    
    //    1 Pending
    //    2 Re-Open
    //    3 Resolved
    //    4 Closed
    //    5 Resolved-Follow Up

    self.status = "1"
    self.approvedBtn.backgroundColor = .white
    self.pendingBtn.backgroundColor = .systemOrange
    self.cancelledBtn.backgroundColor = .white
    self.cancelledBtn.backgroundColor = .white
    self.reopenBtn.backgroundColor = .white
    self.resolveFollowUpBtn.backgroundColor = .white
}

@IBAction func approvedButton(_ sender: Any) {
    
    self.status = "3"
    self.approvedBtn.backgroundColor = .systemOrange
    self.pendingBtn.backgroundColor = .white
    self.cancelledBtn.backgroundColor = .white
    self.reopenBtn.backgroundColor = .white
    self.resolveFollowUpBtn.backgroundColor = .white
}

@IBAction func cancelledButton(_ sender: Any) {
    
    self.status = "4"
    self.approvedBtn.backgroundColor = .white
    self.pendingBtn.backgroundColor = .white
    self.cancelledBtn.backgroundColor = .systemOrange
    self.reopenBtn.backgroundColor = .white
    self.resolveFollowUpBtn.backgroundColor = .white
}

    @IBAction func reopenBtn(_ sender: Any) {
        self.status = "2"
        self.approvedBtn.backgroundColor = .white
        self.pendingBtn.backgroundColor = .white
        self.cancelledBtn.backgroundColor = .white
        self.reopenBtn.backgroundColor = .systemOrange
        self.resolveFollowUpBtn.backgroundColor = .white
    }
    
    @IBAction func resolveFollowUpBtn(_ sender: Any) {
        self.status = "5"
        self.approvedBtn.backgroundColor = .white
        self.pendingBtn.backgroundColor = .white
        self.cancelledBtn.backgroundColor = .white
        self.reopenBtn.backgroundColor = .white
        self.resolveFollowUpBtn.backgroundColor = .systemOrange
    }
    
    @IBAction func createNewQueryBtn(_ sender: Any) {
        
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                   let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                   vc.modalTransitionStyle = .crossDissolve
                   vc.modalPresentationStyle = .overFullScreen
                   self.present(vc, animated: true)
               return
               }
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_CreatenewqueryVC") as! FG_CreatenewqueryVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
@IBAction func applyButton(_ sender: Any) {
    print(status,"srjdh")
    print(self.selectedFromDate,"slkdls")
    print(selectedToDate,"lskdjsldm")
    
//    self.filterShadowView.isHidden = true
    
    
    
    if self.fromDateBtn.currentTitle == "from_Date".localiz() && self.toDateBtn.currentTitle == "To_Date".localiz() && self.status == "-1"{
        self.view.makeToast("Select date or filter status or both".localiz(), duration: 2.0, position: .center)
    }else if self.fromDateBtn.currentTitle == "from_Date".localiz() && self.toDateBtn.currentTitle == "To_Date".localiz() && self.status != "-1"{
        
        self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.status, StartIndex: startindex)
        self.filterShadowView.isHidden = true
        
    }else if self.fromDateBtn.currentTitle != "from_Date".localiz() && self.toDateBtn.currentTitle == "To_Date".localiz(){
        
        self.view.makeToast("Select To Date".localiz(), duration: 2.0, position: .center)
        
    }else if self.fromDateBtn.currentTitle == "from_Date".localiz() && self.toDateBtn.currentTitle != "To_Date".localiz(){
        
        self.view.makeToast("Select From Date".localiz(), duration: 2.0, position: .center)
        
    }else if self.fromDateBtn.currentTitle != "from_Date".localiz() && self.toDateBtn.currentTitle != "To_Date".localiz() && self.status == "-1" || self.status != "-1"{
        
        if selectedToDate < selectedFromDate{
            
            self.view.makeToast("ToDate should be lower than FromDate".localiz(), duration: 2.0, position: .center)
            
        }else if self.fromDateBtn.currentTitle == "from_Date".localiz() && self.toDateBtn.currentTitle == "To_Date".localiz() && self.status != "-1"{
            
            self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.status, StartIndex: startindex)
            self.filterShadowView.isHidden = true
        }else{
            self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.status, StartIndex: startindex)
            self.filterShadowView.isHidden = true
        }
        
    }else{
        
        self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.status, StartIndex: startindex)
        self.filterShadowView.isHidden = true
    }
    
    
    
}
@IBAction func clearbtn(_ sender: Any) {
    
//    self.status = "-1"
    self.fromDateBtn.setTitle("from_Date".localiz(), for: .normal)
    self.toDateBtn.setTitle("To_Date".localiz(), for: .normal)
    self.approvedBtn.backgroundColor = .white
    self.pendingBtn.backgroundColor = .white
    self.cancelledBtn.backgroundColor = .white
    selectedQueryTopicId = -1
    status = "-1"
    selectedFromDate = ""
    selectedToDate = ""
    self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.status, StartIndex: startindex)
    self.filterShadowView.isHidden = true
}
}

extension FG_LodgeQueryVC: UITableViewDelegate, UITableViewDataSource{
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return VM.queryListArray.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FG_LodgeQueryTVC", for: indexPath) as! FG_LodgeQueryTVC
    cell.selectionStyle = .none
    let ticketStatus = VM.queryListArray[indexPath.row].ticketStatus ?? "-"
    cell.queryId.text = VM.queryListArray[indexPath.row].customerTicketRefNo ?? ""
    cell.statusLbl.text = "  \(ticketStatus)  "
    cell.queryTypeLhl.text = "Query type".localiz()
    
    if cell.statusLbl.text == "  Pending  "{
        cell.statusLbl.backgroundColor = #colorLiteral(red: 0.8146452308, green: 0.6417329907, blue: 0.1795035601, alpha: 1)
    }else if cell.statusLbl.text == "  Approved  "{
        cell.statusLbl.backgroundColor = #colorLiteral(red: 0, green: 0.616204381, blue: 0, alpha: 1)
    }else if cell.statusLbl.text == "  Resolved  "{
        cell.statusLbl.backgroundColor = #colorLiteral(red: 0, green: 0.616204381, blue: 0, alpha: 1)
    }else if cell.statusLbl.text == "  Re-Open  "{
        cell.statusLbl.backgroundColor = #colorLiteral(red: 0.8146452308, green: 0.6417329907, blue: 0.1795035601, alpha: 1)
    }else if cell.statusLbl.text == "  Resolved-Follow Up  "{
        cell.statusLbl.backgroundColor = #colorLiteral(red: 0, green: 0.616204381, blue: 0, alpha: 1)
    }else{
        cell.statusLbl.backgroundColor = #colorLiteral(red: 0.7347359657, green: 0, blue: 0, alpha: 1)
    }
    let querydateAndTime = VM.queryListArray[indexPath.row].jCreatedDate ?? ""
    let querydateAndTimeArray = querydateAndTime.components(separatedBy: " ")
    cell.dateLbl.text = "\(querydateAndTimeArray[0])"
    
    cell.queryInfoLbl.text = VM.queryListArray[indexPath.row].helpTopic ?? "-"
    if querydateAndTimeArray.count >= 2{
        cell.timeDetailsSV.isHidden = false
        cell.timeLbl.text = "\(querydateAndTimeArray[1])"
    }else{
        cell.timeDetailsSV.isHidden = true
    }
    return cell
}

//func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 160
//}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let centerviewcontroller = storyboard!.instantiateViewController(withIdentifier: "ChatListViewController") as! ChatListViewController
//        print(VM.queryListArray[indexPath.section].customerTicketID ?? 0)
//        centerviewcontroller.CustomerTicketIDchatvc = "\(VM.queryListArray[indexPath.row].customerTicketID ?? 0)"
//        centerviewcontroller.helptopicid = "\(VM.queryListArray[indexPath.row].helpTopicID ?? 0)"
//        centerviewcontroller.querysummary = VM.queryListArray[indexPath.row].querySummary ?? ""
//        centerviewcontroller.helptopicdetails = VM.queryListArray[indexPath.row].helpTopic ?? ""
//        centerviewcontroller.querydetails = VM.queryListArray[indexPath.row].queryDetails ?? ""
//        self.navigationController?.pushViewController(centerviewcontroller, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            if indexPath.row == VM.queryListArray.count - 2{
//                if noofelements == 20{
//                    startindex = startindex + 1
//                    self.queryListApi(queryTopic: self.selectedQueryTopicId, statusId: self.selectedStatusId, StartIndex: startindex)
//                }else if noofelements < 20{
//                    return
//                }else{
//                    print("n0 more elements")
//                    return
//                }
//            }
        }
    
}
