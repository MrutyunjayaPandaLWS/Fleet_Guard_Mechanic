//
//  FG_TermsandconditionsVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit
import WebKit
import LanguageManager_iOS

class FG_TermsandconditionsVC: BaseViewController {
    
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var webviewKit: WKWebView!
    var fromSideMenu = ""
    var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
    var aboutName = ""{
        didSet{
            if aboutName.count != 0{
                DispatchQueue.main.async {
                    self.webviewKit.load(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: self.aboutName, ofType: "html")!) as URL) as URLRequest)
                    self.stopLoading()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLbl.text = "Terms_and_condition".localiz()
        self.startLoading()
        languageUpdate()
//        DispatchQueue.main.async {
//            self.stopLoading()
//            self.webviewKit.loadRequest(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "fleetguard-mechanic-t&c", ofType: "html")!) as URL) as URLRequest)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    @IBAction func backBtn(_ sender: Any) {
        if self.fromSideMenu == "SideMenu"{
            NotificationCenter.default.post(name: .sideMenuClosing, object: nil)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
