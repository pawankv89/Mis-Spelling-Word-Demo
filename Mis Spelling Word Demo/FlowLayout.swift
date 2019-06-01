//
//  FlowLayout.swift
//  Tag Flow Layout
//
//  Created by Pawan kumar on 14/05/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import Foundation
import UIKit

/*
class FlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        
        var leftMargin: CGFloat = 0.0;
        
        for attributes in attributesForElementsInRect! {
            if (attributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            leftMargin += attributes.frame.size.width + 8
            newAttributesForElementsInRect.append(attributes)
        }
        
        return newAttributesForElementsInRect
    }
}
*/

/*
class FlowLayout: UICollectionViewFlowLayout {
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // We may not change the original layout attributes
        // or UICollectionViewFlowLayout might complain.
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)
        
        layoutAttributesObjects?.forEach({ (layoutAttributes) in
            if layoutAttributes.representedElementCategory == .cell { // Do not modify header views etc.
                let indexPath = layoutAttributes.indexPath
                // Retrieve the correct frame from layoutAttributesForItem(at: indexPath):
                if let newFrame = layoutAttributesForItem(at: indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        
        return layoutAttributesObjects
    }
}
*/


class FlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }
        
        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })
        
        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Set the initial left inset
            var leftInset = sectionInset.left
            
            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }
        
        return layoutAttributes
    }
}


