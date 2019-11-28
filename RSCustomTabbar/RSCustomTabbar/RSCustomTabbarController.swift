//
//  RSCustomTabbar.swift
//  RSCustomTabbar
//
//  Created by jangmi on 2019/11/27.
//  Copyright © 2019 jangmi. All rights reserved.
//

import Foundation
import UIKit

class RSCustomTabbarController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, TabbarViewDelegate {
    
    var collectionView:UICollectionView?
    let reuseIdentifier = "collectionCell"
    var customTabbar:TabbarView?
    var viewItems:[Any] = []
    var tabItems:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let viewLayout = UICollectionViewLayout()
        
//        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.customTabbar = TabbarView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        self.customTabbar!.delegate = self;
        self.customTabbar!.items = self.tabItems
        self.customTabbar!.setIndicatorView()
        self.customTabbar!.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height),
                                                     collectionViewLayout: viewLayout)
        self.collectionView?.setCollectionViewLayout(flowLayout, animated: true)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.register(CollectionVeiwCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
        self.collectionView?.isPagingEnabled = true
        

        self.view.addSubview(self.customTabbar!)
        self.customTabbar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.customTabbar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.customTabbar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.customTabbar!.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(self.collectionView!)
        self.collectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView!.topAnchor.constraint(equalTo: self.customTabbar!.bottomAnchor).isActive = true
        self.collectionView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionVeiwCell
        
        let viewWidth:CGFloat = self.view.frame.width
        let coordinateX:CGFloat = CGFloat(indexPath.item) * viewWidth
        let view:UIView = (self.viewItems[indexPath.item] as! UIViewController).view
        cell.frame = CGRect(x: coordinateX, y: 0, width: viewWidth, height: self.view.frame.height)
        cell.addSubview(view)
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        self.customTabbar?.moveToPage(scrollTo: indexPath)
    }
    
    func changeView(index: IndexPath) {
        self.collectionView?.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}

extension RSCustomTabbarController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width, height: frameSize.height)
    }
}

class CollectionVeiwCell:UICollectionViewCell {
    override func layoutSubviews() {
    }
}

