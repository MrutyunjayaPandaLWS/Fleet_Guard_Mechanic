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
        self.tokendata()
    }
    
    func localization() {
        self.welcomeToLbl.text = "welcome".localiz()
        self.alreadyAMemberLbl.text = "AlreadyaMember".localiz()
        self.loginNowLbl.text = "LoginNow".localiz()
        self.mobileNumberLbl.text = "Mobilenumber".localiz()
        self.sendOtpBtn.setTitle("SendOTP".localiz(), for: .normal)
        self.newToSamriddhiLbl.text = "NewtoSamriddhi".localiz()
        self.contactUsBtn.setTitle("Contactusnow".localiz(), for: .normal)
        self.mobileTF.placeholder = "Enteryourmobilenumber".localiz()
    }
    
    

    @IBAction func sendOTPBtn(_ sender: Any) {
        if self.mobileTF.text!.count == 0 {
//            DispatchQueue.main.async{
//               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_PopUpVC") as? FG_PopUpVC
//                vc!.delegate = self
//                vc!.descriptionInfo = "Enter mobile number"
//                vc!.modalPresentationStyle = .overFullScreen
//                vc!.modalTransitionStyle = .crossDissolve
//                self.present(vc!, animated: true, completion: nil)
//            }
            self.view.makeToast("Please enter mobile number", duration: 3.0, position: .bottom)
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
                    "ActionType": "57",
                    "Location": [
                        "UserName": "\(self.mobileTF.text ?? "")"
                    ]
            ] as [String: Any]
            print(parameter)
            self.VM.verifyMobileNumberAPI(paramters: parameter)
           
        }
       
    }
    
    @IBAction func contactUsNowBtn(_ sender: Any) {
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
        print(vc.boolResult, "sdakflasklfsadkjlfdsaljkfdsaljkadsfdfljks")
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
    
    
 
}



