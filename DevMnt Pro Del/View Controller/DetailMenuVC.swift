//
//  MenuVC.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 1/19/22.
//

import UIKit
import CoreLocation


class DetailMenuVC: UIViewController{
    
    @IBOutlet weak var addButton: IRButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var seeAllPhotosLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isOpenLabel: UILabel!
    
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        styleDismissButton()
        styleButtons()
        businessImageView.insetsLayoutMarginsFromSafeArea = false
    }
    
    func styleButtons() {
        phoneNumberButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        phoneNumberButton.tintColor = .label
        
        addressButton.tintColor = .label
        addressButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        reviewButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        reviewButton.tintColor = .label
    }
    
    func styleDismissButton() {
        dismissButton.setImage(UIImage(systemName: "x.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)), for: .normal)
        dismissButton.backgroundColor = UIColor(named: "Accent")
    }
    
    
    func setStars(rating: Double) -> String {
        
        var starRating: String = ""
        switch rating.rounded(.towardZero) {
        case 1:
            starRating = "⭐️"
        case 2:
            starRating = "⭐️⭐️"
        case 3:
            starRating = "⭐️⭐️⭐️"
        case 4:
            starRating = "⭐️⭐️⭐️⭐️"
        case 5:
            starRating = "⭐️⭐️⭐️⭐️⭐️"
        default:
            break
        }
        
        if floor(rating) != rating {
            starRating.append(contentsOf: "½")
        }
        
        return starRating
    }
    
    func updateViews() {
        guard let business = business else { return }
        isOpenLabel.text = "Open now"
        nameLabel.text = "\(business.name)"
        
        nameLabel.textColor = .white
        
        priceLabel.text = "\(business.price ?? "")  \((business.categories.map {$0.title}).joined(separator: ", "))"
        
        businessImageView.load(yelp: business.imageURL ?? "")
        
        ratingLabel.text = "\(setStars(rating: business.rating)) -  \(business.reviewCount)"
        
        ratingLabel.textColor = .white
        
        let attributedString = NSMutableAttributedString(string: nameLabel.text ?? "")
        
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(3.0), range: NSRange(location: 0, length: attributedString.length))
        
        nameLabel.attributedText = attributedString
        
        
        seeAllPhotosLabel.textColor = .white
    }
    
    //MARK: - Action Outlets
    @IBAction func addButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("addToOrder"), object: nil)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        guard let business = business else {
            return
        }
        if let url = URL(string: "tel://\(business.phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
            
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    let phoneNotAvailable = AlertController.presentAlertControllerWith(alertTitle: "Unable to place call", alertMessage: "Ensure you are on a physical device that allows phone calls and not an Xcode simulator", dismissActionTitle: "Dismiss")
                    DispatchQueue.main.async {
                        self.present(phoneNotAvailable, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        guard let business = business else {
            return
        }
        
        guard let myAddress = business.location?.displayAddress.joined(separator: " ") else { return }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(myAddress) { (placemarks, error) in
            guard let placemarks = placemarks?.first else { return }
            let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
            guard let url = URL(string:"http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        guard let business = business else {
            return
        }
        
        if let url = URL(string: business.url) {
            UIApplication.shared.open(url)
        } else {
            let phoneNotAvailable = AlertController.presentAlertControllerWith(alertTitle: "Unable to complete request", alertMessage: "Please try again later", dismissActionTitle: "Dismiss")
            DispatchQueue.main.async {
                self.present(phoneNotAvailable, animated: true)
            }
        }
    }
}
