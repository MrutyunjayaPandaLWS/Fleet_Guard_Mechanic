//
//  AppDelegate.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 16/01/2023.
//

import UIKit
import CoreData
import SlideMenuControllerSwift
import IQKeyboardManagerSwift
import LanguageManager_iOS

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var slider : SlideMenuController!
    var nav : UINavigationController!
    var gcmMessageIDKey = "gcm.message_id"
    var languageStatus = UserDefaults.standard.string(forKey: "LanguageName")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 4.0))
        UIApplication.shared.statusBarStyle = .lightContent
        tokendata()
        tokendata1()
        languageUpdate()
        
        let tokenStatus: Bool = UserDefaults.standard.bool(forKey: "AfterLog")
        UserDefaults.standard.synchronize()
        print(tokenStatus, "Status")
        
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "IsloggedIn?")
        print(isUserLoggedIn)
        if isUserLoggedIn {
            self.setHomeAsRootViewController()
        } else {
            self.setInitialViewAsRootViewController()
        }
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
//        if let tabBarController = self.window?.rootViewController as? UITabBarController {
//            tabBarController.selectedIndex = 1
//        }

        return true
    }

    
    func languageUpdate(){
        if languageStatus == "English"{
            LanguageManager.shared.setLanguage(language: .en)
        }else if languageStatus == "Hindi"{
            LanguageManager.shared.setLanguage(language: .hi)
        }else if languageStatus == "Tamil"{
            LanguageManager.shared.setLanguage(language: .taIN)
        }else if languageStatus == "Telugu"{
            LanguageManager.shared.setLanguage(language: .teIN)
        }else if languageStatus == "Bengali"{
            LanguageManager.shared.setLanguage(language: .bnIN)
        }else if languageStatus == "Kannada"{
            LanguageManager.shared.setLanguage(language: .knIN)
        }else{
            LanguageManager.shared.setLanguage(language: .en)
        }
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func setHomeAsRootViewController(){
        let leftVC = storyboard.instantiateViewController(withIdentifier: "FG_SideMenuVC") as! FG_SideMenuVC
        languageUpdate()
//        let nav = NavigationController(rootViewController: yourController1)
//        self.yourViewInsertedInController1.addSubview(nav.view)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "FG_TabbarVc") as! FG_TabbarVc
        slider = SlideMenuController(mainViewController: homeVC, leftMenuViewController: leftVC)
        homeVC.comingFrom  = "DelegateData"
        nav = UINavigationController(rootViewController: slider)
        homeVC.tabBar.layer.masksToBounds = true
        homeVC.tabBar.isTranslucent = true
        homeVC.tabBar.barStyle = .default
        homeVC.tabBar.layer.cornerRadius = 20
        homeVC.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        homeVC.selectedIndex = 1
        
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
       
    }
    func setInitialViewAsRootViewController(){
        languageUpdate()
        let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
        let initialVC = mainStoryboard.instantiateViewController(withIdentifier: "FG_LoginVC") as! FG_LoginVC
        UserDefaults.standard.set("1", forKey: "LanguageLocalizable")
        nav = UINavigationController(rootViewController: initialVC)
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .partialCurl
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
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
    
    
    func tokendata1(){
            if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            }else{
                let parameters : Data = "username=\(username2)&password=\(password2)&grant_type=password".data(using: .utf8)!

            let url = URL(string: secondToken)!
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
                        print(parseddata.access_token ?? "", "- SecondToken")
                   
                        UserDefaults.standard.setValue(parseddata.access_token ?? "", forKey: "SECONDTOKEN")
                  
                     }catch let parsingError {
                    print("Error", parsingError)
                }
            })
            task.resume()
        }
        }
    
    
    // MARK: - Core Data stack

    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Fleet_Guard_Samriddhi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

