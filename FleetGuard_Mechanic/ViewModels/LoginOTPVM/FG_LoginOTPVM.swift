//
//  FG_LoginOTPVM.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 01/02/2023.
//

import UIKit
import LanguageManager_iOS


class FG_LoginOTPVM: popUpDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    weak var VC: FG_LoginOTPVC?
    
    var pushID = UserDefaults.standard.string(forKey: "DEVICE_TOKEN") ?? ""
    var requestAPIs = RestAPI_Requests()
    var count = 0
    var timer = Timer()
    var otpData = ""
    var otpVerify = ""
    
    func loginOTPApi(parameter: JSON){
        if self.VC?.enterMobileNumber != "7978779535"{
            DispatchQueue.main.async {
                self.VC?.startLoading()
            }
        }
        self.requestAPIs.otp_Post_API(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    let response = result?.returnMessage ?? ""
                        print(response, "- OTP")
                        //self.VC!.loaderView.isHidden = true
                        self.otpVerify = result?.returnMessage ?? ""
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
    
    func serverOTP(mobileNumber : String, otpNumber : String,completion: @escaping ()->()) {
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        let parameters = [
                "ActionType":"Get Encrypted OTP",
                "MobileNo": mobileNumber,
                "OTP": otpNumber,
                "UserName":""
        ] as [String: Any]
        print(parameters)
        self.requestAPIs.OTP_Validation_API(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil{
                    DispatchQueue.main.async {
                    let response = result?.returnMessage ?? ""
                        print(response, "- OTP")
                        if response > "0"{
//                        if response <= "0"{
                            completion()
//                            self.VC?.claimSubmissionWithOTP()
                        }else{
                            DispatchQueue.main.async{
                                self.VC?.view.makeToast("Enter_valid_OTP".localiz(), duration: 2.0, position: .bottom)
                                self.VC?.txtDPOTPView.text = ""
                            }
                        }
                        self.VC?.stopLoading()
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
    
    func loginSubmissionApi(parameter: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
            //self.VC!.loaderView.isHidden = false
            self.VC!.lottieAnimation(animationView: self.VC!.loaderAnimation)
        }
        self.requestAPIs.loginApi(parameters: parameter) { (result, error) in
            if error == nil{
                if result != nil{
                    let response = result?.userList?.filter({$0.customerTypeID == 54})
                    DispatchQueue.main.async{
                        //self.VC!.loaderView.isHidden = true
                        self.VC?.stopLoading()
                        if (response?.count) ?? 0 > 0{
                            print(response?[0].isDelete ?? 0)
                            print(response?[0].verifiedStatus ?? 0)
                            print(response?[0].isUserActive ?? 0)
                            print(response?[0].result
                                  ?? 0)
                            
                            
                            if response?[0].isDelete ?? 0 == 1{
                                DispatchQueue.main.async{
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                    vc!.delegate = self
                                    vc!.descriptionInfo = "acoount_deleted_error_message".localiz()
                                    vc!.modalPresentationStyle = .overCurrentContext
                                    vc!.modalTransitionStyle = .crossDissolve
                                    self.VC?.present(vc!, animated: true, completion: nil)
                                    self.VC?.stopLoading()
                                }
                            }
                            else if response?[0].verifiedStatus ?? 0 != 1 && response?[0].isUserActive ?? 0 != 1 {
                                
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                vc!.delegate = self
                                
                                vc!.descriptionInfo = "acoount_deleted_error_message".localiz()
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.VC?.present(vc!, animated: true, completion: nil)
                                
                            }
                            else if response?[0].verifiedStatus ?? 0 != 1 && response?[0].verifiedStatus ?? 0 != 4 && response?[0].isUserActive ?? 0 != 1 {
                                
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                vc!.delegate = self
                                vc!.descriptionInfo = "account_is_not_activate".localiz()
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.VC?.present(vc!, animated: true, completion: nil)
                                
                            }else if response?[0].isUserActive ?? 0 != 1 {
                                
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                vc!.delegate = self
                                vc!.descriptionInfo = "account_is_not_activate".localiz()
                                
                                vc!.modalPresentationStyle = .overCurrentContext
                                vc!.modalTransitionStyle = .crossDissolve
                                self.VC?.present(vc!, animated: true, completion: nil)
                                
                            }else
                            if response?[0].customerTypeID == 54{
                                if response?[0].isUserActive ?? 0 == 1 && response?[0].verifiedStatus ?? 0 == 1 && response?[0].result ?? 0 == 1 || response?[0].result ?? 0 == 1{
                                    
                                    UserDefaults.standard.set(response?[0].userId ?? -1, forKey: "UserID")
                                    UserDefaults.standard.set(response?[0].mobile ?? "", forKey: "Mobile_Login")
                                    UserDefaults.standard.set(response?[0].customerTypeID ?? -1, forKey: "CustomerTypeID")
                                    UserDefaults.standard.set(response?[0].name ?? -1, forKey: "UserName")
                                    
                                    UserDefaults.standard.set(response?[0].userType ?? "", forKey: "UserType")
                                    UserDefaults.standard.set(response?[0].userLastName ?? "", forKey: "UserLastName")
                                    UserDefaults.standard.set(response?[0].custAccountNumber ?? "", forKey: "CustomerAccountNumber")
                                    UserDefaults.standard.set(response?[0].email ?? "", forKey: "EmailID")
                                    UserDefaults.standard.set(response?[0].merchantMobileNo ?? "", forKey: "merchantMobileNo")
                                    UserDefaults.standard.set(response?[0].merchantEmailID ?? "", forKey: "merchantEmailID")
                                    UserDefaults.standard.set(response?[0].userName ?? "", forKey: "userName")
                                    UserDefaults.standard.synchronize()
                                    
                                    UserDefaults.standard.set(true, forKey: "IsloggedIn?")
                                    DispatchQueue.main.async{
                                        if #available(iOS 13.0, *) {
                                            let sceneDelegate = self.VC?.view.window?.windowScene?.delegate as? SceneDelegate
                                            sceneDelegate?.setHomeAsRootViewController()
                                        } else {
                                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                            appDelegate?.setHomeAsRootViewController()
                                        }
                                    }
                                    
                                }else{
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
                                    vc!.delegate = self
                                    vc!.descriptionInfo = "account_is_not_activate".localiz()
                                    vc!.modalPresentationStyle = .overCurrentContext
                                    vc!.modalTransitionStyle = .crossDissolve
                                    self.VC?.present(vc!, animated: true, completion: nil)
                                }
                                
                            }else{
                                self.VC?.view.makeToast("Invalid account type", duration: 3.0, position: .bottom)
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                                    self.VC?.navigationController?.popViewController(animated: true)
                                })
                            }
                        }else{
                            self.VC?.view.makeToast("Invalid account type", duration: 3.0, position: .bottom)
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                                self.VC?.navigationController?.popViewController(animated: true)
                            })
                        }
                        }
                    
                    }else{
                        DispatchQueue.main.async {
                            print("ERROR_ \(error)")
                            //self.VC!.loaderView.isHidden = true
                            self.VC?.stopLoading()
                        }
                    
                }
            }else{
                
                DispatchQueue.main.async {
                    print("ERROR_ \(error)")
                   // self.VC!.loaderView.isHidden = true
                    self.VC?.stopLoading()
                }
                
            }
        }
    }

    func otpTimer(){
        self.count = 60
        self.VC?.enteredValue = ""
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        if(count > 1) {
            count = count - 1
            if count <= 10{
                self.VC?.timerLbl.text = "00:0\(count - 1)"
            }else{
                self.VC?.timerLbl.text = "00:\(count - 1)"
            }
            
            self.VC?.resendBtn.isHidden = true
            self.VC?.otpValueLbl.isHidden = false
        }else{
            self.VC?.resendBtn.isHidden = false
            self.VC?.otpValueLbl.isHidden = true
            self.timer.invalidate()
          
        }
    }
}
