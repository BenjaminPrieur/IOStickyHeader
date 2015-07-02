//
//  IOParallaxHeader.swift
//  IOStickyHeader
//
//  Created by ben on 29/06/2015.
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

import UIKit
import IOStickyHeader

class IOGrowHeader: UICollectionViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnBot: UIButton!
    @IBOutlet weak var constraintImgSize: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width * 0.5
        self.btnBot.layer.cornerRadius = 5
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let layoutAttributes:IOStickyHeaderFlowLayoutAttributes = layoutAttributes as? IOStickyHeaderFlowLayoutAttributes else { return }
        
        if layoutAttributes.progressiveness < 1 {
            self.constraintImgSize.constant = 130
            self.imgPhoto.updateConstraintsIfNeeded()
        } else {
            self.constraintImgSize.constant = 130 * layoutAttributes.progressiveness
            self.imgPhoto.updateConstraintsIfNeeded()
        }
    }

}
