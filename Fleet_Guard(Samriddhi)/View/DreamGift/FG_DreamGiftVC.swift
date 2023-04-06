//
//  FG_DreamGiftVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 20/03/23.
//

import UIKit

class FG_DreamGiftVC: BaseViewController,dreamGiftPlannerDelegate {
    func removeProductButton(_ vc: FG_DreamGiftTVC) {
        guard let tappedIndex = myDreamGiftTV.indexPath(for: vc) else{return}
        self.selectedPlannerID = "\(self.VM.myPlannerListArray[tappedIndex.row].redemptionPlannerId ?? 0)"
        self.removeProductInPlanner()
    }
    

    @IBOutlet var myDreamGiftTV: UITableView!
    @IBOutlet var noDataFoundLbl: UILabel!

    var VM = DreamGiftListingVM()    
    var userID = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyID = UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var totalPoints = UserDefaults.standard.string(forKey: "totalEarnedPoints") ?? ""
    var selectedPlannerID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myDreamGiftTV.delegate = self
        self.myDreamGiftTV.dataSource = self
        self.myDreamGiftTV.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.plannerListing()
    }
    
    func plannerListing(){
        let parameters = [
            "ActionType": "6",
            "Points": "\(self.totalPoints)",
            "ActorId": "\(userID)"
        ] as [String : Any]
        print(parameters)
        self.VM.plannerListingApi(parameters: parameters) { response in
            self.VM.myPlannerListArray = response?.objCatalogueList ?? []
            print(self.VM.myPlannerListArray.count, "Planner List Cout")
            DispatchQueue.main.async {
                
                if self.VM.myPlannerListArray.count != 0 {
                    
                    UserDefaults.standard.set(self.VM.myPlannerListArray[0].is_Redeemable ?? 0, forKey: "PlannerIsRedeemable")
                    UserDefaults.standard.synchronize()
                    print(UserDefaults.standard.integer(forKey: "PlannerIsRedeemable"))
                    self.myDreamGiftTV.isHidden = false
                    self.noDataFoundLbl.isHidden = true
                    self.myDreamGiftTV.reloadData()
                }else{
                    self.myDreamGiftTV.isHidden = true
                    self.noDataFoundLbl.isHidden = false
                }
                self.stopLoading()
            }
        }
        
    }
    
    func removeProductInPlanner(){
        let parameters = [
            "ActionType": 17,
            "ActorId": "\(userID)",
            "RedemptionPlannerId": "\(self.selectedPlannerID)"
        ] as [String: Any]
        print(parameters)
        self.VM.removePlannedProduct(parameters: parameters) { response in
            if response?.returnValue == 1{
                self.plannerListing()
                self.navigationController?.popViewController(animated: true)
            }else{
                DispatchQueue.main.async{
                    
                    self.view.makeToast("Something went wrong!", duration: 3.0, position: .bottom)
                    self.stopLoading()
                }
            }
            
        }
    }
    @IBAction func backBTN(_ sender: Any){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func connectToCatalogeActBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_RedemptionCatalogueVC") as! FG_RedemptionCatalogueVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func detailsButton(_ vc: FG_DreamGiftTVC) {
        
        guard let tappedIndex = myDreamGiftTV.indexPath(for: vc) else{return}
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DreamGiftDetailsVC") as! FG_DreamGiftDetailsVC
        vc.productImage = self.VM.myPlannerListArray[tappedIndex.row].productImage ?? ""
        vc.productName = self.VM.myPlannerListArray[tappedIndex.row].productName ?? ""
        vc.productPoints = self.VM.myPlannerListArray[tappedIndex.row].pointsRequired ?? 0
        vc.selectedPlannerID = self.VM.myPlannerListArray[tappedIndex.row].redemptionPlannerId ?? 0
        vc.selectedCatalogueID = self.VM.myPlannerListArray[tappedIndex.row].catalogueId ?? 0
        vc.averageLesserDate = self.VM.myPlannerListArray[tappedIndex.row].avgLesserExpDate ?? ""
        vc.redeemableAverageEarning = self.VM.myPlannerListArray[tappedIndex.row].redeemableAverageEarning ?? ""
        vc.dateOfSubmission = self.VM.myPlannerListArray[tappedIndex.row].achievementDateMonthWize ?? ""
        //vc.isRedeem = self.VM.myPlannerListArray[tappedIndex.row].is_Redeemable ?? 0
        let calcValue =  ((self.VM.myPlannerListArray[tappedIndex.row].pointsRequired ?? 0) - (Int(totalPoints) ?? 0))
        print(calcValue)
        vc.requiredPoints = calcValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension FG_DreamGiftVC : UITableViewDelegate, UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM.myPlannerListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FG_DreamGiftTVC",for: indexPath) as? FG_DreamGiftTVC
        cell?.delegate = self
        cell?.selectionStyle = .none
        
        cell?.productNameLbl.text = self.VM.myPlannerListArray[indexPath.row].productName ?? "-"
        cell?.categoryLbl.text = "Category: \(self.VM.myPlannerListArray[indexPath.row].catogoryName ?? "-")"
        cell?.pointsAvailableLbl.text = "\(Int(VM.myPlannerListArray[indexPath.row].pointBalance ?? 0.0) )"
        cell?.pointsRequiredLbl.text = "Points : \(VM.myPlannerListArray[indexPath.row].pointsRequired ?? 0)"
        
        let balance = Double(self.VM.myPlannerListArray[indexPath.row].pointBalance ?? 0)
        let pointRequired = Double(self.VM.myPlannerListArray[indexPath.row].pointsRequired ?? 0)
        
        
        
        if pointRequired < balance{
            let percentage = CGFloat(balance/pointRequired)
//            cell?..text = "100%"
//            cell?.progressView.progress = Float(percentage)
        }else{
          
            let percentage = CGFloat(balance/pointRequired)
            let final = CGFloat(percentage) * 100
//            cell?.percentageValue.text = "\(Int(final))%"
//            cell?.progressView.progress = Float(percentage)
        }
        

//        cell?.giftName.text = self.VM.myDreamGiftListArray[indexPath.row].dreamGiftName ?? ""
//        cell?.tdsvalue.text = "\(self.VM.myDreamGiftListArray[indexPath.row].tdsPoints ?? 0)"
//
//        cell?.dreamGiftTitle.text = self.VM.myDreamGiftListArray[indexPath.row].giftType ?? ""
//        let createdDate = (self.VM.myDreamGiftListArray[indexPath.row].jCreatedDate ?? "").split(separator: " ")
//        let convertedFormat = convertDateFormater(String(createdDate[0]), fromDate: "MM/dd/yyyy", toDate: "dd/MM/yyyy")
//        cell?.giftCreatedDate.text = convertedFormat
//
//        let desiredDate = (self.VM.myDreamGiftListArray[indexPath.row].jDesiredDate ?? "").split(separator: " ")
//        let desiredDateFormat = convertDateFormater(String(desiredDate[0]), fromDate: "MM/dd/yyyy", toDate: "dd/MM/yyyy")
//        cell?.desiredDate.text = desiredDateFormat
//        cell?.pointsRequired.text = "\(self.VM.myDreamGiftListArray[indexPath.row].pointsRequired ?? 0)"
//        let balance = Double(self.VM.myDreamGiftListArray[indexPath.row].pointsBalance ?? 0)
//        let pointRequired = Double(self.VM.myDreamGiftListArray[indexPath.row].pointsRequired ?? 0)
//        let tdsvalue = self.VM.myDreamGiftListArray[indexPath.row].tdsPoints ?? 0
//        print(Int(pointRequired + Double(tdsvalue)),"data")
//        print(balance,"Balance")
////        if ((Int(pointRequired)) + Int(tdsvalue)) <= Int(balance){
////            cell?.redeemButton.isEnabled = true
////            cell?.redeemButton.backgroundColor = UIColor(red: 189/255, green: 0/255, blue: 0/255, alpha: 1.0)
////        }else{
////            cell?.redeemButton.isEnabled = false
////            cell?.redeemButton.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)
////
////        }
//
//        if self.VM.myDreamGiftListArray[indexPath.row].is_Redeemable ?? -2 != 1{
//            cell?.redeemButton.isEnabled = false
//            cell?.redeemButton.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1.0)
//        }else{
//            cell?.redeemButton.isEnabled = true
//            cell?.redeemButton.backgroundColor = UIColor(red: 189/255, green: 0/255, blue: 0/255, alpha: 1.0)
//            }
//
//
//        cell?.redeemButton.tag = indexPath.row
//        cell?.removeGiftBTN.tag = indexPath.row
//        print(pointRequired,"pointsReq")
//        if pointRequired < balance{
//            let percentage = CGFloat(balance/pointRequired)
//            cell?.percentageValue.text = "100%"
//            cell?.progressView.progress = Float(percentage)
//        }else{
//
//            let percentage = CGFloat(balance/pointRequired)
//            let final = CGFloat(percentage) * 100
//            cell?.percentageValue.text = "\(Int(final))%"
//            cell?.progressView.progress = Float(percentage)
//        }
       
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
