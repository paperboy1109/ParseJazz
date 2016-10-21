//
//  UserTableVC.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel J Janiak on 10/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableVC: UITableViewController {
    
    // MARK: - Properties
    
    let cellIdentifier = "UserCell"
    var userNames = [""]
    var userIDs = [""]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = PFUser.current() {
            print("\n\n**The current user is: \(currentUser)** \n\n")
        }
        
        let query = PFUser.query()
        
        /* Get all users */
        query?.findObjectsInBackground(block: { (objects, error) in
            
            guard error == nil else {
                print("\n\nFailed to get user names\n\n")
                return
            }
            
            if let allUsers = objects {
                
                
                /* Remove the (blank) placeholder user name */
                self.userNames.removeAll()
                
                for item in allUsers {
                    
                    /* Append all current users */
                    if let user = item as? PFUser {
                        
                        let usernameComponents = user.username!.components(separatedBy: "@")
                        
                        self.userNames.append(usernameComponents[0])
                        self.userIDs.append(item.objectId!)
                        
                    }
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    // MARK: - Table View Delegate Methods
    
    override func viewDidAppear(_ animated: Bool) {
        
        /* Show the navigation bar */
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = userNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        /* Set up the follower - following relationship */
        
        let following = PFObject(className: "Followers")
        
        following["follower"] = PFUser.current()?.objectId
        following["following"] = userIDs[indexPath.row]
        
        following.saveInBackground()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Actions
    
    @IBAction func logoutTapped(_ sender: AnyObject) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "ToRoot", sender: self)
        
    }
    
    
}
