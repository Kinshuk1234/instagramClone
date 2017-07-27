/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    func createAlert(title: String, message: String) {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if emailText.text == "" || passwordText.text == "" {
        
            createAlert(title: "Missing required info", message: "Please enter email and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        
            if signupMode {
            
                // signup
                let user = PFUser()
                user.username = emailText.text
                user.email = emailText.text
                user.password = passwordText.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                       
                         var displayErrorMessage = "Please try again"
                        
                         let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                        
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Sign Up error", message: displayErrorMessage)
                        
                    } else {
                    
                        print("user signed up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
                
            } else {
            
                // login mode
                PFUser.logInWithUsername(inBackground: emailText.text!, password: passwordText.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                       
                        var displayErrorMessage = "Please try again"
                        
                         let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Log In error", message: displayErrorMessage)
                        
                    } else {
                    
                        print("user logged in")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    @IBAction func changeMode(_ sender: Any) {
        
        if signupMode {
        
            // change to login mode
            signupOrLoginButton.setTitle("Log In", for: [])
            changeModeButton.setTitle("Sign Up", for: [])
            message.text = "Don't have an account?"
            signupMode = false
            
        } else {
        
            //change to signup mode
            signupOrLoginButton.setTitle("Sign Up", for: [])
            changeModeButton.setTitle("Log In", for: [])
            message.text = "Already have an account?"
            signupMode = true
            
        }
        
    }
    
    @IBOutlet weak var changeModeButton: UIButton!
    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
        
            performSegue(withIdentifier: "showUserTable", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
