//
//  UIViewExtension.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func layoutAllSubviews() {
        layoutSubviews()
        for subview in subviews {
            subview.layoutAllSubviews()
        }
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func roundCorners(corners: UIRectCorner, toRadius radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.masksToBounds = true
        clipsToBounds = true
        layer.mask = maskLayer
    }
    
    func embedInSuperView(_ superView: UIView) {
        superView.addSubview(self)
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
    func setBackgroundGradientWithColors(_ colors: [UIColor], radius: CGFloat = 12, corner: UIRectCorner = .allCorners) {
        if let gradientSublayers = layer.sublayers?.filter({ $0.name == "gradientSublayer" }) {
            for sublayer in gradientSublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map({ $0.cgColor })
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.name = "gradientSublayer"
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: gradient.bounds,
                                  byRoundingCorners: corner,
                                  cornerRadii: CGSize(width: radius, height: radius)).cgPath
        gradient.mask = shape
        layer.insertSublayer(gradient, at: 0)
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func shake(withOffset shakingOffset: CGFloat = 8) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - shakingOffset, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + shakingOffset, y: center.y))
        
        layer.add(animation, forKey: "position")
    }
    
    func addShadowWith(radius: CGFloat, opacity: Float, offSet: CGSize = .zero) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = false
    }
    
    
    func addDefaultContainerShadow() {
        addShadowWith(radius: 12, opacity: 0.3)
    }
    
}
