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

extension UIViewController {
    func presentAlert(with message : String) {
        let alertController = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
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
            #colorLiteral(red: 0.8509803922, green: 0.6549019608, blue: 0.7803921569, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1).cgColor
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
            #colorLiteral(red: 0.9333333333, green: 0.6117647059, blue: 0.6549019608, alpha: 1).cgColor,
            #colorLiteral(red: 1, green: 0.8666666667, blue: 0.8823529412, alpha: 1).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
