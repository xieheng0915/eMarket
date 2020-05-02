//
//  itemTableViewCell.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/14.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit

class itemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func generateCell(_ item: Item) {
        nameLabel.text = item.name
        priceLabel.text = covertToCurrency(item.price)
        descriptionLabel.text = item.description
        
        if item.imangLinks != nil && item.imangLinks.count > 0 {
            downloadImages(imageUrls: [item.imangLinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage
            }
        }
        
        
    }
}
