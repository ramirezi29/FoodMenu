//
//  ItemVCell.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 1/19/22.
//

import UIKit

class SuggestedCVCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var cheeseLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func updateViews(business: Business?) {
        guard let business = business else { return }
        nameLabel.text =  business.name
        priceLabel.text = "Price \(business.price ?? "")"
        cheeseLabel.text = "\(business.location?.city ?? ""), \(business.location?.state ?? "")"
    }
    
}
