//
//  HR_TermsandCondtionVC.swift
//  HR_Johnson
//
//  Created by ADMIN on 14/05/2022.
//

import UIKit
import WebKit
//import Firebase
import Lottie
import LanguageManager_iOS


protocol CheckBoxSelectDelegate{
    func accept(_ vc: HR_TermsandCondtionVC)
    func decline(_ vc: HR_TermsandCondtionVC)
}

class HR_TermsandCondtionVC: BaseViewController{
    


    
    @IBOutlet weak var webview1: WKWebView!
    @IBOutlet weak var termsandCondtions: UILabel!
    @IBOutlet weak var decline: UIButton!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var loaderAnimatedView: LottieAnimationView!
       @IBOutlet weak var loaderView: UIView!
    var boolResult:Bool = false
    var delegate: CheckBoxSelectDelegate!
    var requestAPIs = RestAPI_Requests()
    var itsFrom = ""
    var fromSideMenu = ""
    var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
    var aboutName = ""{
        didSet{
            if aboutName.count != 0{
                DispatchQueue.main.async {
                    self.webview1.load(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: self.aboutName, ofType: "html")!) as URL) as URLRequest)
                    self.stopLoading()
                }
            }
        }
    }
//    var tcListingArray = [LstTermsAndCondition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let filePath = Bundle.main.url(forResource: "fleetguard-mechanic-t&c", withExtension: "html") {
//          let request = NSURLRequest(url: filePath)
//            webview1.load(request as URLRequest)
//        }
//        self.loaderView.isHidden = false
//        self.lottieAnimation(animationView: self.loaderAnimatedView)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//          //  self.loaderView.isHidden = true
//        }
      
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localization()
        languageUpdate()
    }
    
    func languageUpdate(){
        if languageStatus == "English"{
            aboutName = "fleetguard-mechanic-T&C-Eng"
        }else if languageStatus == "Hindi"{
            aboutName = "fleetguard-mechanic-T&C-Hindi"
        }else if languageStatus == "Tamil"{
            aboutName = "fleetguard-mechanic-T&C-Tamil"
        }else if languageStatus == "Telugu"{
            aboutName = "fleetguard-mechanic-T&C-Telugu"
        }else if languageStatus == "Bengali"{
            aboutName = "fleetguard-mechanic-T&C-Bengali"
        }else if languageStatus == "Kannada"{
            aboutName = "fleetguard-mechanic-T&C-Kannada"
        }else{
            aboutName = "fleetguard-mechanic-T&C-Eng"
        }
    }

    
    @IBAction func declineBTN(_ sender: Any) {
       
        self.boolResult = false
        self.delegate.decline(self)
//        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func acceptBTN(_ sender: Any) {
        self.boolResult = true
        self.delegate.accept(self)
//        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func localization(){
        decline.setTitle("decline".localiz(), for: .normal)
        accept.setTitle("accept".localiz(), for: .normal)
    }
    
}
