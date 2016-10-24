//
//  FeedVC.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/4/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import CircularSpinner


class FeedVC: UIViewController , UITableViewDelegate , UITableViewDataSource, UINavigationControllerDelegate , UIImagePickerControllerDelegate , UITextFieldDelegate {
    
    
    @IBOutlet weak var postfield: MaterialTextField!
    @IBOutlet weak var Imageselected: UIImageView!
    
    var post = [Post]()
    
    var ImagePicker : UIImagePickerController!
    var imagepicked = false
    
    @IBOutlet weak var tableview : UITableView!
    static var ImageCache : NSCache <AnyObject, AnyObject> = NSCache()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        //table delegate
        
        tableview.estimatedRowHeight = 350
        tableview.rowHeight = UITableViewAutomaticDimension
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // image delegate
        ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        
        
        postfield.delegate = self
        
        // post code
        
        
        
        // anytime a vlaue changes
        Services.ds.ref_post.observe( .value, with: { (snapshot) in
            
            self.post = []
            
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
            
          for snap in snapshots {
            
            if let postDict = snap.value as? Dictionary <String , AnyObject> {
//                print("this is postDic\(postDict)")
                
                let key = snap.key // this is sthe ID after post
                
                let post = Post(key: key, dictionary: postDict)
                
                self.post.append(post)
            }
        
         }
     }
      self.tableview.reloadData()
  })
        
        
        
        
        

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            //Cancel the image request when cellForRowAtIndexPath is called because it means
            //we need to recycle the cell and we need the old request to stop downloading the image
            
            cell.request?.cancel()
            
            let post = self.post[indexPath.row]
            
            //Declare an empty image variable
            var img : UIImage?
            
            //If there is a url for an image, try and get it from the local cache first
            //before we attempt to download it
            
            //
            if let url = post.postImage {
               img = FeedVC.ImageCache.object(forKey: url as  AnyObject) as? UIImage
            }
            
            // here is the profile pic code to insert it in the cell..
            
//            var name : UILabel?
            
        
            cell.COnfigureCell(post, img: img )
            
            return cell
        } else {
            
            return PostCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = self.post[indexPath.row]
        
        if post.postImage == nil {
            return UITableViewAutomaticDimension
        
        } else {
            return tableview.estimatedRowHeight
        }
    
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            Imageselected.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        imagepicked = true
    }

    
    @IBAction func MakePost(_ sender: AnyObject) {
        
        
        if (postfield.text?.characters.count)! >= 70 || postfield.text == "" {
            
            ERRORALERT (" طول الرساله",msg : "اكتب شي مايطول عن ٣٠ حرف")
           
            
        } else {
            
            
            if let img = Imageselected.image  , imagepicked == true {
                
                CircularSpinner.show("جاري التحميل ...", animated: true, type: .indeterminate)
                
                delayWithSeconds(5) {
                    CircularSpinner.hide()
                }
                
                let URL_SHack = "https://post.imageshack.us/upload_api.php"
                let url = URL(string: URL_SHack)
                
                let imageData = UIImageJPEGRepresentation(img, 0.2)
                
                let ImageKey = "046ALMOU60b8dcc355bdf4a459ebe7302e6e2b13".data(using:String.Encoding.utf8)!
                let Json = "json".data(using:String.Encoding.utf8)!
//                
//
//            
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(Json, withName: "format")
                        multipartFormData.append(ImageKey, withName: "key")
                        multipartFormData.append(imageData!, withName: "fileupload", fileName: "image", mimeType: "image/jpg")
                    },
                    to: URL_SHack ,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in

                              let result = response.result.value
                                
                                // return a lont list of json
                                if let info = response.result.value as? Dictionary<String, Any> {
 
                                    if let links = info["links"] as? Dictionary<String, Any> {
                                        
                                        if let imgLink = links["image_link"] as? String {
                                            
                                            self.FirebaseToPost(imgLink)
                                            
//                                            print(imgLink)
                                            
                                        }
                                    }
                                }
                                
                            } case .failure(let encodingError):
                                print("here is an isssue\(encodingError)")
                            self.ERRORALERT("مشكله في تحميل الصوره", msg: "حاول ارفاق الصوره مره ثانيه")
                        }
                })
                
            } else {
                
                        self.FirebaseToPost(nil)
                
            }

        }

        }
            @IBAction func taptoselectImage(_ sender: UITapGestureRecognizer) {
        ImagePicker.sourceType = .camera
//        ImagePicker.sourceType = .savedPhotosAlbum
        
        
        present(ImagePicker, animated: true, completion: nil)
            
    }
    
    func FirebaseToPost ( _ Image : String?) {
        // convert the data to dictionary to fit in Firebase 
        
        
        var post : Dictionary <String , Any> = [
            
            
            "description" : postfield.text! ,
            "Like" : 0 ,
//            "profileusername" : profileName.text
            
        ]
        
        if Image != nil {
            
            post["ImgURL"] = Image!
        }         
            let postFirebase = Services.ds.ref_post.childByAutoId()
            postFirebase.setValue(post)
        
          
        
        
            ERRORALERT ("تم الشر",msg : "تم تحميل كلامك تحت")
            
            postfield.text = ""
            Imageselected.image = UIImage(named: "takepic")
            
            tableview.reloadData()
        
    }
        // Lifting the view up
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    @IBAction func returnPressed(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    func ERRORALERT (_ title :String,msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 30
        let currentString : NSString = postfield.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    @IBAction func back(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "contentViewController", sender: self)
    }
    
    
   }
