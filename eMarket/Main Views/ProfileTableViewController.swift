//
//  ProfileTableViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/13.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var purchaseHistoryButtonOutlet: UIButton!
    
    //MARK: - Vars
    var editBarButtonItem: UIBarButtonItem!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check logged in status
        checkLoginStatus()
        checkOnboardingStatus()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }


    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Helpers
    private func checkOnboardingStatus() {
        if MUser.currentUser() != nil {
            if MUser.currentUser()!.onboard {
                finishRegistrationButtonOutlet.setTitle("Account is Active", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = false
            } else {
                finishRegistrationButtonOutlet.setTitle("Finish registration", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = true
                finishRegistrationButtonOutlet.tintColor = .red
            }
            purchaseHistoryButtonOutlet.isEnabled = true
        } else {
            finishRegistrationButtonOutlet.setTitle("Logged out", for: .normal)
            finishRegistrationButtonOutlet.isEnabled = false
            purchaseHistoryButtonOutlet.isEnabled = false
        }
    }
    
    private func checkLoginStatus() {
        if MUser.currentUser() == nil {
            createRightBarButton(title: "Login")
        } else {
            createRightBarButton(title: "Edit")
        }
    }
    
    private func createRightBarButton(title: String) {
        editBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        
        self.navigationItem.rightBarButtonItem = editBarButtonItem
        
    }
    
    //MARK: - IBActions
    @objc func rightBarButtonItemPressed() {
        if editBarButtonItem.title == "Login" {
            //show login view
            showLoginView()
        } else {
            // go to profile
            goToEditProfile()
            
        }
    }
    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func goToEditProfile() {
       
        performSegue(withIdentifier: "ProfileToEditSeg", sender: self)
        
    }
    
    


}
