//
//  PizzaVC.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 1/19/22.
//

import UIKit




//Conform to the protocol
class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var OrderNowView: UIView!
    @IBOutlet weak var orderButton: IRButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIconImage: UIImageView!
    
    let networkManger = NetworkManager()
    var tally: Int = 0
    
    private var yelpData: YelpData? = nil {
        didSet {
            DispatchQueue.main.async {
                self.suggestionCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        fetch()
        styleBackgroundElements()
        OrderButtonStyle()
        updateLocationLabel()
        orderButton.setTitle("No Orders", for: .normal)
        //Note: - Alternative to notification center would be the protocol and delegate pattern
        NotificationCenter.default.addObserver(self, selector: #selector(self.addToOrder(notification:)), name: Notification.Name("addToOrder"), object: nil)
    }
    
    @objc func addToOrder(notification: Notification) {
        tally += 1
        DispatchQueue.main.async {
            self.orderButton.setTitle("Order Now \(self.tally)", for: .normal)
        }
    }
    
    func updateLocationLabel() {
        locationIconImage.image = UIImage(systemName: "location")
        locationLabel.text = "Lehi, UT"
        locationLabel.font = UIFont(name: "secondary", size: 12)
    }
    
    func styleBackgroundElements() {
        categoryCollectionView.backgroundColor = .clear
        suggestionCollectionView.backgroundColor = .clear
        OrderNowView.layer.cornerRadius = 15
        
        OrderNowView.addVerticalGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func OrderButtonStyle() {
        orderButton.setTitle(tally > 0 ? "Order Now \(tally)" : "No Orders", for: .normal)
    }
    
    func fetch() {
        networkManger.fetchBusiness(type: "popular food") { result in
            switch result {
            case .failure(let error):
                self.presentAlert(with: error.errorDescription  ?? "Try Again")
            case .success(let yelpBusiness):
                self.yelpData = yelpBusiness
            }
        }
    }
    
    func newFetch() {
        Task {
            do {
                let info = try await networkManger.newFetchBusiness()
                
                yelpData = info
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCollectionView {
            return CategoryOptions.categories.count
        }
        
        return   yelpData?.businesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            guard let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCVCell else { return UICollectionViewCell() }
            
            let category = CategoryOptions.categories[indexPath.row]
            categoryCell.category = category
            
            return categoryCell
        }
        guard let suggestionCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestedCVCell else { return UICollectionViewCell() }
        
        let business = yelpData?.businesses[indexPath.row]
        suggestionCell.updateViews(business: business)
        suggestionCell.businessImageView.load(yelp: business?.imageURL ?? "")
        
        return suggestionCell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? DetailMenuVC,
                  
                    let cell = sender as? SuggestedCVCell,
                  
                    let indexPath = self.suggestionCollectionView.indexPath(for: cell),
                  
                    let businessDetails = yelpData?.businesses[indexPath.row] else { return }
            
            destinationVC.business = businessDetails
        }
        
        if segue.identifier == "toCategoryVC" {
            guard let destinationVC = segue.destination as? CategoryTVC,
                  
                    let cell = sender as? CategoryCVCell,
                  
                    let indexPath = self.categoryCollectionView.indexPath(for: cell) else { return }
            
            let selectedCategory = CategoryOptions.categories[indexPath.row]
            
            destinationVC.selectedCategory = selectedCategory
        }
        
    }
    
    // MARK: -
    
    func orderPlaced() {
        guard tally > 0 else {
            DispatchQueue.main.async {
                self.driverImage.shake()
            }
            return
        }
        DispatchQueue.main.async {
            self.animateOffScreen(imageView: self.driverImage)
        }
    }
    
    // MARK: - IBOutlet Action
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        orderPlaced()
    }
}

extension HomeVC {
    
    func animateOffScreen(imageView: UIImageView) {
        let originalCenter = imageView.center
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                imageView.center.x -= 80.0
                imageView.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: -.pi / 80)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                imageView.center.x -= 100.0
                imageView.center.y += 50.0
                imageView.alpha = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
                imageView.transform = .identity
                imageView.center = CGPoint(x:  900.0, y: 100.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                imageView.center = originalCenter
                imageView.alpha = 1.0
            }
            
        }, completion: { (_) in
            self.tally = 0
            self.orderButton.setTitle("No Orders", for: .normal)
        })
    }
    
}
