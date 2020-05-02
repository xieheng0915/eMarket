//
//  ItemsTableViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/02/08.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class ItemsTableViewController: UITableViewController {

    
    // MARK: Vars
    var category: Category?
    var itemArray: [Item] = []
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.title = category?.name
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if category != nil {
            // download items
            loadItems()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell
        
        // Configure the cell...
        cell.generateCell(itemArray[indexPath.row])

        return cell
    }
   
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg" {
            let vc = segue.destination as! AddItemViewController
            vc.category = category
        }
    }
    // MARK: - show Items
    private func showItemView(_ item:Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! itemViewController
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    // MARK: Load Items
    private func loadItems() {
        downlaodItemFromFirebase(category!.id) { (allItems) in
            print("We have \(allItems.count) for this category")
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
}

extension ItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
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
