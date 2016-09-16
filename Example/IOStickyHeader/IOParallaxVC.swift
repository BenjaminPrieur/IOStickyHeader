//
//  IOParallaxVC.swift
//  IOStickyHeader
//
//  Created by ben on 02/07/2015.
//  Copyright © 2015 Benjamin Prieur. All rights reserved.
//

import UIKit
import IOStickyHeader

class IOParallaxVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var collectionView: UICollectionView!
    let headerNib = UINib(nibName: "IOParallaxHeader", bundle: Bundle.main)
    var section: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.section = [
            "City 1",
            "City 2",
            "City 3",
            "City 4",
            "City 5",
            "City 6",
            "City 7",
            "City 8",
            "City 9",
            "City 10",
            "City 11",
            "City 12",
            "City 13",
            "City 14",
            "City 15",
            "City 16",
            "City 17",
            "City 18",
            "City 19",
            "City 20",
        ]
        
        self.setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let layout: IOStickyHeaderFlowLayout = self.collectionView.collectionViewLayout as? IOStickyHeaderFlowLayout {
            layout.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 300)
            layout.parallaxHeaderMinimumReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 0)
            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: layout.itemSize.height)
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = true
            self.collectionView.collectionViewLayout = layout
        }
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.collectionView.register(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "header")
    }

    //MARK: UICollectionViewDataSource & UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IOCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IOCell
        
        let obj = self.section[(indexPath as NSIndexPath).section]
        
        cell.lblTitle.text = obj
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 50);
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! IOSectionHeader
            return cell
        case IOStickyHeaderParallaxHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! IOParallaxHeader
            return cell
        default:
            assert(false, "Unexpected element kind")
        }
    }

}
