//
//  feedVC.swift
//  tallApp
//
//  Created by Robin Tilman on 26/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    var posts = [Post]()
    var imageSelected:Bool = false
    static var imageCache = NSCache()
    
    var imagePicker: UIImagePickerController!

    @IBOutlet var postfield: materialTextField!
    @IBOutlet var imageSelectorImage: UIImageView!
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "D'accord", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        tableView.estimatedRowHeight = 479
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.posts = []
                
                for snap in snapshots {
                    print("SNAP : \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                        
                    }
                    
                }
                
            }
            
               self.tableView.reloadData()
            
        })

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print(post.postDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? PostCell {
            
            cell.request?.cancel() // si il y en a déjà une au départ
            
            var img:UIImage?
            
            if let url = post.imageUrl {
                
               img = feedVC.imageCache.objectForKey(url) as? UIImage
                

            
            }

            
            cell.configureCell(post, img: img)
            return cell
        }else{
        
        
return PostCell()
        
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
        
    }
    
    
    @IBAction func selectImage(sender: AnyObject) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
       
        
    }
    @IBAction func makePost(sender: AnyObject) {
        
        if let txt = postfield.text where txt != "" {
            
            if let img = imageSelectorImage.image where imageSelected == true {
                
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.5)!
                
                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                
                Alamofire.upload(.POST, url, multipartFormData: { MultipartFormData in
                    
                    MultipartFormData.appendBodyPart(data: keyData, name: "key")
                    
                    MultipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    
                    MultipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                }) { encodingResult in
                    
                    
                    switch encodingResult {
                        
                    case .Success(let upload, _, _):
                        
                        upload.responseJSON(completionHandler: { response in
                            
                            if let info = response.result.value as? Dictionary<String,AnyObject> {
                                
                                if let links = info["links"] as? Dictionary<String,AnyObject> {
                                    
                                    if let imageLink = links["image_link"] as? String {
                                        
                                        print("LINK: \(imageLink)")
                                        
                                        self.displayAlert("Voilà !", message: "Votre post est publié.")
                                        self.postToFirebase(imageLink, username: user_username, taille: user_taille)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        })
                        
                    case.Failure(let error):
                        
                        print(error)
                        
                        
                    }


 


                             }
                
            }else{
                
                postToFirebase(nil,username: user_username, taille: user_taille) // si pas d'images
                
                
            }
                    }
            }
    
    
    
    
    func postToFirebase(imgUrl:String?, username: String?, taille:String?) {
        
        var post: Dictionary<String, AnyObject> = ["description": postfield.text!, "likes" : 0]
        
        
        if imgUrl != nil {
            
            post["imageUrl"] = imgUrl!
        }
        
        
        if username != nil {
            
            post["username"] = username
            
        }
        
        if taille != nil {
            
            post["taille"] = taille
            
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postfield.text = ""
        imageSelectorImage.image = UIImage(named: "camera.png")
        imageSelected = false
        
        tableView.reloadData()
    }

    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            
            return 300
            
        }else{
            
            return tableView.estimatedRowHeight
        }
    }
 */
}