//
//  SearchViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/17.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var SearchOptionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    //MARK: - Vars
    var searchResults: [Item] = []
    var activityIndicator : NVActivityIndicatorView?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.width / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1), padding: nil)
        
    }
    

    @IBAction func showSearchBarButtonPressed(_ sender: Any) {
        dismissKeyBoard()
        showSearchField()
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        if searchTextField.text != "" {
            
            searchInFirebase(forName: searchTextField.text!)
            emptyTextField()
            animateSearchOptionsIn()
            dismissKeyBoard()
        }
    }
    
    
    //MARK: - Search Firebase
    
    private func searchInFirebase(forName: String) {
        showLoadingIndicator()
        searchAlgolia(searchString: forName) { (itemIds) in
            downloadItem(itemIds) { (allItems) in
                self.searchResults = allItems
                self.tableView.reloadData()
                
                self.hideLoadingIndicator()
            }
        }
    }
    
    //MARK: - Helper
    private func emptyTextField() {
        searchTextField.text = ""
    }
    
    private func dismissKeyBoard() {
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        
        searchButtonOutlet.isEnabled = textField.text != ""
        
        if searchButtonOutlet.isEnabled {
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.9853866696, green: 0.4802055359, blue: 0.4715971351, alpha: 1)
        } else {
            disableSearchButton()
        }
        
    }
    
    private func disableSearchButton() {
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    private func showSearchField() {
        disableSearchButton()
        emptyTextField()
        animateSearchOptionsIn()
    }
    
    //MARK: - Animation
    private func animateSearchOptionsIn() {
        UIView.animate(withDuration: 0.5) {
            self.SearchOptionView.isHidden = !self.SearchOptionView.isHidden
        }
    }
    
    //MARK: - Activity Indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func showItemView(withItem: Item) {
        
         let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! itemViewController
               itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        return cell
        
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemView(withItem: searchResults[indexPath.row])
    }
    
    
}


extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No items to display!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please check back later.")
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "search")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return NSAttributedString(string: "Start searching...")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        showSearchField()
    }
}
