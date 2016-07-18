//
//  popoverView.swift
//  tallApp
//
//  Created by Robin Tilman on 3/07/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit

class popoverView: UIViewController {

    @IBOutlet var titre: UILabel!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userUsername: materialTextField!
    @IBOutlet var userTaille: materialTextField!
    @IBOutlet var BouttonValider: materialButton!
    
    var dataentered:Bool = false
    
    
    
    
    
    
    
    
    
    var nameNSUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey("user_text_username") as? String
    
    var tailleNSUserDefaults = NSUserDefaults.standardUserDefaults().objectForKey("user_text_taille") as? String
    
    @IBAction func valider(sender: AnyObject) {
        
       
        
        
        if nameNSUserDefaults != "" {
            NSUserDefaults.standardUserDefaults().setObject(userUsername.text, forKey: "user_text_username")
        
        
        }
    
        if tailleNSUserDefaults != "" {
        
            NSUserDefaults.standardUserDefaults().setObject(userTaille.text, forKey: "user_text_taille") }
        
       
        
     
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nameNSUserDefaults != "" {
            
            titre.text = nameNSUserDefaults
            userUsername.alpha = 0
            userTaille.alpha = 0
            BouttonValider.alpha = 0
            
        }
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    
}
