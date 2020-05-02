//
//  BasketViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/26.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import JGProgressHUD
import Stripe

class BasketViewController: UIViewController {

    
    //Mark: IBOutlets
    
    
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    //MARK: - Vars
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds : [String] = []
    
    
    let hud = JGProgressHUD(style: .dark)
    var totalPrice = 0
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView  
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: check if user logged in
        if MUser.currentUser() != nil {
            loadBasketFromFirestore()
        } else {
            self.updateTotalLabels(true)
        }
        
        
    }
    

    @IBAction func checkoutButtonPressed(_ sender: Any) {
        if MUser.currentUser()!.onboard {
            // process with purchase
            //print("checked out")
            //tempFunction()
            //emptyTheBasket()
            //addItemsToPurchaseHistory(self.purchasedItemIds)
            
            showPaymentOptions()
            
        } else {
            self.hud.textLabel.text = "Please complete your profile!"
            //self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            //self.hud.show(in: self.view)
            //self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    // Download basket
    private func loadBasketFromFirestore() {
        downloadBasketFromFirestore(MUser.currentId()) { (basket) in
            self.basket = basket
            //print("here is the ownerid: \(self.basket?.ownerId)")
            self.getBasketItem()
        }
    }
    
    private func getBasketItem() {
        
        if basket != nil {
            downloadItem(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
                
        }
    }
    
    //MARK: - Helper functions
    
    private func tempFunction() {
        for item in allItems {
            purchasedItemIds.append(item.id)
        }
    }
    private func updateTotalLabels(_ isEmpty: Bool) {
        if isEmpty {
            totalItemLabel.text = "0"
            totalPriceLabel.text = returnBasketTotalPrice()
        } else {
            totalItemLabel.text = "\(allItems.count)"
            totalPriceLabel.text = returnBasketTotalPrice()
        }
        
        checkoutButtonStatusUpdate()
    }
    
    private func returnBasketTotalPrice() -> String {
        var totalPrice = 0.0
        for item in allItems {
            totalPrice += item.price
        }
        return "Total price is: " + covertToCurrency(totalPrice)
        
    }
    
    private func emptyTheBasket() {
        purchasedItemIds.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        
        updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds]) { (error) in
            
            if error != nil {
                print("Error updating basket ", error!.localizedDescription)
            }
            
            self.getBasketItem()
        }
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
        if MUser.currentUser() != nil {
            
            let newItemIds = MUser.currentUser()!.purchaseItemIds + itemIds
            
            updateCurrentUserInFirestore(withValues: [kPURCHASEDITEMIDS : newItemIds]) { (error) in
                if error != nil {
                    print("Error adding purchased items ", error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Navigation
    private func showItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! itemViewController
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: - Control checkoutButton
    private func checkoutButtonStatusUpdate() {
        checkoutButton.isEnabled = allItems.count > 0
        
        if checkoutButton.isEnabled {
            checkoutButton.backgroundColor = #colorLiteral(red: 0.9853866696, green: 0.4802055359, blue: 0.4715971351, alpha: 1)
        } else {
            disabeleCheckoutButton()
        }
        
    }
    
    private func disabeleCheckoutButton() {
        checkoutButton.isEnabled = false
        checkoutButton.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    private func remoteItemFromBasket(itemId: String) {
        for i in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[i] {
                basket!.itemIds.remove(at: i)
                return
            }
        }
    }
    
    //MARK: - Stripe payment functions
    
    private func finishPayment(token: STPToken) {
        self.totalPrice = 0
        
        for item in allItems {
            purchasedItemIds.append(item.id)
            self.totalPrice += Int(item.price)
        }
        self.totalPrice = self.totalPrice * 100
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: totalPrice) { (error) in
            
            if error == nil {
                self.emptyTheBasket()
                self.addItemsToPurchaseHistory(self.purchasedItemIds)
                self.showNotification(text: "Payment Successful", isError: false)
            } else {
                self.showNotification(text: error.localizedDescription, isError: true)
                print("error: ", error.localizedDescription)
            }
        }
    }
    
    private func showNotification(text: String, isError: Bool) {
        
        
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func showPaymentOptions() {
        let alertController = UIAlertController(title: "Payment Options", message: "Choose preference payment option", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { (action) in
            
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CardInfoViewController
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        return cell
    }
    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            remoteItemFromBasket(itemId: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds]) { (error) in
                if error != nil {
                    print("error updating the basket ", error!.localizedDescription)
                }
                
                self.getBasketItem()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}

extension BasketViewController: CardInfoViewControllerDelegate {
  
    func didClickDone(_ token: STPToken) {
        finishPayment(token: token)
        //print("we have a token", token)
    }
    
    func didClickCancel() {
        showNotification(text: "Payment Canceled", isError: true)
        //print("user cancelled the payment")
    }
    
    

    
}
