//
//  FG_LoginOTPVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 01/02/2023.
//

import UIKit
import DPOTPView
import LanguageManager_iOS
import Lottie
class FG_LoginOTPVC: BaseViewController, popUpDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    @IBOutlet weak var loaderAnimation: LottieAnimationView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var welcomeToLbl: UILabel!
    
    @IBOutlet weak var alreadyAmemberLbl: UILabel!
    
    @IBOutlet weak var loginNowLbl: UILabel!
    
    @IBOutlet weak var otpSentToLbl: UILabel!
    
    @IBOutlet weak var otpValueLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var otpWillRecieveLbl: UILabel!
    @IBOutlet weak var txtDPOTPView: DPOTPView!
    var pushID = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
    var enterMobileNumber = ""
    var txtOTPView: DPOTPView!
    var enteredValue = ""
    var receivedOTP = "1234"
    var VM = FG_LoginOTPVM()
    var deviceID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.otpValueLbl.isHidden = false
        self.resendBtn.isHidden = true
        txtDPOTPView.dpOTPViewDelegate = self
        txtDPOTPView.fontTextField = UIFont.systemFont(ofSize: 25)
        txtDPOTPView.textEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        txtDPOTPView.editingTextEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        txtDPOTPView.spacing = 10
        txtDPOTPView.fontTextField = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(16.0))!
        txtDPOTPView.dismissOnLastEntry = true
        txtDPOTPView.borderColorTextField = #colorLiteral(red: 0.9607843137, green: 0.6392156863, blue: 0.007843137255, alpha: 1)
        txtDPOTPView.borderWidthTextField = 1
        txtDPOTPView.backGroundColorTextField = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
        txtDPOTPView.cornerRadiusTextField = 8
        txtDPOTPView.isCursorHidden = true
        self.loaderView.isHidden = true
//        lottieAnimation(animationView: loaderAnimation)
       
      
        
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
              return
           }
        print(deviceID)
        self.deviceID = deviceID
        UserDefaults.standard.set(deviceID, forKey: "deviceID")
        self.OtpApi(mobilenumber: self.enterMobileNumber)
        self.VM.otpTimer()
        self.otpSentToLbl.text = "Enter OTP sent to \(self.enterMobileNumber)"
    }
       
    //9993870230
    @IBAction func resendButton(_ sender: Any) {
        self.VM.timer.invalidate()
        self.VM.otpTimer()
        self.OtpApi(mobilenumber: self.enterMobileNumber)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.VM.timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        if self.enteredValue.count == 0 {
            DispatchQueue.main.async{
//               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Enter OTP"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
                
                self.view.makeToast("Enter OTP", duration: 3.0, position: .bottom)
            }
        }else if self.enteredValue.count != 4 {
            DispatchQueue.main.async{
//               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Enter valid OTP"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
                
                self.view.makeToast("Enter valid OTP", duration: 3.0, position: .bottom)
            }
        }else if self.enteredValue.count == 4{
            print(self.enteredValue)
            print(self.receivedOTP)
            if self.enteredValue == self.receivedOTP{
                DispatchQueue.main.async{
                    self.loginSubmissionApi(mobileNumber: self.enterMobileNumber, deviceID: self.deviceID, pushID: self.pushID)
                }
            }else{
                DispatchQueue.main.async{
//                   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                    vc!.delegate = self
//                    vc!.descriptionInfo = "Enter valid OTP"
//                    vc!.modalPresentationStyle = .overFullScreen
//                    vc!.modalTransitionStyle = .crossDissolve
//                    self.present(vc!, animated: true, completion: nil)
                    
                    self.view.makeToast("Enter valid OTP", duration: 3.0, position: .bottom)
                }
            }
        }else{
            DispatchQueue.main.async{
//               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Enter valid OTP"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
                
                self.view.makeToast("Enter valid OTP", duration: 3.0, position: .bottom)
            }
        }
        
        
    }
    
    func OtpApi(mobilenumber: String){
        let parameter = [
            "UserName": "",
              "UserId": 5,
            "MobileNo": mobilenumber,
              "OTPType": "Enrollment",
              "MerchantUserName": "FleedguardMerchantDemo"
        ] as [String: Any]
        print(parameter)
        self.VM.loginOTPApi(parameter: parameter)
    }
    
    
//    "Browser": "Android",
//       "LoggedDeviceName": "Android",
//       "Password": "1234",
//       "PushID": "",
//       "LoggedDeviceID": "abaa017408a54264",
//       "UserActionType": "GetPasswordDetails",
//       "UserName": "9993870230",
//       "UserType": "Customer"
    
    func loginSubmissionApi(mobileNumber: String, deviceID: String, pushID: String){
        let parameter = [
            "Password": "123456",
            "UserName": mobileNumber,
            "UserActionType": "GetPasswordDetails",
            "Browser": "iOS",
            "LoggedDeviceName": "iOS",
            "PushID": pushID,
            "UserType": "Customer",
            "LoggedDeviceID": deviceID
        ] as [String: Any]
        print(parameter)
        self.VM.loginSubmissionApi(parameter: parameter)
    }
}
extension FG_LoginOTPVC : DPOTPViewDelegate {
    func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
        self.enteredValue = "\(text)"
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}

