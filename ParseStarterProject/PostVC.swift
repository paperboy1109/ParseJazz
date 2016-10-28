//
//  PostVC.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel J Janiak on 10/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    
    var activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet var imageToPost: UIImageView!
    @IBOutlet var textField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ImagePickerController delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageToPost.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alertController.dismiss(animated: true, completion: nil)
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
    
    // MARK: - Actions
    
    @IBAction func chooseImageTapped(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func postTapped(_ sender: AnyObject) {
        
        showBusy()
        
        let post = PFObject(className: "Posts")
        post["message"] = textField.text
        post["userID"] = PFUser.current()?.objectId!
        
        // let imageData = UIImagePNGRepresentation(imageToPost.image!)
        // let imageFile = PFFile(name: "image.png", data: imageData!)
        
        // Large images will crash the app!
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.2)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        
        post["imageFile"] = imageFile
        post.saveInBackground { (success, error) in
            
            self.enableUI()
            
            if error != nil {
                self.showAlert(title: "Failed to post your image", message: "Please try again later")
            } else {
                
                self.showAlert(title: "Image posted", message: "Your image has been posted successfully")
                
                self.textField.text = ""
                
                self.imageToPost.image = UIImage(named: "background_character")
            }
            
            
        }
        
        
    }

}
