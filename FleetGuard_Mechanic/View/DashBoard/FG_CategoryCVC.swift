//
//  FG_CategoryCVC.swift
//  Fleet_Guard(Samriddhi)
//
//  Created by ADMIN on 19/01/2023.
//

import UIKit

class FG_CategoryCVC: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                titleLbl.textColor = isSelected ? .white : .white
                titleLbl.backgroundColor = isSelected ? #colorLiteral(red: 0.1803921569, green: 0.4745098039, blue: 1, alpha: 0.2952131057) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                titleLbl.textColor = #colorLiteral(red: 0.1803921569, green: 0.4745098039, blue: 1, alpha: 1)
                
            }else{
                titleLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                titleLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
    
    
}
    
