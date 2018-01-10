//
//  ViewController.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit

public let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIView{
    public func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}
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

public extension UIView{
    //////////
    // Top
    //////////
  public  func createTopBorderWithHeight(height: CGFloat, color: UIColor) -> CALayer {
        
        return getOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height), color:color)
    }
    
  public  func createViewBackedTopBorderWithHeight(height: CGFloat, color:UIColor) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height), color:color)
    }
    
  public  func addTopBorderWithHeight(height: CGFloat, color:UIColor) {
        addOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height), color:color)
    }
    
public    func addViewBackedTopBorderWithHeight(height: CGFloat, color:UIColor) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height), color:color)
    }
 public   func addTopBorderWithHeightGradient(height: CGFloat, color:[CGColor]) {
        return createGradientLayer(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height), currentColorSet: color)
    }
    
    
    //////////
    // Top + Offset
    //////////
    
 public   func createTopBorderWithHeight(height:CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, topOffset:CGFloat) -> CALayer {
        // Subtract the bottomOffset from the height and the thickness to get our final y position.
        // Add a left offset to our x to get our x position.
        // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
    return getOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
 public   func createViewBackedTopBorderWithHeight(height:CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, topOffset:CGFloat) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
  public  func addTopBorderWithHeight(height:CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, topOffset:CGFloat) {
        // Add leftOffset to our X to get start X position.
        // Add topOffset to Y to get start Y position
        // Subtract left offset from width to negate shifting from leftOffset.
        // Subtract rightoffset from width to set end X and Width.
        addOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
   public func addViewBackedTopBorderWithHeight(height:CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, topOffset:CGFloat) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
    
    //////////
    // Right
    //////////
    
 public   func createRightBorderWithWidth(width:CGFloat, color:UIColor) -> CALayer {
        return getOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
   public func createViewBackedRightBorderWithWidth(width:CGFloat, color:UIColor) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
  public  func addRightBorderWithWidth(width:CGFloat, color:UIColor){
        addOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
public    func addViewBackedRightBorderWithWidth(width:CGFloat, color:UIColor) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
    
    //////////
    // Right + Offset
    //////////
    
 public   func createRightBorderWithWidth(width: CGFloat, color:UIColor, rightOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) -> CALayer {
        // Subtract bottomOffset from the height to get our end.
        return getOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width-rightOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
 public   func createViewBackedRightBorderWithWidth(width: CGFloat, color:UIColor, rightOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width-rightOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
  public  func addRightBorderWithWidth(width: CGFloat, color:UIColor, rightOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) {
        // Subtract the rightOffset from our width + thickness to get our final x position.
        // Add topOffset to our y to get our start y position.
        // Subtract topOffset from our height, so our border doesn't extend past teh view.
        // Subtract bottomOffset from the height to get our end.
        addOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width-rightOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
   public func addViewBackedRightBorderWithWidth(width: CGFloat, color:UIColor, rightOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: self.frame.size.width-width-rightOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
    
    //////////
    // Bottom
    //////////
    
  public  func createBottomBorderWithHeight(height: CGFloat, color:UIColor) -> CALayer {
        return getOneSidedBorderWithFrame(frame: CGRect(x: 0, y: self.frame.size.height-height, width: self.frame.size.width, height: height), color:color)
    }
    
  public  func createViewBackedBottomBorderWithHeight(height: CGFloat, color:UIColor) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0, y: self.frame.size.height-height, width: self.frame.size.width, height: height), color:color)
    }
    
 public   func addBottomBorderWithHeight(height: CGFloat, color:UIColor) {
        return addOneSidedBorderWithFrame(frame: CGRect(x: 0, y: self.frame.size.height-height, width: self.frame.size.width, height: height), color:color)
    }
 public   func addBottomBorderWithHeightGradient(height: CGFloat, color:[CGColor]) {
        return createGradientLayer(frame: CGRect(x: 0, y: self.frame.size.height-height, width: self.frame.size.width, height: height), currentColorSet: color)
    }
    
public    func addViewBackedBottomBorderWithHeight(height: CGFloat, color:UIColor) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0, y: self.frame.size.height-height, width: self.frame.size.width, height: height), color:color)
    }
    
    
    //////////
    // Bottom + Offset
    //////////
    
  public  func createBottomBorderWithHeight(height: CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, bottomOffset:CGFloat) -> CALayer {
        // Subtract the bottomOffset from the height and the thickness to get our final y position.
        // Add a left offset to our x to get our x position.
        // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
        return getOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: self.frame.size.height-height-bottomOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
public    func createViewBackedBottomBorderWithHeight(height: CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, bottomOffset:CGFloat) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: self.frame.size.height-height-bottomOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
 public   func addBottomBorderWithHeight(height: CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, bottomOffset:CGFloat) {
        // Subtract the bottomOffset from the height and the thickness to get our final y position.
        // Add a left offset to our x to get our x position.
        // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
        addOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: self.frame.size.height-height-bottomOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
  public  func addViewBackedBottomBorderWithHeight(height: CGFloat, color:UIColor, leftOffset:CGFloat, rightOffset:CGFloat, bottomOffset:CGFloat) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: self.frame.size.height-height-bottomOffset, width: self.frame.size.width - leftOffset - rightOffset, height: height), color:color)
    }
    
    
    
    //////////
    // Left
    //////////
    
  public  func createLeftBorderWithWidth(width: CGFloat, color:UIColor) -> CALayer {
        return getOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
  public  func createViewBackedLeftBorderWithWidth(width: CGFloat, color:UIColor) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
 public   func addLeftBorderWithWidth(width: CGFloat, color:UIColor) {
        addOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
  public  func addViewBackedLeftBorderWithWidth(width: CGFloat, color:UIColor) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height), color:color)
    }
    
    
    
    //////////
    // Left + Offset
    //////////
    
  public  func createLeftBorderWithWidth(width:CGFloat, color:UIColor, leftOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) -> CALayer {
        return getOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
  public  func createViewBackedLeftBorderWithWidth(width:CGFloat, color:UIColor, leftOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) -> UIView {
        return getViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
    
 public   func addLeftBorderWithWidth(width:CGFloat, color:UIColor, leftOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) {
        addOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
 public   func addViewBackedLeftBorderWithWidth(width:CGFloat, color:UIColor, leftOffset:CGFloat, topOffset:CGFloat, bottomOffset:CGFloat) {
        addViewBackedOneSidedBorderWithFrame(frame: CGRect(x: 0 + leftOffset, y: 0 + topOffset, width: width, height: self.frame.size.height - topOffset - bottomOffset), color:color)
    }
    
    
    
    //////////
    // Private: Our methods call these to add their borders.
    //////////
    
    private func addOneSidedBorderWithFrame(frame: CGRect, color:UIColor) {
        let border = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
 public   func createGradientLayer(frame: CGRect,currentColorSet: [CGColor],locations: [NSNumber] = [0.0, 1] , startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        gradientLayer.colors = currentColorSet
        gradientLayer.locations = locations
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        self.layer.addSublayer(gradientLayer)
    }
 
    private func getOneSidedBorderWithFrame(frame: CGRect, color:UIColor) -> CALayer {
        let border = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    private func addViewBackedOneSidedBorderWithFrame(frame: CGRect, color: UIColor) {
        let border = UIView(frame: frame)
        border.backgroundColor = color
        self.addSubview(border)
    }
    
    private func getViewBackedOneSidedBorderWithFrame(frame: CGRect, color: UIColor) -> UIView {
        let border = UIView(frame: frame)
        border.backgroundColor = color
        return border
    }
}

