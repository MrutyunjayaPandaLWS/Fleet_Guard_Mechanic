//
//  RegistrationVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 28/02/23.
//

import UIKit
import LanguageManager_iOS

class RegistrationVM: popUpDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {
    }
    
    
    weak var VC: FG_RegistrationVC?
    var requestApis = RestAPI_Requests()
 
    
    func myRegistrationAPI(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestApis.registrationDataAPI(parameters: parameter) { (result, error) in
            if error == nil {
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                        let response = "\(result?.returnMessage ?? "")"
                        print(response,"skjds")
                        let split = response.split(separator: "~")
                        if split.count != 0{
                            if split[1] == "Saved Successfully"{
                                DispatchQueue.main.async{
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                    vc!.delegate = self
                                    vc!.titleInfo = ""
                                    vc!.itsComeFrom = "Registration"
                                    //vc!.itsFrom = self.VC?.itsComeFrom ?? ""
                                    vc!.descriptionInfo = "query_submit_success_message".localiz()
                                    vc!.modalPresentationStyle = .overCurrentContext
                                    vc!.modalTransitionStyle = .crossDissolve
                                    self.VC?.present(vc!, animated: true, completion: nil)
                                    
                                }
                            }else{
                                
                                self.VC?.view.makeToast("query_submit_failed_message".localiz(), duration: 3.0, position: .bottom)
//                                DispatchQueue.main.async{
//                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                                    vc!.delegate = self
//                                    vc!.titleInfo = ""
//                                    vc!.itsComeFrom = "Registration"
//                                    vc!.descriptionInfo = "Your submission failed."
//                                    vc!.modalPresentationStyle = .overCurrentContext
//                                    vc!.modalTransitionStyle = .crossDissolve
//                                    self.VC?.present(vc!, animated: true, completion: nil)
//                                }
                            }
                        }
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }

                }
            }else{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
            }
        }
    }
    
    
    
    func verifyUserExistency(parameters: JSON!){
        self.VC?.startLoading()
       // self.VC?.loaderView.isHidden = false
        //self.VC?.lottieAnimation(animationView: self.VC!.loaderAnimation)
       
        let url = URL(string: checkUserExistencyURL)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(self.VC?.token ?? "")", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do{
                let str = String(decoding: data, as: UTF8.self) as String?
                 print(str, "Response")
                if str ?? "" != "1"{
                        DispatchQueue.main.async{
                            self.VC?.stopLoading()
                            //self.VC!.loaderView.isHidden = true
                        }
                    }else{
                        DispatchQueue.main.async{
                            self.VC?.stopLoading()
                            //self.VC!.loaderView.isHidden = true
//                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                            vc!.delegate = self
//                            vc!.titleInfo = ""
//                            vc!.descriptionInfo = "Mobile number already registered !"
//                            vc!.modalPresentationStyle = .overCurrentContext
//                            vc!.modalTransitionStyle = .crossDissolve
//                            self.VC?.present(vc!, animated: true, completion: nil)
                            self.VC?.view.makeToast("mobile_number_already_exist".localiz(), duration: 3.0, position: .bottom)
                            self.VC?.mobileTF.text = ""
                        }
                    }
                     }catch{
                         DispatchQueue.main.async {
                             self.VC?.stopLoading()
                             //self.VC!.loaderView.isHidden = true
                         }
                         print("parsing Error")
                }
            })
            task.resume()
        }
    
    
}
