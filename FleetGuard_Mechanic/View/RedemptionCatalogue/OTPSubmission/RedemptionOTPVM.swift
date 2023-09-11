//
//  RedemptionOTPVM.swift
//  CenturyPly_JSON
//
//  Created by ADMIN on 19/04/2022.
//

import UIKit


class RedemptionOTPVM{

    weak var VC:FG_RedemptionOTPVC?
    var requestAPIs = RestAPI_Requests()

    var myCartListArray = [CatalogueSaveCartDetailListResponse]()
    
    func myCartList(parameters: JSON, completion: @escaping (RedemptionCatalogueMyCartListModel?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.redemptionCatalogueMycartListApi(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                       
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }

        }
    }
    
    }
    
    func redemptionOTPValue(parameters: JSON, completion: @escaping (RedemptionOTPModels?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.redemptionOTP(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                       
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
    
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    
                    self.VC?.stopLoading()
                }

        }
    }

    }
    func sendSMSApi(parameters: JSON, completion: @escaping (SendSMSModel?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.sendSMSApi(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                       
                        completion(result)
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                      
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                
                    self.VC?.stopLoading()
                }

        }
    }

    }
    func userStatus(parameters: JSON, completion: @escaping (UserStatusModels?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.userIsActive(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                       
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    
                    self.VC?.stopLoading()
                }

        }
    }

    }
    
    func redemptionSubmission(parameters: JSON, completion: @escaping (RedemptionSubmission?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.redemptionSubmission(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    
                    self.VC?.stopLoading()
                }

        }
    }

    }
    
    func sendSUCESSApi(parameters: JSON, completion: @escaping (SendSuccessModels?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        }
        self.requestAPIs.sendSuccessMessage(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                       
                        completion(result)
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    
                    self.VC?.stopLoading()
                }

        }
    }

    }
    
    func removeDreamGift(parameters: JSON, completion: @escaping (RemoveGiftModels?) -> ()){
        DispatchQueue.main.async {
            self.VC?.startLoading()
        
        }
        self.requestAPIs.removeDreamGifts(parameters: parameters) { (result, error) in
            if error == nil{
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)

                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
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
                        }else{
                            DispatchQueue.main.async{
                                self.VC?.view.makeToast("Enter_valid_OTP".localiz(), duration: 2.0, position: .bottom)
                                self.VC?.otpView.text = ""
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
    
   }
