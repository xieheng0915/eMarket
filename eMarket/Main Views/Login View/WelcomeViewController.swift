//
//  WelcomeViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/08.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    //MARK: - Vars
   let hud = JGProgressHUD(style: .dark)
   var activityIndicator: NVActivityIndicatorView?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1.0), padding: nil)
    }
    
    //MARK: - Action
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if textFieldsHaveText() {
            loginUser()
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }

    @IBAction func registerButtonPressed(_ sender: Any) {
        if textFieldsHaveText() {
            registerUser()
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
   
    
   
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        if emailTextField.text != "" {
            resetThePassword()
        } else {
            hud.textLabel.text = "Please insert email!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func resendEmailPressed(_ sender: Any) {
        
        MUser.resendVerificationEmail(email: emailTextField.text!) {(error) in
            print("error resending email", error?.localizedDescription)
        }
    }
    
    //MARK: - Login User
    private func loginUser() {
        showLoadingIndicator()
        MUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil {
                if isEmailVerified {
                    self.dismissView()
                } else {
                    self.hud.textLabel.text = "Please verify your email."
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendButton.isHidden = false
                }
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIndicator()
        }
    }
    
    //MARK: - Register User
    private func registerUser() {
        showLoadingIndicator()
        MUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error == nil {
                self.hud.textLabel.text = "Verification Email sent!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = "Error, registering: " + error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideLoadingIndicator()
        }
    }
    
    //MARK: - Helpers
    
    private func resetThePassword() {
        
        MUser.resetPasswordFor(email: emailTextField.text!) {(error) in
            
            if error == nil {
                self.hud.textLabel.text = "Reset password email sent!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
    }
    
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
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
    

}
