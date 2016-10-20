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
    
    // MARK: - Properties
    
    let debugSpace = "\n\n\n"
    var isInSignupMode = true
    var activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var sendCredentialsButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For debugging:
        queryUserName()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            performSegue(withIdentifier: "ToUserTable", sender: self)
        }
        
        /* Hide the navigation bar */
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func signupTapped(_ sender: AnyObject) {
        
        /* Parse will check the validity of the email */
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            showAlert(title: "Oops!", message: "Make sure to enter both an email and a password.")
            
        } else {
            
            showBusy()
            
            if isInSignupMode {
                
                let newUser = PFUser()
                
                newUser.username = emailTextField.text
                newUser.email = emailTextField.text
                newUser.password = passwordTextField.text
                
                newUser.signUpInBackground(block: { (success, error) in
                    
                    self.enableUI()
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        
                        self.handleError(withMessage: "Signup unsuccessful.", error: error)
                        
                    } else {
                        
                        self.performSegue(withIdentifier: "ToUserTable", sender: self)
                        
                    }
                })
                
            } else {
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (newUser, error) in
                    
                    self.enableUI()
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        
                        self.handleError(withMessage: "Unable to login.  Please check your password and/or try again later.", error: error)

                    } else {
                        
                        self.performSegue(withIdentifier: "ToUserTable", sender: self)
                        
                    }
                })
                
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        
        if isInSignupMode {
            
            loginButton.setTitle("Sign Up", for: [])
            
            sendCredentialsButton.setTitle("Log In", for: [])
            
            messageLabel.text = "Want to create an account?"
            
            isInSignupMode = false
            
        } else {
            
            loginButton.setTitle("Log In", for: [])
            
            sendCredentialsButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Already have an account?"
            
            isInSignupMode = true
            
        }
    }
    
    
    // MARK: - Helpers
    
    func handleError(withMessage: String, error: NSError?) {
        
        if let errorMessageForUser = error?.userInfo["error"] as? String {
            
            self.showAlert(title: "Error", message: errorMessageForUser)
            
        } else {
            
            self.showAlert(title: "Error", message: withMessage)
            
        }
        
    }
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showBusy() {
        
        activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func enableUI() {
        
        activityIndicatorView.stopAnimating()
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    func updateUserName(withName: String) {
        
        let parseQuery = PFQuery(className: "Users")
        
        parseQuery.getObjectInBackground(withId: "KKWbLJ6evV") { (object, error) in
            
            if error != nil {
                
                print("There was an error trying to query Parse: \(error)")
                
            } else {
                
                if let user = object {
                    
                    user["name"] = withName
                    user.saveInBackground(block: { (success, error) in
                        
                        if success {
                            print("Name successfully updated")
                        } else {
                            print("An error occurred when trying to update the name: \(error)")
                        }
                    })
                    
                }
                
            }
        }
        
    }
    
    func queryUserName() {
        
        let parseQuery = PFQuery(className: "Users")
        
        parseQuery.getObjectInBackground(withId: "KKWbLJ6evV") { (object, error) in
            
            if error != nil {
                
                print("There was an error trying to query Parse: \(error)")
                
            } else {
                
                if let user = object {
                    
                    print(self.debugSpace)
                    print(user)
                    print(user["name"])
                    print(self.debugSpace)
                }
                
            }
        }
        
    }
    
    func createTestUser() {
        
        let testObject = PFObject(className: "TestObject2")
        
        testObject["foo"] = "bar"
        
        testObject.saveInBackground { (success, error) -> Void in
            
            // added test for success 11th July 2016
            
            if success {
                
                print("\n\nObject has been saved.\n\n")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
        }
    }
    
    func createUsersWithClariel() {
        
        let newUser = PFObject(className: "Users")
        
        newUser["name"] = "Clariel"
        
        newUser.saveInBackground { (success, error) in
            
            if success {
                
                print("\n\nThe new user has successfully been saved.\n\n")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
            
        }
    }
}

// MARK: - Improve Keyboard Behavior

extension ViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }        
    
}
