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
import UIScrollView_InfiniteScroll

class FollowersViewController: UIViewController {
    
    @IBOutlet weak var followersCollectionView: UICollectionView!
    
    /// constants for network
    ///
    let network = NetworkingHelper()
    let GET_DATA_ID = "Followers"
    
    /// Contants
    ///
    let refresher = UIRefreshControl()
    
    /// Variables
    ///
    var followers:[User]!
    var cursor:String!
    var dataForRefresh:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setInitialValues()
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
        
        /// set initial values
        ///
        cursor = "0"
        followers = [User]()
        dataForRefresh = false
        
        /// set delegates and datasource
        ///
        followersCollectionView.dataSource = self
        followersCollectionView.delegate = self
        network.deleget = self
        
        setRegisterCollectionViewCells()
        setCollectionViewFlowLayout()
        
        /// add selector to handle device rotated action
        ///
        NotificationCenter.default.addObserver(self, selector: #selector(FollowersViewController.deviceRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        /// add refresher to followers collection view
        ///
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        followersCollectionView.addSubview(refresher)
        
        /// add infinite scroll to followers collection view
        ///
        followersCollectionView.addInfiniteScroll{ (collectionView) -> Void in
            self.getDataFromServer()
        }
        
        followersCollectionView.beginInfiniteScroll(true)
    }
    
    /// use this method to refresh followers collection view
    ///
    @objc func refresh(){
        dataForRefresh = true
        getDataFromServer()
    }
    
    /// use this method to register customs CollectionView cells
    ///
    func setRegisterCollectionViewCells(){
        /// register followers list cell to be used in portrait
        ///
        var nib = UINib(nibName: "FollowersListCell", bundle:nil)
        self.followersCollectionView.register(nib, forCellWithReuseIdentifier: "FollowersListCell")
        
        /// register followers grid cell to be used in landscape
        ///
        nib = UINib(nibName: "FollowersGridCell", bundle:nil)
        self.followersCollectionView.register(nib, forCellWithReuseIdentifier: "FollowersGridCell")
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
    
    /// use this method to set cached Followers data
    ///
    func setCachedFollowersData(withData data:JSON) {
        UserDefaults.standard.set(data.rawString()!, forKey: "CachedFollowers")
    }
    
    /// use this method to get cached Followers data
    ///
    func getCachedFollowersData() -> JSON{
        return JSON.init(parseJSON: UserDefaults.standard.value(forKey: "CachedFollowers")  as! String)
    }
    
    /// use this method to update FollowersCollectionView data
    ///
    func updateFollowersCollectionView(withData followersArray:[JSON]){
        
        /// remove old data if user perform refresh action and reset dataForRefresh values
        ///
        if dataForRefresh {
            
            /// create indexPath to be used to delete old data from followersCollectionView
            ///
            let followersCount = followers.count
            let (start, end) = (0, followersCount)
            let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
            
            followers.removeAll()
            
            /// delete old data from followersCollectionView
            ///
            followersCollectionView.performBatchUpdates({ () -> Void in
                self.followersCollectionView.deleteItems(at: indexPaths)
                }
            )
            
            dataForRefresh = false
        }
        
        /// create indexPath to be used to add new data to followersCollectionView
        ///
        let followersCount = followers.count
        let (start, end) = (followersCount, followersArray.count + followersCount)
        let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
        
        /// add new data to followersArray
        ///
        for i in 0..<followersArray.count{
            followers.append(User(fromJson: followersArray[i]))
        }
        
        /// add new data to followersCollectionView
        ///
        followersCollectionView.performBatchUpdates({ () -> Void in
            self.followersCollectionView.insertItems(at: indexPaths)
            }
        )
        
        followersCollectionView.reloadData()
    }
    
    /// use this method to finish loading animation
    ///
    func finishLoading(){
        refresher.endRefreshing()
        followersCollectionView.finishInfiniteScroll()
    }
    
    /// use this method to update followers data
    ///
    func updateFollowersData(withJson json: JSON){
        let next_cursor = json["next_cursor_str"].stringValue
        print(cursor)
        print(next_cursor)
        if cursor != next_cursor || next_cursor != "0"{
            cursor = next_cursor
            let followersArray = json["users"].arrayValue
            updateFollowersCollectionView(withData: followersArray)
            setCachedFollowersData(withData: json)
        }
        dataForRefresh = false
        finishLoading()
    }
}



/// MARK : Collection View
///
extension FollowersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return followers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if UIDevice.current.orientation.isLandscape == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersGridCell", for: indexPath) as! FollowersGridCollectionViewCell
            cell.set(user: followers[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowersListCell", for: indexPath) as! FollowersListCollectionViewCell
            cell.set(user: followers[indexPath.row])
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
}


/// MARK: - Networking
///
extension FollowersViewController: NetworkingHelperDeleget {
    
    func getDataFromServer() {
        var param:[String: String] = ["count": "10"]
        if cursor != "0" && dataForRefresh == false{
            param["cursor"] = cursor
        }
        print(param)
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
        let json = getCachedFollowersData()
        updateFollowersData(withJson: json)
    }
}



/// MARK: - Navigation
///
extension FollowersViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let userProfileViewController:ProfileViewController = segue.destination as! ProfileViewController
            if let selectedIndexPath = followersCollectionView.indexPathsForSelectedItems?[0] {
            userProfileViewController.user = followers[selectedIndexPath.row]
            }
        }
    }
}
