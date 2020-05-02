//
//  itemViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/16.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import JGProgressHUD

class itemViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceValLabel: UILabel!
    @IBOutlet weak var descriptionContentsLabel: UITextView!
    
    // MARK: - Vars
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let itemsPerRow: CGFloat = 1
    private let cellHeight: CGFloat = 196.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        downloadPictures()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToBasketPressed))]
    }
    
    // MARK: - downloadPictures
    private func downloadPictures() {
        if item != nil && item.imangLinks != nil {
            downloadImages(imageUrls: item.imangLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - setupUI
    private func setupUI() {
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceValLabel.text = covertToCurrency(item.price)
            descriptionContentsLabel.text = item.description
        }
    }
    
    // MARK: - IBAction
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToBasketPressed() {
        
        //TODO: check if user has logged in
        if MUser.currentId() != nil {
            
            downloadBasketFromFirestore(MUser.currentId()) { (basket) in
                
                if basket == nil {
                    self.createNewBasket()
                } else {
                    basket!.itemIds.append(self.item.id)
                    self.updateBasket(basket: basket!, withValues: [kITEMIDS: basket!.itemIds])
                }
            }
            
        } else {
            showLoginView()
        }
    }
    
    // MARK: - Add to Basket
    private func createNewBasket() {
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = MUser.currentId()
        newBasket.itemIds = [self.item.id]
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Added to basket!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
        
        
    }
    
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
            if error != nil {
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = "Added to basket!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    //MARK: - Show login view
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        
        self.present(loginView, animated: true, completion: nil)
    }

}

extension itemViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1: itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        
        return cell
    }
    
    
}

extension itemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left
       
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

