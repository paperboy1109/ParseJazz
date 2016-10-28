//
//  FeedTableVC.swift
//  ParseStarterProject-Swift
//
//  Created by Daniel J Janiak on 10/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableVC: UITableViewController {
    
    // MARK: - Properties
    
    var users = [String: String]()
    var messages = [String]()
    var userNames = [String]()
    var imageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        /* Get a list of all users */
        var query = PFUser.query()
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                self.users.removeAll()
                
                for item in users {
                    
                    if let user = item as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                    
                }
            }
            
            /* Get the followed users */
            
            let getFollowedUsersQuery = PFQuery(className: "Followers")
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.current()!.objectId!) )//PFUser.current()?.objectId)
            
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    
                    for item in followers {
                        
                        if let follower = item as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            
                            query.whereKey("userID", equalTo: followedUser)
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    
                                    for item in posts {
                                        
                                        if let post = item as? PFObject {
                                            
                                            self.messages.append(post["message"] as! String)
                                            self.imageFiles.append(post["imageFile"] as! PFFile)
                                            self.userNames.append(self.users[post["userID"] as! String]!)
                                            
                                            self.tableView.reloadData()
                                            
                                        }
                                    }
                                    
                                }
                                
                            })
                        }
                        
                    }
                    
                }
            })
            
        })
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
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            guard error == nil else {
                return
            }
            
            guard data != nil else {
                return
            }
            
            if let downloadedImage = UIImage(data: data!) {
                
                cell.postedImageView.image = downloadedImage
                
            }
        }
        
        cell.postedImageView.image = UIImage(named: "background_character") //placeholder, useful while actual image is downloading
        cell.userNameLabel.text = userNames[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]
        
        return cell
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

}
