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
        print("login handelRequestTokenResponse  =====> print success:")
        print(success)
        
        if success {
           
          //  self.performSegue(withIdentifier: "completeLogin", sender: nil)
            DispatchQueue.main.async {
                TMDBClient.loging(username: self.emailTextField.text ?? "" , password: self.passwordTextField.text ?? "", completion: self.handelRequestTokenResponse(success:error:))
            }
            
               print("login success in handelRequestTokenResponse ======= > ")
            print(TMDBClient.Auth.requestToken)
            
            
        }
        else  {
//            let alert = UIAlertController(title: "Login Failed", message: "Invalid Cerdentials. \nPlease try again!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                NSLog("The \"OK\" alert occured.")
//            }))
//            self.present(alert, animated: false, completion: nil)
            
            print("lofin faild inside else ========> ")
        }
        
    }
    
    func handleLoginResponse(success: Bool, Error: Error?){
        print("handleLoginResponse ====> ")
        print(TMDBClient.Auth.requestToken)
    }
    
}
