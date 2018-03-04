//
//  L102Language.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 3/4/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
        return currentWithoutLocale
    }
    
    class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
        if lang == "en"{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    class var isRTL: Bool {
        return L102Language.currentAppleLanguage() == "ar"
    }
}

