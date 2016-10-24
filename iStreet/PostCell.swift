//
//  PostCell.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/4/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    var post : Post!
    var request : Request?
    var like_ref : FIRDatabaseReference!
    var profile_ref : FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    var profile : Profile!
    

    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var descImage : UIImageView!
    @IBOutlet weak var likelbale : UILabel!
    @IBOutlet weak var usernameLab : UILabel!
    
    @IBOutlet weak var DescText: UITextView!

    @IBOutlet var likeImagee: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    
    
       let tap = UITapGestureRecognizer(target: self, action: (#selector(PostCell.liketapped(_:))))
        
        tap.numberOfTapsRequired = 1
        likeImagee.addGestureRecognizer(tap)
        likeImagee.isUserInteractionEnabled = true
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        descImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func COnfigureCell ( _ post :Post, img : UIImage?  ){
        
        // clear existing image cuz it's old 
        
        self.descImage.image = nil
        self.post = post
        
        
        
        
        let userFef = profile_ref.child("user\(FIRAuth.auth()!.currentUser!.uid)")
        
        userFef.observe(.value, with: { (snapshot) in
            
            let user = Post(snapshot: snapshot)
            self.usernameLab.text = user.postunsername
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
    
    
                Services.ds.Current_user.observeSingleEvent(of: .value, with: { (snapshot  ) in

            if let dictionary = snapshot.value as? Dictionary <String,Any> {
//                if let username = dictionary["username"] as? String {
//                    
//                    self.usernameLab.text = username
//    
//                }
                
                if let image = dictionary["ProfileImg"] as? String {
                    Alamofire.request(image).responseImage { response in
                        debugPrint(response)
                        
                        //                        print(response.request)
                        //                        print(response.response)
                        debugPrint(response.result)
                        
                        if let image = response.result.value {
                            
                                                        
                            
                            self.profileImage.image = image
                    
                        }
                    }
                }

            }
            })
    
            
        
         like_ref = Services.ds.Current_user.child(byAppendingPath: "Like").child(byAppendingPath: post.postkey)
        
        self.DescText.text = post.postdescription
        self.likelbale.text = "\(post.postlike)"
        
        
        // check if there is an image in URL
        
        if post.postImage != nil {
            // if there is , then download it from cache NOT FROM REQUEST
            if img != nil {
                descImage.image = img!
                
                // if there is no imgae in cache , let's get it from internet
            } else {
                //Must store the request so we can cancel it later if this cell is now out of the users view
                Alamofire.request(post.postImage!).response { response  in
                    
//                    print("here is the data\(response.data)")
                    
                   
                    
                    if response.error == nil {
                        let data = response.data
                        let img = UIImage(data: data!)!
                        self.descImage.image = img
                        
                        FeedVC.ImageCache.setObject(img, forKey: (post.postImage! as AnyObject))
                    }
                }
            
                        
            
        
              
        }
        
        
        } else{
            self.descImage.isHidden = true
    }
        
        
        like_ref.observeSingleEvent(of: .value, with: {  snapshot in
            
            if let doesntExist = snapshot.value as?  NSNull {
                
                // we havent liked this post 
                self.likeImagee.image = UIImage(named: "broken")
                
                
            } else{
                self.likeImagee.image = UIImage(named: "dislike")
            }
            
            
        })
   }
    
    func liketapped(_ sender : UITapGestureRecognizer? ){
        
        like_ref.observeSingleEvent(of: .value, with: {  snapshot in
            
            // reverse it cuz if we tap it , it means we change the image
            if let doesntExist = snapshot.value as?  NSNull {
                self.likeImagee.image = UIImage(named: "dislike")
                self.post.changeLikes(true)
                self.like_ref.setValue(true)
                
                
        } else{
                self.likeImagee.image = UIImage(named: "broken")
                self.post.changeLikes(false)
                self.like_ref.removeValue()


            }
            
            self.likelbale.text = "\(self.post.postlike)"
        })

        
    }
}
