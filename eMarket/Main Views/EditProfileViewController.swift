//
//  EditProfileViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/15.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if textFieldHaveText() {
            let withValues = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kONBOARD: true, kFULLADDRESS: addressTextField.text!, kFULLNAME: (nameTextField.text! + surnameTextField.text!)] as [String: Any]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("error updating user \(error!.localizedDescription)")
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            self.hud.textLabel.text = "All fields are required!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)

        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logOutUser()
    }
    
    
    
    //MARK: - UpdateUI
    private func loadUserInfo() {
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
        }
    }
    
    //MARK: - Helper funcs
    private func dismissKeyboard() {
        // hide keyboard by click return
        self.view.endEditing(false)
    }
    
    private func textFieldHaveText() -> Bool {
        return (nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "")
    }

    private func logOutUser() {
        MUser.logOutCurrentUser { (error) in
            if error == nil {
                print("Logged out.")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("error logOut ", error!.localizedDescription)
            }
        }
    }
}
