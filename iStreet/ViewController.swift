//
//  ViewController.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/2/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit
import PasswordTextField
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var passwordFielf : UITextField!

    @IBOutlet weak var passwordTextField: PasswordTextField!
    
    var dict : [String : Any]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
        
        performSegue(withIdentifier: LOGGED_SEGUE, sender: nil)
        }
    }
    
    @IBAction func FBbuttonpressed (_ sender : UIButton!){
        
        let facebooklogin = FBSDKLoginManager()
        
        facebooklogin.loginBehavior = FBSDKLoginBehavior.browser
        facebooklogin.logIn(withReadPermissions: ["email","public_profile"], from: self, handler: { (result , error)   in
        
            
            if error != nil {
                // nedd alert here
                self.ERRORALERT("idk", msg: "who is this")
                print("cant login")
            } else {
            let accesstoken = FBSDKAccessToken.current().tokenString
                
                print("here is your tokken\(accesstoken)")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accesstoken!)
                
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        // put alrem here 
                        print("error with crenetial")
                        
                    } else {
                        print("he's one :\(user)")
                        
                        // what's going to be in the dictionary in the user section
                        
                        
                        let graphResquest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name"])
                        graphResquest?.start(completionHandler: { (connection , result , error ) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            
                            else {
                                
                                if let result = result as? Dictionary < String , String> {
                                    let name = result["name"]
                                    
                                    print (name)
                                    
                                    
                                    
                                    let userData = [ "provider" : credential.provider , "username" : name]
                                    
                                    // put them in the section
                                    Services.ds.CreateFirebaseUser(user!.uid, user: userData as! Dictionary<String, String>)
                                    
                                    
                                    UserDefaults.standard.setValue(user!.uid , forKey: KEY_UID)
                                    
                                    
                                    self.performSegue(withIdentifier: LOGGED_SEGUE, sender: nil)
                                }
                                
                            }
                            
                            
                            
                        })
                    
                    
                                            }
                })
            }
        })
        
        
    
}
    @IBAction func attemptlogin (_ sender :UIButton!){
        
        if let email = usernameField.text , email != "" , let psw = passwordFielf.text  , psw != "" {
            
            // try sign the user in 
            
            FIRAuth.auth()?.signIn(withEmail: email, password: psw, completion: { (user, error) in
                
                if error != nil {
                                        if error?._code == 17008 {
                        self.ERRORALERT("the format of your email man", msg: "horrible at formatting")
                    }
                    if error?._code == 17009{
                        self.ERRORALERT("passord is incorrect", msg: "try another pass man")
                    }
                    if error?._code == 17011 {
                        print("we are here")
                        
                    // if account not existed then create one :
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: psw, completion: { (user, error) in
                        
                        // if error creating account, tell them by alert
                        if error != nil {
                            if error?._code == 17007 {
                                self.ERRORALERT("Email already in use", msg: "use different email")
                            }
                            if error?._code == 17026 {
                                self.ERRORALERT("passwordshould be longer", msg: "need more than 6 charachters for password")
                            }

                            
                           else if error?._code == 17008 {
                                self.ERRORALERT("the format of your email man", msg: "horrible at formatting")}
                            print(error)
                        }
                        else {
                            // if no error creating account , save it
                            
                            let userData = ["provider" : "email", "username" : "newuser"]
                            UserDefaults.standard.setValue(user?.uid, forKey: KEY_UID)

                            
                          Services.ds.CreateFirebaseUser(user!.uid, user: userData)
                            

                            // after saving it , take user to next screen
                            self.performSegue(withIdentifier: LOGGED_SEGUE, sender: nil)
                        }
                    })
                    }
                } else {
                    // if no error in signing up , next page
                    self.performSegue(withIdentifier: LOGGED_SEGUE, sender: nil)

                }
            })
        } else {
            ERRORALERT("enter info", msg: "you need info here ")
        }
        
    }
        func ERRORALERT (_ title :String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }

}
    
    
