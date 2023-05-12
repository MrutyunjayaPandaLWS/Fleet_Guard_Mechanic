//
//  FG_DashBoardVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 18/01/2023.
//

import UIKit
import ImageSlideshow
import SlideMenuControllerSwift
import Kingfisher
import LanguageManager_iOS


class FG_DashBoardVC: BaseViewController {

    @IBOutlet weak var knowMoreLbl: UILabel!
    @IBOutlet weak var redemptionCatalogueLbl: UILabel!
    @IBOutlet weak var viewDreamGiftLbl: UILabel!
    @IBOutlet weak var clickHereBtn: UIButton!
    @IBOutlet weak var productCatalogueLbl: UILabel!
    @IBOutlet weak var progressCircleView: UIView!
    @IBOutlet weak var progressBarLbl: UILabel!
    //    @IBOutlet weak var offersandPromLbl: UILabel!
//    @IBOutlet weak var redemptionCatalogueLbl: UILabel!
//    @IBOutlet weak var newRangeAdditionLbl: UILabel!
//    @IBOutlet weak var retailerCodeLbl: UILabel!
//    @IBOutlet weak var retailerLblTitle: UILabel!
//    @IBOutlet weak var rplValueLbl: UILabel!
//    @IBOutlet weak var rplNoLbl: UILabel!
//    @IBOutlet weak var totalValue: UILabel!
    
    @IBOutlet weak var passbookNumberTitleLbl: UILabel!
    @IBOutlet weak var totalPointBalTitleLbl: UILabel!
    @IBOutlet weak var progressCircleViewLeading: NSLayoutConstraint!
    @IBOutlet weak var totalPtsBalance: UILabel!
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet var welcomeNameLbl: UILabel!
    @IBOutlet weak var secondLevelView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var bannerImage: ImageSlideshow!
    //@IBOutlet weak var exploreForMoreLbl: UILabel!
    
    @IBOutlet var progressViewDreamGift: UIProgressView!
    @IBOutlet var offersAndPromotionSlideShow: ImageSlideshow!
    @IBOutlet var passbookLbl: UILabel!
    @IBOutlet var emptyImageView: UIImageView!
    //@IBOutlet weak var filtrationLbl: UILabel!
    @IBOutlet var promotionEmptyImage: UIImageView!
    @IBOutlet var dreamGiftProductView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet var dreamGiftDetailsOutBtn: UIButton!
    @IBOutlet var productViewHeight: NSLayoutConstraint!
    @IBOutlet var dreamGiftImageView: UIImageView!
    @IBOutlet var addYourDreamLbl: UILabel!
    @IBOutlet var heightOfTheView: NSLayoutConstraint!
    
    
    
    @IBOutlet var plannerImageView: UIImageView!
    @IBOutlet var plannerCategoryLbl: UILabel!
    @IBOutlet var plannerProductLbl: UILabel!
    @IBOutlet var plannerDetailsBTN: GradientButton!
    @IBOutlet var plannerPointsAvailableHeadingLbl: UILabel!
    @IBOutlet var plannerPointsLbl: UILabel!
    @IBOutlet var plannerPointsRequiredLbl: UILabel!
    @IBOutlet var plannerPointsReqPointsLbl: UILabel!
    
    
    var categoryItemArray = ["Filters", "Coolant & Chemicals", "Center Bearing", "Break Liner"]
    var categoryImageArray = ["OUTLINE", "OUTLINE", "OUTLINE","OUTLINE"]
    var dashboardAarray = [ObjCustomerDashboardList]()
    
