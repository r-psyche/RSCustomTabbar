//
//  ViewController.swift
//  RSCustomTabbar
//
//  Created by jangmi on 2019/11/27.
//  Copyright © 2019 jangmi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, TabbarViewDelegate {
    
    var collectionView:UICollectionView?
    var collectionViewLayout:UICollectionViewLayout?
    let reuseIdentifier = "cell"
//    var items = ["1", "2", "3", "4", "5"]
    var colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue]
    var customTabbar:TabbarView?
    
    var view1:UIViewController = {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.red
        return vc
    }()
    var view2:UIViewController = {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.orange
        return vc
    }()
    var view3:UIViewController = {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.yellow
        return vc
    }()
    var view4:UIViewController = {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.green
        return vc
    }()
    var view5:UIViewController = {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.blue
        return vc
    }()
    var items:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        items = [view1,view2,view3,view4,view5]
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.collectionViewLayout = UICollectionViewLayout.init()
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height),
                                                    collectionViewLayout: self.collectionViewLayout!)
        self.collectionView?.backgroundColor = UIColor.yellow
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
        self.collectionView?.register(CollectionVeiwCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView?.isPagingEnabled = true
        
        self.customTabbar = TabbarView.init(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50))
        self.customTabbar?.delegate = self
        
        self.view.addSubview(self.customTabbar!)
        self.customTabbar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.customTabbar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.customTabbar!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true // ---- *
        self.customTabbar!.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.view.addSubview(self.collectionView!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionVeiwCell
        
        let width:CGFloat = self.view.frame.width
        let coordinateX:CGFloat = CGFloat(indexPath.item) * width
        let view:UIView = (self.items[indexPath.item] as! UIViewController).view
        cell.frame = CGRect(x: coordinateX, y: 10, width: self.view.frame.width, height: self.view.frame.height)
//        cell.contentView.addSubview(view)
        cell.addSubview(view)
//        cell.backgroundColor = self.colors[indexPath.item]
//        cell.label.text = self.items[indexPath.item]
//        cell.label.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        self.customTabbar?.moveToPage(scrollTo: itemAt)
    }
    
    func changeView(index: IndexPath) {
        self.collectionView?.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width, height: frameSize.height)
    }
}

//MARK: tabbar view
class TabbarView:UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView:UICollectionView?
    var collectionViewLayout:UICollectionViewLayout?
    let reuseIdentifier = "TabbarCell"
    var items = ["Tab1", "Tab2", "Tab3", "Tab4", "Tab5"]
    var colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue]
    var customTabbar:TabbarView?
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    var delegate: TabbarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.collectionViewLayout = UICollectionViewLayout.init()
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50),
                                                    collectionViewLayout: self.collectionViewLayout!)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
        self.collectionView?.register(TabbarViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.isPagingEnabled = true
        
        self.addSubview(self.collectionView!)
        self.addSubview(self.indicatorView)
        
        self.indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width/5).isActive = true // ---- *
        self.indicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TabbarViewCell
        
        let width:CGFloat = self.frame.width/5
        let coordinateX:CGFloat = CGFloat(indexPath.item) * width
        cell.frame = CGRect(x: coordinateX, y: 0, width: self.frame.width/5, height: 50)
        cell.backgroundColor = UIColor.purple
        cell.label.text = self.items[indexPath.item]
        cell.label.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabbarViewCell else {return}
        cell.label.textColor = .black
        indicatorViewLeadingConstraint.constant = (self.frame.width / 5) * CGFloat((indexPath.row))
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        delegate?.changeView(index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabbarViewCell else {return}
        cell.label.textColor = UIColor.white
    }
    
    func moveToPage(scrollTo index:Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        guard let cell = self.collectionView?.cellForItem(at: indexPath) as? TabbarViewCell else {return}
        cell.label.textColor = .black
        indicatorViewLeadingConstraint.constant = (self.frame.width / 5) * CGFloat((indexPath.row))
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

protocol TabbarViewDelegate {
    func changeView(index:IndexPath)
}


class CollectionVeiwCell:UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        self.addSubview(label)
    }
}

class TabbarViewCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = UIColor.white
        }
    }
    
    override func layoutSubviews() {
        self.addSubview(label)
    }
}

