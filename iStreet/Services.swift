//
//  Services.swift
//  iStreet
//
//  Created by Abdulaziz  Almohsen on 10/3/16.
//  Copyright © 2016 Abdulaziz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


private var _URL_Base = FIRDatabase.database().reference()


class Services {
    
    
    fileprivate var _Ref_URL = _URL_Base
    
    fileprivate var _ref_post = _URL_Base.child("Post")
    fileprivate var _ref_user = _URL_Base.child("user")

    
    static let ds = Services()
    
    // this the reference in the info plist
    
    var ref_post : FIRDatabaseReference {
        return _ref_post
    }
    var ref_users : FIRDatabaseReference {
        return _ref_user
    }
    
    
    
    var Current_user  : FIRDatabaseReference {
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String
        let user = FIRDatabase.database().reference().child("user").child(byAppendingPath: uid!)
        return user
    }
    
    func CreateFirebaseUser ( _ uid : String , user : Dictionary < String , String >){
        
        ref_users.child(uid).setValue(user)
    }
}
