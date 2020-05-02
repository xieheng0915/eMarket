//
//  CategoryCollectionViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/04.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController {

    // MARK: Vars
    var categoryArray: [Category] = []
    private let sectionInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3
    
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }




    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.generateCell(categoryArray[indexPath.row])
    
        // Configure the cell
    
        return cell
    }
    
    // MARK: UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItemsSeg", sender: categoryArray[indexPath.row])
    }
    
    
    // MARK: Download categories
    private func loadCategories() {
        downloadCategoriesFromFirebase { (allCategories) in
            
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Navigation
    internal override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == "categoryToItemsSeg"  {
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
        }
    }
    

}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: withPerItem, height: withPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
