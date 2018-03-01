//
//  NetworkingHelper.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 2/28/18.
//  Copyright © 2018 Intcore. All rights reserved.
//


import UIKit
import TwitterKit
import SwiftyJSON

struct HTTPMethod
{
    static let get = "GET"
    static let post = "POST"
}

struct ResponseError
{
    static let invalidUserID = "invalid userID"
    static let responseNotJson = "response not json"
    static let noData = "no data"
    static let noConnection = "no connection"
}

public protocol NetworkingHelperDeleget:NSObjectProtocol {
    func onHelper(getData data:JSON,fromApiName name:String , withIdentifier id:String)
    func onHelper(getError error:String,fromApiName name:String , withIdentifier id:String)
}

class NetworkingHelper: NSObject {
    
    /// MARK: Variables
    
    /// the network deleget , you must set before calling any method it to get the response.
    ///
    weak var deleget:NetworkingHelperDeleget?
    
    /// MARK: Methods
    
    /// use this method to connect to any twitter webservice to send/get data
    ///
    /// - Parameters:
    ///   - api: the api name that you want to send/get data , and should be variable in ApiNames struct
    ///   - parm: the parameters that you want to send to the api , default value is ni
    ///   - id: the id of the request to get it back in the deleget , it can be any string , default value is empty string
    func connectTo(api:String , withParameters parm:[String:Any]? = nil , andIdentifier id:String = "") {
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let twitterClient = TWTRAPIClient(userID: userID)
            var clientError : NSError?
            let request = twitterClient.urlRequest(withMethod: HTTPMethod.get, url: api, parameters: parm,  error: &clientError)
            twitterClient.sendTwitterRequest(request) { (response, responseData, connectionError) -> Void in
                self.handleResponse(responseData: responseData, connectionError: connectionError , forApi: api, andIdentifier: id)
            }
        }else {
            self.deleget?.onHelper(getError: ResponseError.invalidUserID, fromApiName: api, withIdentifier: id)
        }
    }
    
    
    /// this method handle the response to check if the request has succeeded or not
    ///
    /// - Parameters:
    ///   - api: the api name that you want to send/get data , and should be variable in ApiNames struct
    ///   - response: the response of api
    ///   - id: the id of the request to get it back in the deleget , it can be any string , default value is empty string
    fileprivate func handleResponse(responseData:Data? , connectionError:Error?, forApi api:String , andIdentifier id:String){
        print("Response from api : \(api) , with Identifier : \(id)")
        print(responseData ?? "No Data")
        
        if connectionError != nil {
            print("Error: \(String(describing: connectionError?.localizedDescription))")
            if isConnectedToNetwork() == true {
                self.deleget?.onHelper(getError: ResponseError.responseNotJson, fromApiName: api, withIdentifier: id)
            }else {
                self.deleget?.onHelper(getError: ResponseError.noConnection, fromApiName: api, withIdentifier: id)
            }
            return
        }
        
        if responseData == nil {
            self.deleget?.onHelper(getError: ResponseError.noData, fromApiName: api, withIdentifier: id)
        }else {
            self.deleget?.onHelper(getData: JSON(data: responseData!), fromApiName: api, withIdentifier: id)
        }
    }
}

