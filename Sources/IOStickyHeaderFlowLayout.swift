//
//  IOStickyHeaderFlowLayout.swift
//  Smokio
//
//  Created by ben on 25/06/2015.
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

import Foundation
#if os(iOS)
import UIKit

public let IOStickyHeaderParallaxHeader = "IOStickyHeaderParallexHeader"

open class IOStickyHeaderFlowLayout: UICollectionViewFlowLayout {
  
  open var parallaxHeaderReferenceSize: CGSize? {
    didSet{
      self.invalidateLayout()
    }
  }
  open var parallaxHeaderMinimumReferenceSize: CGSize = CGSize.zero
  open var parallaxHeaderAlwaysOnTop: Bool = false
  open var disableStickyHeaders: Bool = false

  open override func prepare() {
    super.prepare()
  }

  open override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
    var frame = attributes?.frame
    frame!.origin.y += (self.parallaxHeaderReferenceSize?.height)!
    attributes?.frame = frame!
    
    return attributes
  }
  
  open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    var attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    if attributes != nil && elementKind == IOStickyHeaderParallaxHeader {
      attributes = IOStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
    }
    
    return attributes
  }
  
  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var adjustedRec = rect
    adjustedRec.origin.y -= (self.parallaxHeaderReferenceSize?.height)!
    
    let attributes = super.layoutAttributesForElements(in: adjustedRec)
    var allItems = [UICollectionViewLayoutAttributes]()
    
    attributes?.forEach { itemAttributes in
      let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
      allItems.append(itemAttributesCopy)
    }
    
    let headers: NSMutableDictionary = NSMutableDictionary()
    let lastCells: NSMutableDictionary = NSMutableDictionary()
    var visibleParallaxHeader: Bool = false
    
    allItems.forEach { attributes in
      //    for attributes in allItems {
      var frame = attributes.frame
      frame.origin.y += (self.parallaxHeaderReferenceSize?.height)!
      attributes.frame = frame
      
      let indexPath = attributes.indexPath
        if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
        headers.setObject(attributes, forKey: (indexPath as NSIndexPath).section as NSCopying)
      } else {
        let currentAttribute = lastCells.object(forKey: (indexPath as IndexPath).section)
				if (currentAttribute == nil ||
					((currentAttribute as AnyObject).indexPath != nil && (indexPath as NSIndexPath).row > (currentAttribute as AnyObject).indexPath.row)) {
					lastCells.setObject(attributes, forKey: (indexPath as NSIndexPath).section as NSCopying)
				}
        if (indexPath as NSIndexPath).item == 0 && (indexPath as NSIndexPath).section == 0 {
          visibleParallaxHeader = true
        }
      }
      
      attributes.zIndex = 1
    }
    
    if rect.minY <= 0 {
      visibleParallaxHeader = true
    }
    
    if self.parallaxHeaderAlwaysOnTop == true {
      visibleParallaxHeader = true
    }
    
    if visibleParallaxHeader && !CGSize.zero.equalTo(self.parallaxHeaderReferenceSize!) {
      let currentAttribute = IOStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, with: IndexPath(index:0))
      var frame = currentAttribute.frame
      frame.size.width = (self.parallaxHeaderReferenceSize?.width)!
      frame.size.height = (self.parallaxHeaderReferenceSize?.height)!
      
      let bounds = self.collectionView?.bounds
      let maxY = frame.maxY
      
      var y = min(maxY - self.parallaxHeaderMinimumReferenceSize.height, (bounds?.origin.y)! + (self.collectionView?.contentInset.top)!)
      let height = max(0, -y + maxY)
      
      
      let maxHeight = self.parallaxHeaderReferenceSize!.height
      let minHeight = self.parallaxHeaderMinimumReferenceSize.height
      let progressiveness = (height - minHeight)/(maxHeight-minHeight)
      currentAttribute.progressiveness = progressiveness
      
      currentAttribute.zIndex = 0
      
      if self.parallaxHeaderAlwaysOnTop && height <= self.parallaxHeaderMinimumReferenceSize.height {
        let insertTop = self.collectionView?.contentInset.top
        y = (self.collectionView?.contentOffset.y)! + insertTop!
        currentAttribute.zIndex = 2000
      }
      
      currentAttribute.frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: height)
      allItems.append(currentAttribute)
    }
    
    if !self.disableStickyHeaders {
      lastCells.keyEnumerator().forEach { obj in
        //      for obj in lastCells.keyEnumerator() {
        if let indexPath = (obj as AnyObject).indexPath {
          let indexPAthKey = (indexPath as NSIndexPath).section
          
          var header = headers[indexPAthKey]
          if header == nil {
            header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: (indexPath as NSIndexPath).section))
            if let header:UICollectionViewLayoutAttributes = header as? UICollectionViewLayoutAttributes {
              allItems.append(header)
            }
          }
          
          self.updateHeaderAttributesForLastCellAttributes(attributes: header as! UICollectionViewLayoutAttributes, lastCellAttributes: lastCells[indexPAthKey] as! UICollectionViewLayoutAttributes)
        }
      }
    }
    
    return allItems
  }
  
  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
      var frame = attributes.frame
      frame.origin.y += (self.parallaxHeaderReferenceSize?.height)!
      attributes.frame = frame
      return attributes
    } else {
      return nil
    }
  }

  open override var collectionViewContentSize : CGSize {
    if self.collectionView?.superview == nil {
      return CGSize.zero
    }
    
    var size = super.collectionViewContentSize
    size.height += (self.parallaxHeaderReferenceSize?.height)!
    return size
  }
  
  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  // *********************************************************************
  // MARK: - Helper
  open func updateHeaderAttributesForLastCellAttributes(attributes: UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes) {
    let currentBounds = self.collectionView?.bounds
    attributes.zIndex = 1024
    attributes.isHidden = false
    
    var origin = attributes.frame.origin
    
    let sectionMaxY = lastCellAttributes.frame.maxY - attributes.frame.size.height
    var y = currentBounds!.maxY - (currentBounds?.size.height)! + (self.collectionView?.contentInset.top)!
    
    if self.parallaxHeaderAlwaysOnTop {
      y += self.parallaxHeaderMinimumReferenceSize.height
    }
    
    let maxY = min(max(y, attributes.frame.origin.y), sectionMaxY)
    
    origin.y = maxY
    
    attributes.frame = CGRect(x: origin.x, y: origin.y, width: attributes.frame.size.width, height: attributes.frame.size.width)
  }
}
#endif