    var userId = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var loyaltyId:String = ""{
        didSet{
//            dashboardPointsApi()
            pointsAPI()
        }
    }//UserDefaults.standard.string(forKey: "LoyaltyId") ?? ""
    var secondToken = UserDefaults.standard.string(forKey: "SECONDTOKEN") ?? ""
    var deviceID =  UserDefaults.standard.string(forKey: "deviceID") ?? ""
    var bannerImagesArray = [ObjImageGalleryList]()
    var sourceArray = [AlamofireSource]()
    var offersandPromotionsArray = [LstPromotionJsonList1]()
    var sourceArray1 = [AlamofireSource]()
    var VM = FG_DashboardVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        print(deviceID,"kjslk")
        self.emptyImageView.isHidden = true
        subView.clipsToBounds = true
//        subView.layer.cornerRadius = 20
//        subView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
       // self.dreamGiftDetailsView.constant = 100
        //self.dreamGiftProductView.isHidden = true
        //self.addYourDreamGiftView.isHidden = false
        self.productViewHeight.constant = 100
        self.heightOfTheView.constant = 550
        
        secondLevelView.clipsToBounds = true
        secondLevelView.layer.cornerRadius = 16
        secondLevelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        
        let collectionViewFLowLayout = UICollectionViewFlowLayout()
        collectionViewFLowLayout.itemSize = CGSize(width: (self.view.bounds.width - 100 - (self.categoryCollectionView.contentInset.left + self.categoryCollectionView.contentInset.right)) / 2,  height: 60)
        collectionViewFLowLayout.minimumLineSpacing = 2.5
        collectionViewFLowLayout.scrollDirection = .horizontal
        collectionViewFLowLayout.minimumInteritemSpacing = 2.5
        self.categoryCollectionView.collectionViewLayout = collectionViewFLowLayout
        
        NotificationCenter.default.addObserver(self, selector: #selector(logedInByOtherMobile), name: Notification.Name.logedInByOtherMobile, object: nil)
        self.bannerImagesAPI()
        self.plannerListing()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.changeLeftViewWidth(self.view.frame.size.width * 0.8)
        localization()
        SlideMenuOptions.contentViewScale = 1
        //self.productViewHeight.constant = 200
        self.tokendata()
//        self.pointsAPI()
        self.plannerListing()
    }
    

    func localization(){
        totalPointBalTitleLbl.text = "total_Point_bal".localiz()
        passbookNumberTitleLbl.text = "passbook_number".localiz()
        welcomeTitle.text = "welcome".localiz()
        welcomeLbl.text = "humsafar".localiz()
        viewDreamGiftLbl.text = "View_your_dreamgift".localiz()
        addYourDreamLbl.text = "add_your_dreamGift".localiz()
        productCatalogueLbl.text = "product_Catalogoue".localiz()
        clickHereBtn.setTitle("click_Here".localiz(), for: .normal)
        redemptionCatalogueLbl.text = "redemption_catalogue".localiz()
        knowMoreLbl.text = "know_more".localiz()
    }
    
    
    override func viewDidLayoutSubviews() {
//        self.orderNowBtn.layer.cornerRadius = 14
//        self.orderNowBtn.clipsToBounds = true
        
    }
    
    @objc func logedInByOtherMobile() {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_LoginVC") as? FG_LoginVC
//         vc!.modalPresentationStyle = .overFullScreen
//         vc!.modalTransitionStyle = .crossDissolve
//         self.present(vc!, animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "IsloggedIn?")
        
        if #available(iOS 13.0, *) {
            DispatchQueue.main.async {
                let pushID = UserDefaults.standard.string(forKey: "UD_DEVICE_TOKEN") ?? ""
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(pushID, forKey: "UD_DEVICE_TOKEN")
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                sceneDelegate.setInitialViewAsRootViewController()
             //   self.clearTable2()
            }
        } else {
            DispatchQueue.main.async {
                let pushID = UserDefaults.standard.string(forKey: "UD_DEVICE_TOKEN") ?? ""
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.setValue(pushID, forKey: "UD_DEVICE_TOKEN")
                if #available(iOS 13.0, *) {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.setInitialViewAsRootViewController()
                } else {
                    // Fallback on earlier versions
                }
                
              //  self.clearTable2()
            }
        }
    }
    

    @IBAction func menuBtn(_ sender: Any) {
        self.openLeft()
    }
    
    @IBAction func viewProductBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_NewAdditionVC") as! FG_NewAdditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func languageChangeBtn(_ sender: Any) {
    }
    
    @IBAction func notificationBell(_ sender: Any) {
    }

    
