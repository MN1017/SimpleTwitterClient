//
//  FollowersViewController.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 3/1/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON

class FollowersViewController: UIViewController {
    
    @IBOutlet weak var followersCollectionView: UICollectionView!
    
    /// constants for network
    ///
    let network = NetworkingHelper()
    let GET_DATA_ID = "Followers"
    
    /// Variables
    ///
    var followers:[User]!
    
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
}



/// MARK : Helper Methods
///
extension FollowersViewController {
    
    /// use this method to set initial values
    ///
    func setInitialValues(){
        
        followers = [User]()
        followersCollectionView.dataSource = self
        followersCollectionView.delegate = self
        network.deleget = self
        setRegisterCollectionViewCells()
        setCollectionViewFlowLayout()
        
        /// add selector to handle device rotated action
        ///
        NotificationCenter.default.addObserver(self, selector: #selector(FollowersViewController.deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    /// use this method to register customs CollectionView cells
    ///
    func setRegisterCollectionViewCells(){
        let nib = UINib(nibName: "FollowersListCell", bundle:nil)
        self.followersCollectionView.register(nib, forCellWithReuseIdentifier: "FollowersListCell")
    }
    
    /// use this method to set collection view flow layout to make cell height dependent on content height
    ///
    func setCollectionViewFlowLayout(){
        if let flowLayout = followersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
    }
    
    /// use this method to handle device rotated action
    ///
    @objc func deviceRotated() {
        followersCollectionView.reloadData()
    }
    
    /// use this method to update followers data
    ///
    func updateFollowersData(withJson json: JSON){
        
        let followersArray = json["users"].arrayValue
        for i in 0..<followersArray.count{
            followers.append(User(fromJson: followersArray[i]))
        }
        followersCollectionView.reloadData()
    }
}



/// MARK : Collection View
///
extension FollowersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return followers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersListCell", for: indexPath) as! FollowersListCollectionViewCell
        cell.set(user: followers[indexPath.row])
        return cell
    }
}


/// MARK: - Networking
extension FollowersViewController: NetworkingHelperDeleget {
    
    func getDataFromServer() {
        var param:[String: String] = ["count": "10"]
        network.connectTo(api: ApiNames.getFollowers ,withParameters: param , andIdentifier: GET_DATA_ID)
    }
    
    func dataHandler(fromJson json:JSON) {
        updateFollowersData(withJson: json)
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
