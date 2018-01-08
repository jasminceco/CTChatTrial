//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit

public let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImageView {
    
      func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //download hit an error so lets return out
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        
                        self.image = downloadedImage
                    }
                })
                
            }).resume()
        }
       
    }
    
}

public extension UIApplication {
    class public func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}

public extension UIImage {
    
    /**
     Returns an UIImage with a specified background color.
     - parameter color: The color of the background
     */
    convenience public init(withBackground color: UIColor) {
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.setFillColor(color.cgColor);
        context.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(ciImage: CIImage(image: image)!)
        
    }
    public func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Methods
public extension UINavigationController {
    
    /// SwifterSwift: Pop ViewController with completion handler.
    ///
    /// - Parameter completion: optional completion handler (default is nil).
    public func popViewController(_ completion: (()->Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: false)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    public func pushViewController(_ viewController: UIViewController, completion: (()->Void)? = nil)  {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: tint]
    }
    
}

public extension UIColor {
    public static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
public extension UIView {
    public func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