//    @IBAction func orderNowBtn(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_ProductCatalogueListVC") as! FG_ProductCatalogueListVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @IBAction func dreamGiftProductDetailsBTN(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DreamGiftVC") as! FG_DreamGiftVC
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
    
    @IBAction func dreamGiftDetailsViewActBTN(_ sender: Any) {
        if VM.myPlannerListArray.count > 0 {
            self.dreamGiftDetailsOutBtn.isHidden = true
            self.dreamGiftImageView.isHidden = true
            self.addYourDreamLbl.isHidden = true
            self.productViewHeight.constant = 170
            self.heightOfTheView.constant = 627
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DreamGiftVC") as! FG_DreamGiftVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_DreamGiftVC") as! FG_DreamGiftVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //Product Catalogue ActBTN Down
    @IBAction func redemptionCatalogueBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_ProductCatalogueListVC") as! FG_ProductCatalogueListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func redemptionCatActBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_RedemptionCatalogueVC") as! FG_RedemptionCatalogueVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func promotionViewBTN(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyPromotionsVC") as! FG_MyPromotionsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func dashboardApi(){
        let parameter = [
            "ActorId":"\(self.userId)"
        ] as [String: Any]
        print(parameter)
        self.VM.dashboardApi(parameter: parameter)
    }
    
    func dashboardPointsApi(){
        
        let parameter = [
            "ActionType":"1",
//            "ActorId":"\(self.userId)",
            "LoyaltyId":"\(self.loyaltyId)"
        ] as [String: Any]
        print(parameter)
        self.VM.dashboardTotalPointsApi(parameter: parameter)
    }
    
    func productsCategoryListApi(){
        let parameter = [
            "ActionType": 155,
            "ActorId":"\(self.userId)"
        ] as [String: Any]
        print(parameter)
        self.VM.productCategoryListingApi(parameter: parameter)
    }
    
    func pointsAPI(){
        UserDefaults.standard.set(false, forKey: "AfterLog")
        UserDefaults.standard.synchronize()
        let parameters = [
              "ActionType": "1",
              "LoyaltyId": "\(loyaltyId)"
        ] as [String: Any]
        print(parameters)
        self.VM.pointBalenceAPI(parameter: parameters)
        
    }
    
    func plannerListing(){
        let parameters = [
            "ActionType": "6",
            "Points": "\(VM.totalPointBalence)",
            "ActorId": "\(userId)"
        ] as [String : Any]
        print(parameters)
        self.VM.dreamGiftAPI(parameter: parameters)
    }
    
    @objc func didTap() {
//        if bannerImagesArray.count > 0 {
////            bannerView.presentFullScreenController(from: self)
//            for image in bannerImagesArray {
//                print(image.actionImageUrl,"imageURL")
//                if let url = URL(string: "\(image.actionImageUrl ?? "")")
//                    {
//                        UIApplication.shared.openURL(url)
//                    }
//            }
//        }
        
        if self.bannerImagesArray.count > 0 {
            
            bannerImage.presentFullScreenController(from: self)
        }
        
    }
    func bannerImagesAPI() {
        let parameters = [
                "ObjImageGallery": [
                "AlbumCategoryID": "1",
                "ActorId": 2
            ]
            ] as [String: Any]
        print(parameters)
        self.VM.dashboardImagesAPICall(parameters: parameters){ response in
            print(response as Any, "asdfljashdfjadslkfdsalkfjjldsaljfsad")
            if response != nil {
                DispatchQueue.main.async {
                    self.bannerImagesArray = response?.objImageGalleryList ?? []
                    print(self.bannerImagesArray.count, "Banner Image Count")
                    
                    if self.bannerImagesArray.count != 0 {
                        self.ImageSetups()
                        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
                        self.bannerImage.addGestureRecognizer(gestureRecognizer)
                        self.bannerImage.isHidden = false
                        self.emptyImageView.isHidden = true
                        
                        self.bannerImage.setImageInputs(self.sourceArray)
                        self.bannerImage.slideshowInterval = 3.0
                        self.bannerImage.zoomEnabled = true
                        self.bannerImage.contentScaleMode = .scaleToFill
                        
                    }else{
                        self.bannerImage.isHidden = true
                        self.emptyImageView.isHidden = false
                    }
                }
               
                
                
            }else{
                self.bannerImage.isHidden = true
                self.emptyImageView.isHidden = false
                self.emptyImageView.image = UIImage(named: "ic_default_img")
            print("No Resdflksjadfljkasdjflasldjf")
            }
        }
    }
    
    
    func ImageSetups(){
        sourceArray.removeAll()
        if bannerImagesArray.count > 0 {
            for image in bannerImagesArray {
                print(image.imageGalleryUrl,"ImageURL")
                let filterImage = (image.imageGalleryUrl ?? "").dropFirst()
                let images = ("\(Promo_ImageData)\(filterImage)").replacingOccurrences(of: " ", with: "%20")
                print(images,"skjdnj")
                sourceArray.append(AlamofireSource(urlString: images, placeholder: UIImage(named: "ic_default_img"))!)
            //http://fleetguarddemo.loyltwo3ks.com/UploadFiles/ImageGallery/IMAGE_2.jpg
            }
            bannerImage.setImageInputs(sourceArray)
            bannerImage.slideshowInterval = 3.0
            bannerImage.zoomEnabled = false
        } else {
            self.emptyImageView.isHidden = false
        }
    }
    
    func ImageSetups1(){
        sourceArray1.removeAll()
        if self.offersandPromotionsArray.count > 0 {
            for image in self.offersandPromotionsArray {
                
                let filterImage = (image.proImage ?? "").dropFirst(3)
                let images = ("\(PROMO_IMG1)\(filterImage)").replacingOccurrences(of: " ", with: "%20")
                
                sourceArray1.append(AlamofireSource(urlString: images, placeholder: UIImage(named: "ic_default_img"))!)
            }
            offersAndPromotionSlideShow.setImageInputs(sourceArray1)
            offersAndPromotionSlideShow.slideshowInterval = 3.0
            offersAndPromotionSlideShow.zoomEnabled = false
        } else {
            //self.bannerEmptyImg.isHidden = false
        }
    }
    func offersandPromotionsApi(){
        DispatchQueue.main.async {
        }
        self.offersandPromotionsArray.removeAll()
        let parameters = [
            "ActionType": "99",
            "ActorId": "\(self.userId)"
        ] as [String: Any]
        print(parameters)
        self.VM.offersandPromotions(parameters: parameters) { response in
            self.offersandPromotionsArray = response?.lstPromotionJsonList ?? []
            DispatchQueue.main.async {
                if self.offersandPromotionsArray.count > 0{
                    //self.promotionEmptyImage.isHidden = true
                    self.ImageSetups1()
                    self.stopLoading()
                }else{
                    //self.promotionEmptyImage.isHidden = false
                    self.stopLoading()
                }
                
                if self.offersandPromotionsArray.count == 0{
                        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap1))
                        self.offersAndPromotionSlideShow.addGestureRecognizer(gestureRecognizer)
                }else{
                        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap1))
                        self.offersAndPromotionSlideShow.addGestureRecognizer(gestureRecognizer)
                }
            }
        }
    }
    @objc func didTap1() {
        if self.offersandPromotionsArray.count > 0 {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_MyPromotionsVC") as! FG_MyPromotionsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
                    self.dashboardApi()
//                    self.dashboardPointsApi()
                    self.productsCategoryListApi()
                    
                    
                     }catch let parsingError {
                    print("Error", parsingError)
                }
            })
            task.resume()
        }
        }
}
extension FG_DashBoardVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.VM.categoryListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FG_CategoryCVC", for: indexPath) as! FG_CategoryCVC
        cell.titleLbl.text = "\(self.VM.categoryListArray[indexPath.row].attributeNames ?? "")      "
//        cell.categoryImage.image = UIImage(named: "\(self.categoryImageArray[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FG_ProductCatalogueListVC") as! FG_ProductCatalogueListVC
        vc.categoryId3 = Int(self.VM.categoryListArray[indexPath.row].attributeValue ?? "") ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
