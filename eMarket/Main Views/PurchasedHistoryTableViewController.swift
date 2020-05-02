//
//  PurchasedHistoryTableViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/16.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class PurchasedHistoryTableViewController: UITableViewController {

    //MARK: - Vars
    var itemArray : [Item] = []
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])
        return cell
    }

    //MARK: - Load items
    private func loadItems() {
        downloadItem(MUser.currentUser()!.purchaseItemIds) { (allItems) in
            self.itemArray = allItems
            print("we have \(allItems.count) purchased items.")
            self.tableView.reloadData()
        }
    }
   

}

extension PurchasedHistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No items to display!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please check back later.")
    }
    
}

