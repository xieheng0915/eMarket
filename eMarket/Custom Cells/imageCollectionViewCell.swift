//
//  imageCollectionViewCell.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/16.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    func setupImageWith(itemImage: UIImage) {
        imageView.image = itemImage
    }
}
