//
//  IOParallaxVC.swift
//  IOStickyHeader
//
//  Created by ben on 29/06/2015.
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

import UIKit
import IOStickyHeader

class IOGrowVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let headerNib = UINib(nibName: "IOGrowHeader", bundle: Bundle.main)
    var section: Array<Array<String>> = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.section = [
            [
                "Song 1",
                "Song 2",
                "Song 3",
                "Song 4",
                "Song 5",
                "Song 6",
                "Song 7",
                "Song 8",
                "Song 9",
                "Song 10",
                "Song 11",
                "Song 12",
                "Song 13",
                "Song 14",
                "Song 15",
                "Song 16",
                "Song 17",
                "Song 18",
                "Song 19",
                "Song 20",
            ]
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
            layout.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 274)
            layout.parallaxHeaderMinimumReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 180)
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
        return self.section[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IOCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IOCell
        
        let obj = self.section[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        cell.lblTitle.text = obj
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 50);
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case IOStickyHeaderParallaxHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! IOGrowHeader
            return cell
        default:
            assert(false, "Unexpected element kind")
        }
    }

}
