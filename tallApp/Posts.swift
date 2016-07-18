//
//  Posts.swift
//  tallApp
//
//  Created by Robin Tilman on 28/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit
import Firebase

class Post {
    
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _taille: String!
    private var _postKey: String!
    private var _userImageUrl: String?
    private var _postRef: FIRDatabaseReference!
    
    var postDescription: String {
        
        return _postDescription
    }
    
    var imageUrl: String? {
        
        return _imageUrl
    }
    var likes: Int {
        
        return _likes
    }
    var username: String {
        
        return _username
    }
    var postKey: String {
        
        return _postKey
    }
    var userImageUrl: String? {
        
        return _userImageUrl
    }
    
    var taille:String {
        
        return _taille
    }
    
    init(description: String, imageUrl: String?, username: String, taille: String) {
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
        self._taille = taille
        
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {

        
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            
            self._likes = likes
        }

        
        if let imageUrl = dictionary["imageUrl"] as? String {
            
            self._imageUrl = imageUrl
        }
        
        if let desc = dictionary["description"] as? String {
            
            self._postDescription = desc
        }
        
        if let user = dictionary["username"] as? String {
            
            self._username = user
        }
        
        if let taille = dictionary["taille"] as? String {
            
            self._taille = taille
        }
        
        
        self._postRef = DataService.ds.REF_POSTS.child(self._postKey)
}
    
    func adjustLike(addLike: Bool) {
        
        if addLike == true {
            
            _likes = _likes + 1
            
        }else{
            
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
        
    }
    
    
}
