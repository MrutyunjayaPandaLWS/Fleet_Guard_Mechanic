//
//  FG_FAQsVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit
import WebKit
import LanguageManager_iOS

class FG_FAQsVC: BaseViewController {

   
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var webviewKit: WKWebView!
    
    var fromSideMenu = ""
    var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
    var aboutName = ""{
        didSet{
            if aboutName.count != 0{
                DispatchQueue.main.async {
                    self.webviewKit.load(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: self.aboutName, ofType: "html")!) as URL) as URLRequest)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        languageUpdate()
        headerLbl.text = "FAQs".localiz()
//        DispatchQueue.main.async {
//            self.stopLoading()
//            self.webviewKit.loadRequest(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "fg-Mechanic-faq", ofType: "html")!) as URL) as URLRequest)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func languageUpdate(){
        if languageStatus == "English"{
            aboutName = "fg-Mechanic-faq-Eng"
        }else if languageStatus == "Hindi"{
            aboutName = "fg-Mechanic-faq-Hindi"
        }else if languageStatus == "Tamil"{
            aboutName = "fg-Mechanic-faq-Tamil"
        }else if languageStatus == "Telugu"{
            aboutName = "fg-Mechanic-faq-Telugu"
        }else if languageStatus == "Bengali"{
            aboutName = "fg-Mechanic-faq-Bengali"
        }else if languageStatus == "Kannada"{
            aboutName = "fg-Mechanic-faq-Kannada"
        }else{
            aboutName = "fg-Mechanic-faq-Eng"
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
