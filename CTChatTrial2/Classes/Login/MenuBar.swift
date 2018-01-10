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
        cv.backgroundColor = Configuration.ChatViewsBackgroundColoar
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["Conversations", "Contacts"]
    let iconNames = ["trending", "switch_account"]
    
    var homeController: MessagesController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format:"V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
       
        
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5)) {
            self.addBottomBorderWithHeight(height: 1, color: .lightGray, leftOffset: 0, rightOffset: 0, bottomOffset: 1)
            self.setupHorizontalBar()
        }
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
      
        horizontalBarView.backgroundColor = UIColor.clear
      
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
       
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        let horizontalBarView1 = UIView()
        horizontalBarView1.backgroundColor = UIColor.rgb(28, green: 156, blue: 160)
        horizontalBarView.addSubview(horizontalBarView1)
        
        
        horizontalBarView.addConstraintsWithFormat(format:"H:|-36-[v0(\(horizontalBarView.frame.width / 2 - 72))]-36-|", views: horizontalBarView1)
        horizontalBarView.addConstraintsWithFormat(format:"V:|[v0(4)]|", views: horizontalBarView1)
        
        
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
        cell.imageView.image = UIImage(named: iconNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.name.text = imageNames[indexPath.item]
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
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor.rgb(91, green: 14, blue: 13)
        return iv
    }()
    
    let name: UILabel = {
        let iv = UILabel()
        iv.text = "Test Jasmin"
        iv.textAlignment = .center
        iv.tintColor = .darkGray
        iv.textColor = .darkGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override public var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ?  selectedColor : deSelectedColor
            name.tintColor = isHighlighted ? selectedColor : deSelectedColor
            name.textColor = isHighlighted ? selectedColor : deSelectedColor
            
            name.font = isHighlighted ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? selectedColor : deSelectedColor
            name.tintColor = isSelected ? selectedColor : deSelectedColor
            name.textColor = isSelected ? selectedColor : deSelectedColor
            name.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        }
    }
    
    override func setupViews() {
        super.setupViews()

        
        let titleView = UIView()
        
        titleView.backgroundColor = .clear
        
        addSubview(titleView)
        
        addConstraintsWithFormat(format:"H:[v0(\(self.frame.width))]", views: titleView)
        addConstraintsWithFormat(format:"V:[v0(\(self.frame.height))]", views: titleView)
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        let containerView = UIView()
        
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(containerView)
        
        titleView.addConstraintsWithFormat(format:"H:|-(>=2)-[v0]-(>=2)-|", views: containerView)
        titleView.addConstraintsWithFormat(format:"V:|[v0]|", views: containerView)

        containerView.addSubview(imageView)

        //ios 9 constraint anchors
        //need x,y,width,height anchors
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        containerView.addSubview(name)

        name.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        name.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 2).isActive = true
        name.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        name.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        name.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
    
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

       
    }
    
}








