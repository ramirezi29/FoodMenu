//
//  MenuVC.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 1/19/22.
//

import UIKit
import CoreLocation

protocol PlaceOrderProtocol: AnyObject {
    func addOrder()
}

class DetailMenuVC: UIViewController{
    
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cheeseLabel: UILabel!
    @IBOutlet weak var addButton: IRButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    var business: Business?

    weak var orderDelegate: PlaceOrderProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        styleDismissButton()
        view.addVerticalGradientLayer()
        styleButtons()
    }
    
    func styleButtons() {
        phoneNumberButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        addressButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        reviewButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        phoneNumberButton.tintColor = .label
        
        addressButton.tintColor = .label
        
        reviewButton.tintColor = .label
    }
    
    override func loadView() {
        super.loadView()
        view.addVerticalGradientLayer()
    }

    func styleDismissButton() {
        dismissButton.setImage(UIImage(systemName: "x.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)), for: .normal)
        dismissButton.backgroundColor = UIColor(named: "Accent")
    }

    func updateViews() {
        guard let business = business else { return }

        nameLabel.text = business.name
        priceLabel.text = "💰 \(business.price ?? "")"
        cheeseLabel.text = "Rated Highly"
        timeLabel.text =  "⏰ 10-15 mins"
        pizzaImageView.load(yelp: business.imageURL ?? "")
        ratingLabel.text = "⭐️ \(business.rating)"
        phoneNumberButton.setTitle(business.displayPhone, for: .normal)
        reviewButton.setTitle("\(business.reviewCount) Reviews: Click here to view", for: .normal)
        
        addressButton.setTitle(business.location?.displayAddress.joined(separator: " "), for: .normal)
        isOpenLabel.text = openLabel(isOpen: business.isClosed ?? false)
    }
    
    func openLabel(isOpen: Bool) -> String {
        if isOpen {
            return "Open"
        } else {
            return "Closed"
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        orderDelegate?.addOrder()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        guard let business = business else {
            return
        }
        if let url = URL(string: "tel://\(business.displayPhone)") {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
        } else {
            //Present Alert
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
        }
    }
}
