//
//  post.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/6/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    
    fileprivate var _postdescription : String!
    fileprivate var _postImage : String?
    fileprivate var _postLike : Int!
    fileprivate var _postUsername : String!
    fileprivate var _postKey : String!
    fileprivate var _post_profile_IMG : String!
    fileprivate var post_ref : FIRDatabaseReference!
    var ref : FIRDatabaseReference?
    
    
    
    var postdescription : String {
        return _postdescription
    }
    var postImage : String? {
        return _postImage
    }
    
    var postlike : Int {
        return _postLike
    }
    var postunsername : String? {
        return _postUsername
    }
    var postkey : String {
        return _postKey
    }
    
    var post_profile_IMG : String {
    return _post_profile_IMG
        
    }
    
    init ( postprofile : String){
        
        self._post_profile_IMG = postprofile
    }
    
    
    // init profile image here
    init ( imageurl :  String , description : String  ){
        
        self._postdescription = description
        self._postImage = imageurl
    }
    
    init ( profile : String){
        self._postUsername = profile
    }
    
    init ( key : String , dictionary : Dictionary <String , AnyObject >){
        self._postKey = key
        
        
        
        if let like = dictionary["Like"] as? Int {
            self._postLike = like
        }
        if let poseDescription = dictionary["description"] as? String! {
            self._postdescription = poseDescription
        }
        
        if let imgurl = dictionary["ImgURL"] as? String {
            self._postImage = imgurl
        }
        // grap the profile from this dictionary 
        if let profile_img = dictionary["profileIMG"] as? String {
            self._post_profile_IMG = profile_img
        }
        
        if let profilrusername = dictionary["profileusername"] as? String {
            
            self._postUsername = profilrusername
            
        }
        
        // grab reference for the post
        self.post_ref = Services.ds.ref_post.child(self._postKey)
        
    }
    
    func changeLikes ( _ addLike : Bool){
        
        if addLike {
           _postLike = _postLike  + 1
        }
        else {
            _postLike = _postLike - 1
        }
        
        post_ref.child("Like").setValue(_postLike)
    }
    
    init( snapshot : FIRDataSnapshot) {
        self.ref = snapshot.ref
        _postUsername = (snapshot.value!  as? Dictionary<String , Any>)? ["username"] as? String
        _postImage = (snapshot.value!  as? Dictionary<String , Any>) as? String

    }
     
    
}
