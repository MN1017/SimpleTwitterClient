//
//  ProfileViewController.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 3/4/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit
import SwiftyJSON
import TwitterKit

class ProfileViewController: UIViewController {

    /// IBOutlet
    ///
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: CustomUIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    /// constants for network
    ///
    let network = NetworkingHelper()
    let GET_DATA_ID = "Profile"
    
    /// variables for segue
    ///
    var user:User!
    
    /// Variables
    ///
    var tweets:[Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setInitialValues()
        getDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// IBAction
    ///
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



/// MARK : Helper Methods
///
extension ProfileViewController: TWTRTweetViewDelegate {
    
    /// use this method to set initial values
    ///
    func setInitialValues(){
        
        tweets = [Any]()
        
        setUserInfoData()
        
        /// set delegates 
        ///
        network.deleget = self
        
        profileTableView.backgroundColor = UIColor.lightGray
        
        /// set automatic Height for tableView
        ///
        profileTableView.estimatedRowHeight = 150
        profileTableView.rowHeight = UITableViewAutomaticDimension
        
        setRegisterTableViewCells()
    }
    
    func setUserInfoData(){
        userNameLabel.text = user.name
        userHandleLabel.text = user.userName
        profileImageView.kf.setImage(with: URL(string: user.profileImageURL))
        backgroundImageView.kf.setImage(with: URL(string: user.backgroundImageURL))
    }
    
    /// use this method to register twitter tweet cells
    ///
    func setRegisterTableViewCells(){
        /// register Tweeter cell
        ///
        profileTableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: "TweetsCell")
    }
    
    /// use this method to set tweet cell design
    ///
    func setTweetCellDesign(cell: TWTRTweetTableViewCell){
        cell.tweetView.showActionButtons = true
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 0
        cell.clipsToBounds = true
    }
    
}



/// MARK : Table View
///
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetsCell")! as! TWTRTweetTableViewCell
        cell.tweetView.delegate = self
        let tweet = tweets[indexPath.row]
        cell.configure(with: tweet as! TWTRTweet)
        setTweetCellDesign(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}



/// MARK: - Networking
///
extension ProfileViewController: NetworkingHelperDeleget {
    
    func getDataFromServer() {
        let param:[String: Any] = [ "count":"10", "id": "\(user.id)" ]
        network.connectTo(api: ApiNames.getUserProfile ,withParameters: param , andIdentifier: GET_DATA_ID)
    }
    
    func dataHandler(fromJson json:JSON) {
        tweets = TWTRTweet.tweets(withJSONArray: json.arrayObject! as! [[String : Any]])
        profileTableView.reloadData()
    }
    
    func onHelper(getData data: JSON, fromApiName name: String, withIdentifier id: String) {
        if id == GET_DATA_ID {
            dataHandler(fromJson: data)
        }
    }
    
    func onHelper(getError error: String, fromApiName name: String, withIdentifier id: String) {
        print(error)
    }
}

