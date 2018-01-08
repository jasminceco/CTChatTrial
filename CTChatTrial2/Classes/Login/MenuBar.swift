//
//  MenuBar.swift
//  CTChatTrial2
//
//  Created by jasminceco on 01/04/2018.
//  Copyright (c) 2018 jasminceco. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .lightText
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["Conversation", "Contacts"]
    
    var homeController: MessagesController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format:"V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
      
        horizontalBarView.backgroundColor = UIColor.rgb(28, green: 156, blue: 160)
      
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
       
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let x = CGFloat(indexPath.item) * frame.width / 2
        horizontalBarLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
        homeController?.selectedTab(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
//        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.name.text = imageNames[indexPath.item]
        cell.tintColor = UIColor.rgb(91, green: 14, blue: 13)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
public class BaseCell: UICollectionViewCell {
    override public  init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class MenuCell: BaseCell {
    let selectedColor : UIColor = .darkGray
    let deSelectedColor: UIColor = .lightGray
    
    let imageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(91, green: 14, blue: 13)
        return iv
    }()
    
    let name: UILabel = {
        let iv = UILabel()
        iv.text = ""
        iv.textAlignment = .center
        iv.font.withSize(UIFont.smallSystemFontSize)
        iv.sizeToFit()
        iv.adjustsFontSizeToFitWidth = true
        iv.tintColor = .darkGray
        iv.textColor = .darkGray
        return iv
    }()
    
    override public var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13)
            name.tintColor = isHighlighted ? selectedColor : deSelectedColor
            name.textColor = isSelected ? selectedColor : deSelectedColor
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(91, green: 14, blue: 13)
            name.tintColor = isSelected ? selectedColor : deSelectedColor
            name.textColor = isSelected ? selectedColor : deSelectedColor
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintsWithFormat(format:"H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format:"V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(name)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: name)
        addConstraintsWithFormat(format: "V:|-16-[v0(20)]", views: name)
    }
    
}








