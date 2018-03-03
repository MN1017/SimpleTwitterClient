//
//  User.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 3/3/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import Foundation


import Foundation
import SwiftyJSON

class User {
    
    /// Variables
    ///
    private var _id:Int64?
    private var _name:String?
    private var _userName:String?
    private var _bio:String?
    private var _profileImageURL:String?
    
    
    /// Getters
    ///
    public var id:Int64 {
        if self._id == nil{
            self._id = 0
        }
        return self._id!
    }
    
    public var name:String {
        if self._name == nil{
            self._name = ""
        }
        return self._name!
    }
    
    public var userName:String {
        if self._userName == nil{
            self._userName = ""
        }
        return self._userName!
    }
    
    public var bio:String {
        if self._bio == nil{
            self._bio = ""
        }
        return self._bio!
    }
    
    public var profileImageURL:String {
        if self._profileImageURL == nil{
            self._profileImageURL = ""
        }
        return self._profileImageURL!
    }
    
    /// Constructors
    ///
    init(name: String?, userName: String?, bio: String?, profileImageURL: String?){
        self._name = name
        self._userName = userName
        self._bio = bio
        self._profileImageURL = profileImageURL
    }
    
    init(fromJson json:JSON){
        self._id = json["id"].int64Value
        self._name = json["name"].stringValue
        self._userName = "@" + json["screen_name"].stringValue
        self._bio = json["description"].stringValue
        self._profileImageURL = json["profile_image_url_https"].stringValue
    }
    
}

