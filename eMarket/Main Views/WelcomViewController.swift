//
//  WelcomViewController.swift
//  eMarket
//
//  Created by Xieheng on 2020/03/09.
//  Copyright © 2020 Xieheng. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendEmailButton: UIButton!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
    }
    @IBAction func loginPressed(_ sender: Any) {
    }
    @IBAction func registerPressed(_ sender: Any) {
    }
    
    @IBAction func forgePasswordPressed(_ sender: Any) {
    }
    @IBAction func resendEmailPressed(_ sender: Any) {
    }
    
}
