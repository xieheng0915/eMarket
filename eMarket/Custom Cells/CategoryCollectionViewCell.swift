//
//  CategoryCollectionViewCell.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/04.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category: Category) {
        nameLabel.text = category.name
        imageView.image = category.image
    }
}
