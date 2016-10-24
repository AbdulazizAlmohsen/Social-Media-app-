//
//  secondVC.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/11/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import Firebase
import AlamofireImage
import FBSDKCoreKit




class SecondViewController : UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var titlelib: UILabel!
    
    var profile1 = [Profile]()
    var profile_ref : FIRDatabaseReference!
    
    var userinfo : FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }

    
    var post : Post!
    //outlet
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var profile_Image : UIImageView!
    
    //imagepicker
    let imagePicker = UIImagePickerController()

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        textfield.delegate = self
        
        // image setup 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       SaveData()
       
        
    }
    
    func SaveData () {
        
        
        let info = Services.ds.Current_user
        
        info.observe(.value, with: {(snapshot) in
            
            let snaps = snapshot.value as? Dictionary <String , String>
            
            print("here is the snaps \(snaps)")
            
            let user =  snaps?["username"]
            self.titlelib.text = user
            
            
            
            if let imageStr = snaps?["ProfileImg"] {
            
            Alamofire.request(imageStr).responseImage { response in
                
                if let image = response.result.value {
                    
                    self.profile_Image.image = image
                    
                    
                }
                }
            }
            
            })
        
    }
 
    @IBAction func pickprofilepic(_ sender: UIButton?) {
        present(imagePicker, animated: true, completion: nil)

        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profile_Image.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func animateTextField(_ textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -130
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField, up:false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    let TEXT_FIELD_LIMIT = 15
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= TEXT_FIELD_LIMIT
       
    }
    
    @IBAction func downloadImg (_ sender : AnyObject){
        
        
        
        if let img = profile_Image.image {
            
            let url_shack = "https://post.imageshack.us/upload_api.php"
            
            let url = URL(string: url_shack)
            
            let imagedata = UIImageJPEGRepresentation(img, 0.2)
            
            let ImageKey = "046ALMOU60b8dcc355bdf4a459ebe7302e6e2b13".data(using:String.Encoding.utf8)!
            let Json = "json".data(using:String.Encoding.utf8)!
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(Json, withName: "format")
                    multipartFormData.append(ImageKey, withName: "key")
                    multipartFormData.append(imagedata!, withName: "fileupload", fileName: "image", mimeType: "image/jpg")
                },
                to: url_shack ,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            let result = response.result.value
                            
                            // return a lont list of json
                            if let info = response.result.value as? Dictionary<String, Any> {
                                
                                if let links = info["links"] as? Dictionary<String, Any> {
                                    
                                    if let imgLink = links["image_link"] as? String {
                                        
//                                        print(imgLink)
                                        self.SaveNickname(url: imgLink)
//                                        self.SaveNickname ()
                                        
                                        
                                        
                                    }
                                }
                            }
                            
                        } case .failure(let encodingError):
                            print("here is an isssue\(encodingError)")
                        
                    }
            })
            
        } else {
            print("no image")
            
        }

        
        }
    
    
    
    
        func SaveNickname (url : String?) {
            
        var username = titlelib.text
        username = textfield.text
            
        var post : Dictionary < String , String > = [
            
            "username" : username!
        
        ]
        
        if url != nil {
            
            post["ProfileImg"] = url!
        }
        
         Services.ds.Current_user.updateChildValues(post)
            }
        
    }
    
    

    


        
    
    



