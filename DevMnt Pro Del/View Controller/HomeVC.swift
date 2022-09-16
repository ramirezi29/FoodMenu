//
//  PizzaVC.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 1/19/22.
//

import UIKit




//Conform to the protocol
class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PlaceOrderProtocol {
    
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var OrderNowView: UIView!
    @IBOutlet weak var orderButton: IRButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    
    private var yelpData: YelpData? = nil {
        didSet {
            DispatchQueue.main.async {
                self.suggestionCollectionView.reloadData()
            }
        }
    }
    
    let networkManger = NetworkManager()
    var tally: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        fetch()
        styleBackgroundElements()
    }
    
    func styleBackgroundElements() {
        view.addVerticalGradientLayer()
        categoryCollectionView.backgroundColor = .clear
        suggestionCollectionView.backgroundColor = .clear
        OrderNowView.addVerticalGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func OrderButtonStyle() {
        orderButton.setTitle("Order Now \(tally)", for: .normal)
    }
    
    func fetch() {
        networkManger.fetchBusiness(type: "random") { result in
            switch result {
            case .success(let yelpBusiness):
                self.yelpData = yelpBusiness
                print("[MainVC] - fetch:\(yelpBusiness.businesses)")
                for i in yelpBusiness.businesses {
                    print("item: \(i)")
                }
            case .failure(let error):
                print(error)
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
    
    func addOrder() {
        tally += 1
        
        DispatchQueue.main.async {
            self.orderButton.setTitle("Order Now \(self.tally)", for: .normal)
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
        
        guard let suggestionCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "pizzaCell", for: indexPath) as? SuggestedCVCell else { return UICollectionViewCell() }
        
        let business = yelpData?.businesses[indexPath.row]
        
        suggestionCell.updateViews(business: business)
        
        suggestionCell.pizzaImage.load(yelp: business?.imageURL ?? "")
        
        return suggestionCell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? DetailMenuVC,
                  
                    let cell = sender as? SuggestedCVCell,
                  
                    let indexPath = self.suggestionCollectionView.indexPath(for: cell) else { return }
            
            guard let businessDetails = yelpData?.businesses[indexPath.row] else { return }
            
            destinationVC.business = businessDetails
            
            destinationVC.orderDelegate = self
        }
        
        
        if segue.identifier == "toCategoryVC" {
            guard let destinationVC = segue.destination as? CategoryTVC else { return }
            
            guard  let cell = sender as? CategoryCVCell else { return }
            
            guard  let indexPath = self.categoryCollectionView.indexPath(for: cell) else { return }
            
            let selectedCategory = CategoryOptions.categories[indexPath.row]
            
            destinationVC.selectedCategory = selectedCategory
        }
        
    }
    
    // MARK: - Animation
    
    func orderPlaced() {
        guard tally > 0 else {
            DispatchQueue.main.async {
                self.driverImage.shake()
            }
            return
        }
        DispatchQueue.main.async {
            self.animateAstroDude(myImageView: self.driverImage)
        }
    }
    
    // MARK: - Action
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        orderPlaced()
    }
}

extension HomeVC {
    
    func animateAstroDude(myImageView: UIImageView) {
        let originalCenter = myImageView.center
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                myImageView.center.x -= 80.0
                myImageView.center.y += 10.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                myImageView.transform = CGAffineTransform(rotationAngle: -.pi / 80)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                myImageView.center.x -= 100.0
                myImageView.center.y += 50.0
                myImageView.alpha = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
                myImageView.transform = .identity
                myImageView.center = CGPoint(x:  900.0, y: 100.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                myImageView.center = originalCenter
                myImageView.alpha = 1.0
            }
            
        }, completion: { (_) in
            self.tally = 0
            self.orderButton.setTitle("Order Now", for: .normal)
        })
    }
    
}
