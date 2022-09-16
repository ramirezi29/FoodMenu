//
//  CategoryCVCell.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/12/22.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    @IBOutlet weak var categoryImageView: UIImageView!
    var category: Category? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let category = category else { return }
        categoryTitle.text = category.title
//        categoryButton.setImage(UIImage(named: category.imageTitle), for: .normal)
//        categoryButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        categoryButton.imageView?.contentMode = .scaleAspectFit
//        categoryButton.setImage(UIImage(named: category.imageTitle)?.withRenderingMode(.alwaysOriginal), for: .normal)
        categoryImageView.image = UIImage(named: category.imageTitle)
        
//        categoryImageView.contentVerticalAlignment = .fill
//        categoryImageView.contentHorizontalAlignment = .fill
//        categoryImageView.imageView?.contentMode = .scaleAspectFit
//        categoryButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func CategoryButtonTapped(_ sender: Any) {
        //segue to the
       
      
    }
    
}
