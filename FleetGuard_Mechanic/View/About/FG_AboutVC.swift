//
//  FG_AboutVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit
import WebKit
import LanguageManager_iOS

class FG_AboutVC: BaseViewController {

    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var aboutWebview: WKWebView!
    
    var fromSideMenu = ""
    var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
    var aboutName = ""{
        didSet{
            if aboutName.count != 0{
                self.aboutWebview.load(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: aboutName, ofType: "html")!) as URL) as URLRequest)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLbl.text = "About".localiz()
//        DispatchQueue.main.async {
//            self.stopLoading()
//            self.aboutWebview.loadRequest(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "fg-Mechanic-about-eng", ofType: "html")!) as URL) as URLRequest)
//        }
        languageUpdate()
    }
    
    func languageUpdate(){
        if languageStatus == "English"{
            aboutName = "fg-Mechanic-about-Eng"
        }else if languageStatus == "Hindi"{
            aboutName = "fg-Mechanic-about-Hindi"
        }else if languageStatus == "Tamil"{
            aboutName = "fg-Mechanic-about-Tamil"
        }else if languageStatus == "Telugu"{
            aboutName = "fg-Mechanic-about-Telugu"
        }else if languageStatus == "Bengali"{
            aboutName = "fg-Mechanic-about-Bengali"
        }else if languageStatus == "Kannada"{
            aboutName = "fg-Mechanic-about-Kannada"
        }else{
            aboutName = "fg-Mechanic-about-Eng"
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        if self.fromSideMenu == "SideMenu"{
            NotificationCenter.default.post(name: .sideMenuClosing, object: nil)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       // self.navigationController?.popToRootViewController(animated: true)
    }
    
}
