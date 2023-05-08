//
//  FG_LoginVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 01/02/2023.
//

import UIKit
import LanguageManager_iOS

class FG_LoginVM: popUpDelegate{
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    
    weak var VC: FG_LoginVC?
    var requestApis = RestAPI_Requests()
    var pushID = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
    
    
    
    func verifyMobileNumberAPI(paramters: JSON){
        self.VC?.startLoading()
//        self.VC!.loaderView.isHidden = false
//        self.VC!.lottieAnimation(animationView: self.VC!.loaderAnimation)
        let url = URL(string: checkUserExistencyURL)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "TOKEN") ?? "")", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do{
                let str = String(decoding: data, as: UTF8.self) as String?
                 print(str, "- Mobile Number Exists")
                if str ?? "" == "1"{
                    DispatchQueue.main.async {
                        
                        self.VC?.stopLoading()
//                        self.VC!.loaderView.isHidden = true
//                        if self.VC!.boolResult == false{
////                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
////                             vc!.delegate = self
////                             vc!.descriptionInfo = "Please accept terms and condition"
////                             vc!.modalPresentationStyle = .overFullScreen
////                             vc!.modalTransitionStyle = .crossDissolve
////                             self.VC?.present(vc!, animated: true, completion: nil)
//                            self.VC?.view.makeToast("Please accept terms and condition", duration: 3.0, position: .bottom)
//                        }else{
                            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_LoginOTPVC") as! FG_LoginOTPVC
                            vc.enterMobileNumber = self.VC?.mobileTF.text ?? ""
                            self.VC?.navigationController?.pushViewController(vc, animated: true)
//                        }
                    }
                }else{
                    DispatchQueue.main.async{
                        self.VC?.stopLoading()
                       // self.VC!.loaderView.isHidden = true
                        
//                       let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                        vc!.delegate = self
//                        vc!.descriptionInfo = "The mobile number that you have entered is not present in the  system."
//                        vc!.modalPresentationStyle = .overFullScreen
//                        vc!.modalTransitionStyle = .crossDissolve
//                        self.VC?.present(vc!, animated: true, completion: nil)
                        
                        self.VC?.view.makeToast("mobile_number_not_exist".localiz(), duration: 3.0, position: .bottom)
                        self.VC?.mobileTF.text = ""
                    }
                }
                 }catch{
                     self.VC?.stopLoading()
                     //self.VC!.loaderView.isHidden = true
                     print("parsing Error")
            }
        })
        task.resume()
    }
}

