//
//  FG_MyOrdersVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit

class FG_MyOrdersVC: BaseViewController,myOrderDelegate {
    func myOrderDelegate(_ cell: FG_MyOrderTVC) {
        guard let tappedIndexPath = self.myOrderTableView.indexPath(for: cell) else{return}
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyOrdersDetailsVC") as! FG_MyOrdersDetailsVC
        vc.ordernumber = "\(VM.myOrderListingArray[tappedIndexPath.row].orderNo ?? "")"
        let date = VM.myOrderListingArray[tappedIndexPath.row].orderDate ?? "-"
        let splitDate = date.split(separator: " ")
        vc.orderDate = "\(splitDate[0])"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBOutlet weak var myOrderTableView: UITableView!
    @IBOutlet weak var noDataFound: UILabel!
    @IBOutlet var orderHeaderStack: UIStackView!
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    
    var VM = MyOrderListingVM()
    var noofelements = 0
    var startindex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.myOrderTableView.delegate = self
        self.myOrderTableView.dataSource = self
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            DispatchQueue.main.async{
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }else{
            self.myOrderListingAPI(startInx: startindex)
        }
        
        
        self.orderHeaderStack.clipsToBounds = true
        orderHeaderStack.layer.cornerRadius = 15
        orderHeaderStack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    


    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func myOrderListingAPI(startInx:Int){
        let parameters = [
            "ActionType": 18,
            "ActorId": "\(userId)",
            "OrderStatus": -2,
            "JFromDate": "",
            "JToDate": "",
            "PageIndex": "\(startInx)",
            "PageSize": 20
        ] as [String: Any]
        self.VM.myOrderListingAPI(parameters: parameters)
    }
    
}
extension FG_MyOrdersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.myOrderListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FG_MyOrderTVC", for: indexPath) as! FG_MyOrderTVC
        cell.delegate = self
        cell.statusLbl.text = VM.myOrderListingArray[indexPath.row].orderStatus ?? "-"
        cell.sourceLbl.text = VM.myOrderListingArray[indexPath.row].sourceMode
        let date = VM.myOrderListingArray[indexPath.row].orderDate ?? "-"
        let splitDate = date.split(separator: " ")
        cell.orderDateLbl.text = "\(splitDate[0])"
        cell.myOrderLbl.text = "\(VM.myOrderListingArray[indexPath.row].orderNo ?? "")"
        
        
        if (indexPath.row) % 2 == 0{
            cell.orderIndexStackView.backgroundColor = #colorLiteral(red: 1, green: 0.9647058824, blue: 0.8196078431, alpha: 1)
        }else{
            cell.orderIndexStackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        
        
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == VM.myOrderListingArray.count - 2{
                if noofelements == 20{
                    startindex = startindex + 1
                    self.myOrderListingAPI(startInx: startindex)
                }else if noofelements < 20{
                    return
                }else{
                    print("n0 more elements")
                    return
                }
            }
        }
}
