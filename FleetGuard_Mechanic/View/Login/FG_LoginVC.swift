//
//  ViewController.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 16/01/2023.
//

import UIKit
import AdSupport
import Lottie
import LanguageManager_iOS
class FG_LoginVC: BaseViewController, popUpDelegate, UITextFieldDelegate,CheckBoxSelectDelegate {
    func popupAlertDidTap(_ vc: FG_PopUpVC) {}
    
    @IBOutlet weak var termsAndCondBtn: UIButton!
    @IBOutlet weak var acceptLbl: UILabel!
    @IBOutlet weak var loaderAnimation: LottieAnimationView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var welcomeToLbl: UILabel!
    @IBOutlet weak var alreadyAMemberLbl: UILabel!
    @IBOutlet weak var loginNowLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet weak var newToSamriddhiLbl: UILabel!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
 
    var VM = FG_LoginVM()
    var boolResult:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
        self.VM.VC = self
        self.mobileTF.setLeftPaddingPoints(13)
        self.mobileTF.keyboardType = .asciiCapableNumberPad
        self.mobileTF.delegate = self
        self.checkBoxBtn.setImage(UIImage(named: "square"), for: .normal)
        self.boolResult = false
//        self.loaderView.isHidden = false
//        lottieAnimation(animationView: loaderAnimation)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loaderView.isHidden = true
        
        if MyCommonFunctionalUtilities.isInternetCallTheApi() == true{
            self.tokendata()
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        localization()
    }
    

    
    

    @IBAction func sendOTPBtn(_ sender: Any) {
        
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                   let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                   vc.modalTransitionStyle = .crossDissolve
                   vc.modalPresentationStyle = .overFullScreen
                   self.present(vc, animated: true)
               return
               }
        if self.mobileTF.text!.count == 0 {
//            DispatchQueue.main.async{
//               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Enter mobile number"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
//            }
            self.view.makeToast("enter_mobile_number_error".localiz(), duration: 3.0, position: .bottom)
        }
//        else if self.mobileTF.text!.count != 10 {
//            DispatchQueue.main.async{
//               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Enter valid mobile number"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
//            }
//        }
        else{
            let parameter = [
                    "ActionType": "66",
                    "Location": [
                        "UserName": "\(self.mobileTF.text ?? "")"
                    ]
            ] as [String: Any]
            print(parameter)
            self.VM.verifyMobileNumberAPI(paramters: parameter)
           
        }
       
    }
    
    @IBAction func contactUsNowBtn(_ sender: Any) {
        
        guard MyCommonFunctionalUtilities.isInternetCallTheApi() == true else{
                   let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IOS_FG_Internet_Check") as! IOS_FG_Internet_Check
                   vc.modalTransitionStyle = .crossDissolve
                   vc.modalPresentationStyle = .overFullScreen
                   self.present(vc, animated: true)
               return
               }
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_RegistrationVC") as! FG_RegistrationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func mobileNumberEditingDidEnd(_ sender: Any) {
    }

    @IBAction func checkBoxButton(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HR_TermsandCondtionVC") as? HR_TermsandCondtionVC
        vc?.delegate = self
//        vc?.modalTransitionStyle = .coverVertical
//        vc?.modalPresentationStyle = .overFullScreen
//        self.present(vc!, animated: true)
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    func decline(_ vc: HR_TermsandCondtionVC) {
        self.checkBoxBtn.setImage(UIImage(named: "square"), for: .normal)
    }
    func accept(_ vc: HR_TermsandCondtionVC) {
        print(vc.boolResult, "terms condition status")
        if vc.boolResult == true{
            self.boolResult = true
            self.checkBoxBtn.setImage(UIImage(named: "tick"), for: .normal)
            return
        }else{
            self.checkBoxBtn.setImage(UIImage(named: "square"), for: .normal)
            self.boolResult = false
            return
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (self.mobileTF.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    func tokendata(){
            if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            }else{
                let parameters : Data = "username=\(username)&password=\(password)&grant_type=password".data(using: .utf8)!

            let url = URL(string: tokenURL)!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            do {
                request.httpBody = parameters
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
           
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do{
                    let parseddata = try JSONDecoder().decode(TokenModels.self, from: data)
                        print(parseddata.access_token ?? "", "- Token")
                        UserDefaults.standard.setValue(parseddata.access_token ?? "", forKey: "TOKEN")
                   
                     }catch let parsingError {
                    print("Error", parsingError)
                }
            })
            task.resume()
        }
        }
    
    
    func localization(){
        welcomeToLbl.text = "welcome_to".localiz()
        alreadyAMemberLbl.text = "already_a_Member".localiz()
        loginNowLbl.text = "login_Now".localiz()
        mobileNumberLbl.text = "mobile_number".localiz()
        mobileTF.placeholder = "enter_mobile_number".localiz()
        sendOtpBtn.setTitle("send_otp".localiz(), for: .normal)
        acceptLbl.text = "Accept".localiz()
        termsAndCondBtn.setTitle("Terms_and_condition".localiz(), for: .normal)
        newToSamriddhiLbl.text = "new_to_humsafar".localiz()
        contactUsBtn.setTitle("contact_us".localiz(), for: .normal)
    }
    
}



