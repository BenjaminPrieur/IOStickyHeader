//
//  IOStickyHeaderFlowLayout.swift
//  Smokio
//
//  Created by ben on 25/06/2015.
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

import Foundation
import UIKit

public let IOStickyHeaderParallaxHeader = "IOStickyHeaderParallexHeader"

public class IOStickyHeaderFlowLayout: UICollectionViewFlowLayout {
  
  public var parallaxHeaderReferenceSize: CGSize? {
    didSet{
      self.invalidateLayout()
    }
  }
  public var parallaxHeaderMinimumReferenceSize: CGSize = CGSize.zero
  public var parallaxHeaderAlwaysOnTop: Bool = false
  public var disableStickyHeaders: Bool = false
  
  public func prepare() {
    prepare()
  }
  
  public override func initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    
    let attributes = self.initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind, atIndexPath: elementIndexPath as NSIndexPath)
    var frame = attributes?.frame
    frame!.origin.y += (self.parallaxHeaderReferenceSize?.height)!
    attributes?.frame = frame!
    
    return attributes
  }
  
  public override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    var attributes = initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind, atIndexPath: indexPath as NSIndexPath)
    if attributes != nil && elementKind == IOStickyHeaderParallaxHeader {
        
      attributes = IOStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath as NSIndexPath)
    }
    
    return attributes
  }
  
  public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var adjustedRec = rect
    adjustedRec.origin.y -= (self.parallaxHeaderReferenceSize?.height)!
    
    let attributes = layoutAttributesForElements(in: adjustedRec)
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
      if attributes.representedElementKind == UICollectionElementKindSectionHeader {
        headers.setObject(attributes, forKey: indexPath.section)
      } else {
        let currentAttribute = lastCells.objectForKey(indexPath.section)
        if currentAttribute == nil || indexPath.row > currentAttribute?.indexPath.row {
          lastCells.setObject(attributes, forKey: indexPath.section)
        }
        if indexPath.item == 0 && indexPath.section == 0 {
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
    
    if visibleParallaxHeader {
      let currentAttribute = IOStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withIndexPath: NSIndexPath(index: 0) as NSIndexPath)
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
      
      currentAttribute.frame = CGRectMake(frame.origin.x, y, frame.size.width, height)
      allItems.append(currentAttribute)
    }
    
    if !self.disableStickyHeaders {
      lastCells.keyEnumerator().forEach { obj in
        //      for obj in lastCells.keyEnumerator() {
        if let indexPath = obj.indexPath {
          let indexPAthKey = indexPath.section
          
          var header = headers[indexPAthKey]
          if header == nil {
            header = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: indexPath.section))
            if let header:UICollectionViewLayoutAttributes = header as? UICollectionViewLayoutAttributes {
              allItems.append(header)
            }
          }
          
          self.updateHeaderAttributesForLastCellAttributes(header as! UICollectionViewLayoutAttributes, lastCellAttributes: lastCells[indexPAthKey] as! UICollectionViewLayoutAttributes)
        }
      }
    }
    
    return allItems
  }
  
  public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    if let attributes = layoutAttributesForItemAtIndexPath(indexPath as NSIndexPath)?.copy() as? UICollectionViewLayoutAttributes {
      var frame = attributes.frame
      frame.origin.y += (self.parallaxHeaderReferenceSize?.height)!
      attributes.frame = frame
      return attributes
    } else {
      return nil
    }
  }
  
  public override func collectionViewContentSize() -> CGSize {
    if self.collectionView?.superview == nil {
      return CGSize.zero
        
    }
    
    var size = super.collectionViewContentSize()
    size.height += (self.parallaxHeaderReferenceSize?.height)!
    return size
  }
  
    
  public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  // *********************************************************************
  // MARK: - Helper
  public func updateHeaderAttributesForLastCellAttributes(attributes:UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes) {
    let currentBounds = self.collectionView?.bounds
    attributes.zIndex = 1024
    attributes.hidden = false
    
    var origin = attributes.frame.origin
    
    let sectionMaxY = lastCellAttributes.frame.maxY - attributes.frame.size.height
    var y = currentBounds!.maxY - (currentBounds?.size.height)! + (self.collectionView?.contentInset.top)!
    
    if self.parallaxHeaderAlwaysOnTop {
      y += self.parallaxHeaderMinimumReferenceSize.height
    }
    
    let maxY = min(max(y, attributes.frame.origin.y), sectionMaxY)
    
    origin.y = maxY
    
    attributes.frame = CGRect(origin: CGPoint(x: origin.x, y: origin.y), size: CGSize(width: attributes.frame.size.width, height: attributes.frame.size.width))
  }
}
