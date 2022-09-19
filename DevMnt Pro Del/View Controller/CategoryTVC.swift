//
//  CategoryTVC.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/13/22.
//

import UIKit

class CategoryTVC: UITableViewController {
    
    var selectedCategory: Category?
    private var yelpData: YelpData? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
    
    func fetch(){
        NetworkManager.shared.fetchBusiness(type: selectedCategory?.title ?? "food") { [self] results in
            switch results {
            case .failure(let error):
                self.presentAlert(with: error.errorDescription  ?? "Try Again")
            case .success(let data):
                yelpData = data
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yelpData?.businesses.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath)
        
        guard let business = yelpData?.businesses[indexPath.row] else { return UITableViewCell() }
        
        var content = cell.defaultContentConfiguration()
        
        content.text = business.name
        content.textProperties.color = .label
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        content.textToSecondaryTextVerticalPadding = 4
        
        content.secondaryText = "\(business.rating)"
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        content.image = UIImage(named: selectedCategory?.imageName ?? "")
        content.imageProperties.maximumSize =  CGSize(width: 50, height: 50)
        content.imageToTextPadding = 16
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailMenuVC = segue.destination as? DetailMenuVC,
              let indexPath = self.tableView.indexPathForSelectedRow else { return }
        
        let business = yelpData?.businesses[indexPath.row]
        detailMenuVC.business = business
    }
    
}
