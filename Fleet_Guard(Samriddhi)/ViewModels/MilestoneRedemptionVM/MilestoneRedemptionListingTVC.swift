//
//  MilestoneRedemptionListingTVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by Arokia-M3 on 28/02/23.
//

import UIKit
protocol mileStoneDelegateData{
    
    func doenloadData(_ cell: MilestoneRedemptionListingTVC)
}

class MilestoneRedemptionListingTVC: UITableViewCell {
    
    
    @IBOutlet var milestoneCodeHeadingLbl: UILabel!
    @IBOutlet var milestoneCodeDataLbl: UILabel!
    
    @IBOutlet var levelPointsHeadingLbl: UILabel!
    @IBOutlet var leavelPointsLbl: UILabel!
    
    @IBOutlet var validityHeadingLbl: UILabel!
    @IBOutlet var validityDataLbl: UILabel!
    
    @IBOutlet var descriptionDataLbl: UILabel!
    @IBOutlet var descriptionHeadingLbl: UILabel!
    
    var delegate:mileStoneDelegateData!
    
    
    @IBOutlet var downloadBTN: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func downloadActBtn(_ sender: Any) {
        self.delegate.doenloadData(self)
    }
}
