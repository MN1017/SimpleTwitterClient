//
//  LoginViewController.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 2/28/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    ///
    /// IBOutlet
    ///
    @IBOutlet weak var LogoView: UIView!
    @IBOutlet weak var loginButtom: CustomUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///
    /// Actions
    ///
    @IBAction func LoginAction(_ sender: Any) {
        twitterLogin()
    }
}

///  MARK: Helper Methods
///
extension LoginViewController {
    
    /// use this method to login to twitter
    ///
    func twitterLogin(){
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                UserDefaults.standard.set(session?.userName, forKey: "userName")
                print(session!.userName)
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
}










