//
//  IOStickyHeaderFlowLayoutAttibutes.swift
//  Smokio
//
//  Created by ben on 25/06/2015.
//  Copyright © 2015 Smokio. All rights reserved.
//

import Foundation
import UIKit

class IOStickyHeaderFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    var progressiveness: CGFloat = 1.0
    override var zIndex: Int{
        didSet{
            self.transform3D = CATransform3DMakeTranslation(0, 0, self.zIndex == 1 ? -1 :0)
        }
    }
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! IOStickyHeaderFlowLayoutAttributes
        copy.progressiveness = self.progressiveness
        return copy
    }
}