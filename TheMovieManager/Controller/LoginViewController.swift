
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        TMDBClient.getRequestToken(completion: handelRequestTokenResponse(success:error:))
    }
    
    @IBAction func loginViaWebsiteTapped() {
        
        setLoggingIn(true)
        TMDBClient.getRequestToken(){
            (succes, error) in
            if succes{
                DispatchQueue.main.async {
                     UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func handelRequestTokenResponse(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                TMDBClient.login(username: self.emailTextField.text ?? "" , password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:Error:))
            }
            print("login success in handelRequestTokenResponse ======= > ")
            print(TMDBClient.Auth.requestToken)
        }
    }
    
    func handleLoginResponse(success: Bool, Error: Error?){
        print("handleLoginResponse ====> ")
        print(TMDBClient.Auth.requestToken)
        if success{
            TMDBClient.createSessionId(compeletion: handelSessionResponse(sucess:Error:))
            print("Session Id")
            print("================%%%%>" + TMDBClient.Auth.sessionId)
        }        else  {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid Cerdentials. \nPlease try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: false, completion: nil)
            print("lofin faild inside else ========> ")
        }
    }
    
    
    func handelSessionResponse(sucess: Bool, Error: Error?){
        setLoggingIn(false)
        if sucess {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        }
    }
    
    func setLoggingIn(_ logginIn: Bool){
        if logginIn{
            activityIndicator.startAnimating()
        } else{
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        loginButton.isEnabled = !logginIn
        loginViaWebsiteButton.isEnabled = !logginIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    
    
}
