//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
       TMDBClient.getRequestToken(completion: handelRequestTokenResponse(success:error:))
        
    }
    
    @IBAction func loginViaWebsiteTapped() {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    
    
    func handelRequestTokenResponse(success: Bool, error: Error?){
        if success {
            print("success == > " + TMDBClient.Auth.requestToken)
          //  self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }else  {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid Cerdentials. \nPlease try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
