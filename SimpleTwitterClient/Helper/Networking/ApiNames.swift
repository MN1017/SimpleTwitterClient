//
//  ApiNames.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 2/28/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import Foundation

struct ApiNames {
    
    static let BaseURL = "https://api.twitter.com/1.1/"
    static let getFollowers = BaseURL + "followers/list.json"
    static let getUserProfile = BaseURL + "statuses/user_timeline.json"
    
}
