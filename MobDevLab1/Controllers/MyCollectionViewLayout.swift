//
//  MyCollectionViewLayout.swift
//  MobDevLab1
//
//  Created by Dima on 15.03.2021.
//

import UIKit

protocol MyCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}


class MyCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: MyCollectionViewLayoutDelegate?

    
    private let cellPadding: CGFloat = 1
    
    private var cache: [UICollectionViewLayoutAttributes] = []

    
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        
        cache = []
    }
    
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
      // 1
      guard cache.isEmpty, let collectionView = collectionView
        else {
          return
      }
      // 2
        
        let xOffset: [CGFloat] = [1, contentWidth/5*3, 1, contentWidth/5*1,contentWidth/5*2]

        var yOffset:CGFloat = 0
        
      // 3
      for item in 0..<collectionView.numberOfItems(inSection: 0) {
        let indexPath = IndexPath(item: item, section: 0)
        
        
            
        var frame:CGRect?
        // 4
        let photoHeight = delegate?.collectionView(collectionView,heightForPhotoAtIndexPath: indexPath) ?? 180
        let height = cellPadding * 2 + photoHeight - 2
            
        if ((indexPath[1] + 1) % 6 == 1) {
            frame = CGRect(x: xOffset[0], y: yOffset, width: height, height: height)
        } else if((indexPath[1] + 1) % 6 == 2 || (indexPath[1] + 1) % 6 == 3) {
            frame = CGRect(x: xOffset[1], y: yOffset, width: height, height: height)
            yOffset += (indexPath[1] + 1) % 6 == 2 ? height : height/2
        } else {
            frame = CGRect(x: xOffset[indexPath[1] % 6 - 1], y: yOffset, width: height, height: height)
            yOffset += (indexPath[1] + 1) % 6 == 0 ? height : 0
        }
        let insetFrame = frame!.insetBy(dx: cellPadding, dy: cellPadding)
          
        // 5
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        // 6
        contentHeight = max(contentHeight, frame!.maxY)
        
        
        
        }
    
    }
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
      // Loop through the cache and look for items in the rect
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
