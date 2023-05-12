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
    @IBOutlet var aboutWebview: UIWebView!
    
    var fromSideMenu = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLbl.text = "About".localiz()
        DispatchQueue.main.async {
            self.stopLoading()
            self.aboutWebview.loadRequest(NSURLRequest(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "fg-Mechanic-about-eng", ofType: "html")!) as URL) as URLRequest)
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
