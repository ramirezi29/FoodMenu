//
//  Extensions.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 4/1/22.
//

import UIKit

extension UIImageView {
    func load(yelp imageUrl: String) {
        DispatchQueue.global().async { [weak self] in
            guard let urlString = URL(string: imageUrl) else { return }
            if let data = try? Data(contentsOf: urlString) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIView {
    
    func shake() {

        let translateRight = CGAffineTransform(translationX: 4.0, y: 0)
        let translateLeft = CGAffineTransform(translationX: -4.0, y: 0)

        self.transform = translateRight

        UIView.animate(withDuration: 0.07, delay: 0.01, options: [.autoreverse, .repeat]) {

            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                self.transform = translateLeft
            }
        } completion: { _ in
            self.transform = CGAffineTransform.identity
        }
    }
    
    /**
     An extension on UIView that renders a gradient on a UITableView
     */
    func setGradientToTableView(tableView: UITableView) {
        
        let gradientBackgroundColors = [
            #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1).cgColor,
            #colorLiteral(red: 0.9806931615, green: 0.9421476722, blue: 0.9527044892, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        ]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = tableView.bounds
        
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    /**
     An extension on UIView that renders a gradient on a UIViewControllerØ
     */
    func addVerticalGradientLayer() {
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1).cgColor,
            #colorLiteral(red: 0.9806931615, green: 0.9421476722, blue: 0.9527044892, alpha: 1).cgColor,
            #colorLiteral(red: 0.9721249938, green: 0.8483908772, blue: 0.847076714, alpha: 1).cgColor

        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
