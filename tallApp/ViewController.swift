//
//  ViewController.swift
//  tallApp
//
//  Created by Robin Tilman on 22/06/16.
//  Copyright © 2016 Robin Tilman. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: materialTextField!
    @IBOutlet var passwordField: materialTextField!
    @IBOutlet var userHourLabel: UILabel!
    @IBOutlet var fbbtnlbl: materialButton!
    @IBOutlet var gobtnlbl: materialButton!
    
    

    // alert
    func displayAlert(title: String, message: String) {
 
            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "D'accord", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
   
    }

    
    override func viewDidLoad() {
        
        fbbtnlbl.alpha = 0
        fbbtnlbl.alpha = 0
        self.emailField.delegate = self
        self.passwordField.delegate = self
    

        
        // heure
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        
        if hour < 12 {
            
            let userHour = "Bonne journée !"
            userHourLabel.text = userHour
            
            
            
            }else if hour > 13 && hour < 18 {
                
                let userHour = "Bonne après-midi !"
                userHourLabel.text = userHour
                
            }else{
                
                let userHour = "Bonne soirée !"
                userHourLabel.text = userHour
            }
            
    
        
        // fin heure
        

    
    
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    UIView.animateWithDuration(1.5) { 
        self.fbbtnlbl.alpha = 1
        self.gobtnlbl.alpha = 1
        }
    }
    
    @IBAction func fbBtnPress(sender:UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            
            if facebookError != nil { print("Facebook login failed. Error \(facebookError)")
            
            }else{
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                print("Successfully logged in with facebook. \(accessToken)")
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                    
                    if error != nil { print("Login failed. \(error)") }else{ print("Logged in. \(user)")
                                        let userData = ["provider": credential.provider] //,"username" : username
                    
                    DataService.ds.createFirebaseUser(user!.uid, user: userData)
                    
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                    
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil) }
                })
            }
        }
       
    }
    @IBAction func emailButtonpressed(sender: UIButton!) {
        
        
        if let email = emailField.text where email != "" , let pwd = passwordField.text where pwd != "" {
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in
                
                
                if error != nil {
                print(error)
                  
                    if error!.code == STATUS_ACCOUNT_NONEXIST {
                        print("OK")
                        
FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
    
    if error != nil {
        self.displayAlert("Impossible de créer un compte", message: "Merci de réessayer plus tard")

    } else {
        
        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
        
        let userData = ["provider": "email"] //,"username" : username
        DataService.ds.createFirebaseUser(user!.uid, user: userData)
        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    }
    
    
    
})
                    
                    }else{
                        
                        self.displayAlert("Impossible de se connecter", message: "Vérifiez votre email et votre mot de passe")
                    }// si on a l'erreur comme quoi l'user n'existe pas, on le créer !
                    
                }else{
                    
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
                    }else{
            
            displayAlert("Il y a une erreur", message: "Merci de bien vouloir vérifier que le formulaire soit bien rempli")

        }
    }
    
    func textFieldShouldreturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
        
    }
    
}

