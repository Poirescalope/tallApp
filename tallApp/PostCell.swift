//
//  PostCell.swift
//  tallApp
//
//  Created by Robin Tilman on 26/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var showcaseImage: UIImageView!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var usernameTaille: UILabel!
    
    var post:Post!
    var request: Request?
    var likeRef: FIRDatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true

        
    }
    
    override func drawRect(rect: CGRect) {
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        showcaseImage.clipsToBounds = true

    }
    
    func configureCell(post: Post, img: UIImage?) {
        
        self.post = post
        self.likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.descriptionText.text = post.postDescription
        self.usernameLabel.text = post.username
        self.likesLabel.text = "\(post.likes)"
        self.usernameTaille.text = post.taille
        
        if post.imageUrl != nil {
            
 
            if img != nil {
            self.showcaseImage.image = img
                
            }else{
            
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        
                        
                        let img = UIImage(data: data!)!
                        
                        self.showcaseImage.image = img
                        
                        feedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
            
        
        
        }else{
            self.showcaseImage.hidden = true

        }
        
        let likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        likeRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            // Appelé une fois seulement
            
            if let doesNotExist = snapshot.value as? NSNull { // si il n'y a pas de like par l'utilisateur sur ce post
                
                self.likeImage.image = UIImage(named: "heart-empty")
                
            }else{
            
                self.likeImage.image = UIImage(named: "heart-full")
                
            }
            
        })
        
        
        }
        
    func likeTapped(sender: UITapGestureRecognizer) {
        
        
        
        likeRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            // Appelé une fois seulement
            
            if let doesNotExist = snapshot.value as? NSNull {
                
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLike(true)
                self.likeRef.setValue(true)
                
            }else{
                
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLike(false)
                self.likeRef.removeValue()
                
            }
            
        })
        
        
    }

    
 
    
}
