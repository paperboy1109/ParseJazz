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
    
    // MARK: - Outlets
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func signupTapped(_ sender: AnyObject) {
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
    }
    
    
    // MARK: - Helpers
    
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
