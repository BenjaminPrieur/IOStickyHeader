//
//  IOStickyHeaderFlowLayoutAttributes.swift
//  Smokio
//
//  Created by ben on 25/06/2015.
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

import Foundation
#if os(iOS)
import UIKit

open class IOStickyHeaderFlowLayoutAttributes: UICollectionViewLayoutAttributes {
  open var progressiveness: CGFloat = 1.0
  open override var zIndex: Int{
    didSet{
      self.transform3D = CATransform3DMakeTranslation(0, 0, self.zIndex == 1 ? -1 :0)
    }
  }

  open override func copy(with zone: NSZone? = nil) -> Any {
    let copy = super.copy(with: zone) as! IOStickyHeaderFlowLayoutAttributes
    copy.progressiveness = self.progressiveness
    return copy
  }
}
#endif
