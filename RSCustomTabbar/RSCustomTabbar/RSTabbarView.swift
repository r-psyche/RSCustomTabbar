//
//  RSTabbarView.swift
//  RSCustomTabbar
//
//  Created by jangmi on 2019/11/28.
//  Copyright © 2019 jangmi. All rights reserved.
//

import Foundation
import UIKit

class TabbarView:UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView:UICollectionView?
    let reuseIdentifier = "tabViewCell"
    var items:[Any] = []
    var customTabbar:TabbarView?
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    var tabWidth:CGFloat = 0.0
    
    var delegate: TabbarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let viewLayout = UICollectionViewLayout.init()
        
        self.collectionView = UICollectionView.init(frame: frame, collectionViewLayout: viewLayout)
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
        self.collectionView?.backgroundColor = UIColor.lightGray
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.register(TabbarViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.collectionView!)
        self.addSubview(self.indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIndicatorView() {
        self.tabWidth = self.frame.width/CGFloat(self.items.count)
        
        self.indicatorView.widthAnchor.constraint(equalToConstant: self.tabWidth).isActive = true
        self.indicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TabbarViewCell
        
        let coordinateX:CGFloat = CGFloat(indexPath.item) * self.tabWidth
        cell.frame = CGRect(x: coordinateX, y: 0, width: self.tabWidth, height: 60)
        cell.backgroundColor = UIColor.white
        cell.label.text = self.items[indexPath.item] as? String
        cell.label.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToPage(scrollTo: indexPath)
        delegate?.changeView(index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabbarViewCell else {return}
        cell.label.textColor = UIColor.lightGray
    }
    
    func moveToPage(scrollTo index:IndexPath) {
        self.collectionView?.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
        guard let cell = self.collectionView?.cellForItem(at: index) as? TabbarViewCell else {return}
        cell.label.textColor = .black
        indicatorViewLeadingConstraint.constant = (self.tabWidth) * CGFloat((index.row))
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

protocol TabbarViewDelegate {
    func changeView(index:IndexPath)
}

class TabbarViewCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = UIColor.lightGray
        }
    }
    
    override func layoutSubviews() {
        self.addSubview(label)
    }
}
