//
//  PizzaVC.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 1/19/22.
//

import UIKit

//Conform to the protocol
class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PlaceOrderProtocol {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderButton: IRButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    private let pizzaData = PizzaData()
    private var yelpData: YelpData? = nil
    
    let networkManger = NetworkManager()
    var tally: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        fetch()
    }
    
    func fetch() {
        networkManger.fetchBusiness { result in
            switch result {
            case .success(let yelpBusiness):
                self.yelpData = yelpBusiness
                print(yelpBusiness.businesses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addOrder() {
        tally += 1
        
        DispatchQueue.main.async {
            self.totalLabel.text = "\(self.tally)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pizzaData.pizzas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pizzaCell", for: indexPath) as? ItemCVCell else { return UICollectionViewCell() }
        
//        let pizzaOptions = pizzaData.pizzas[indexPath.row]
        
//        cell.pizza = pizzaOptions
        let buzz = yelpData?.businesses[indexPath.row]
        
        cell.detail = buzz
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? DetailMenuVC,
              
                let cell = sender as? ItemCVCell,
              
                let indexPath = self.myCollectionView.indexPath(for: cell) else { return }
        
        let pizzaOptions = pizzaData.pizzas[indexPath.row]
        
        destinationVC.pizza = pizzaOptions
        
        destinationVC.pizzaDelegate = self
    }
    
    // MARK: - Animation
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
            self.totalLabel.text = "\(self.tally)"
        })
    }
    
    func orderPlaced() {
        guard tally > 0 else {
            DispatchQueue.main.async {
                self.logoImageView.shake()
            }
            return
        }
        DispatchQueue.main.async {
            self.animateAstroDude(myImageView: self.logoImageView)
        }
    }
    
    
    // MARK: - Action
    @IBAction func orderButtonTapped(_ sender: Any) {
        orderPlaced()
    }
}
