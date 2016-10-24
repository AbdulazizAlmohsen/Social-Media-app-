//
//  profile.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/13/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import Foundation
import UIKit


class Profile {

fileprivate var _profile_IMG : String?

fileprivate var _Profile_name : String?
    
fileprivate var _user_key : String!




    
var profile_IMG : String {

return _profile_IMG!
}

var profile_name : String {
return _Profile_name!
}
    
    var user_key : String {
        
        return _user_key
    }


init ( profile_IMG : String , profile_name : String){
    
    self._profile_IMG = profile_IMG
    self._Profile_name = profile_name
    
    }
    
    init( key : String ) {
        
        self._user_key = key
    }
//
//        if let profileImg = dictionary["ProfileImg"] as? String {
//            
//            self._profile_IMG = profileImg
//        }
//        if let username = dictionary["username"] as? String {
//            
//            self._Profile_name = username
//        }
        
    }
    
    
    

