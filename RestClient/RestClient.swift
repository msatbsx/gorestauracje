//
//  RestClient.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

//import Alamofire
import FCUUID
import SwiftyJSON

private var sharedInstance_:RestClient?;

class RestClient: NSObject
{
    class var sharedInstance:RestClient
    {
        if(sharedInstance_ == nil)
        {
            sharedInstance_ = RestClient();
        }
        
        return sharedInstance_!;
    }
    
    func registerUsertokenForNotifications(token:String, completion:@escaping(_ success:Bool) -> Void)
    {
        let tokenRegisteringLink = RestConstants.registeringTokenLink + token
        var request = URLRequest(url: URL(string:tokenRegisteringLink)!)
        request.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    completion(true)
                }
            }
            else
            {
                completion(false)
            }
        }
        task.resume()
    }
    
    //MARK: - All restaurants near user
    
    func getRestaurantsListNearUser(_ latitude:Double, longitude:Double, completion:@escaping (_ restaurantList:NSArray, _ succes:Bool) -> Void)
    {
        if AppManager.sharedInstance.requestFinished == true
        {
            AppManager.sharedInstance.requestFinished = false
            let jsonResponceArray = NSMutableArray()
            let nearUserRestaurantsLinkString = RestConstants.listUserLocationFirstPart + String(latitude) + RestConstants.listUserLocationSecondPart + String(longitude)
            //let nearUserRestaurantsLinkString = RestConstants.listUserLocationFirstPart + "52.236056" + RestConstants.listUserLocationSecondPart + "21.011885"
            var requst = URLRequest(url:URL(string: nearUserRestaurantsLinkString)!)
            requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
            requst.setValue("application/json", forHTTPHeaderField: "Accept")
            requst.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
                
                if responceData != nil
                {
                    let json = JSON(data: responceData!)
                    if json["status"]["code"] == "OK"
                    {
                        let jsonArray = json["items"]
                        for (_, subJson):(String, JSON) in jsonArray
                        {
                            let restaurantListObject = RestaurantListModel()
                            restaurantListObject.setObjectData(fromJson: subJson)
                            jsonResponceArray.add(restaurantListObject)
                        }
                        AppManager.sharedInstance.requestFinished = true
                        completion(jsonResponceArray, true)
                    }
                }
                else
                {
                    AppManager.sharedInstance.requestFinished = true
                    completion([], false)
                }
            }
            task.resume()
        }
    }

    //MARK: - Restaurant description
    
    func getRestaurantsDescription(_ restaurantId:NSNumber,completion:@escaping (_ restaurantDesc:RestaurantDescription?, _ succes:Bool) -> Void)
    {
        let requestLink = RestConstants.restaurantLink + "\(restaurantId)"
      
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    let restaurantDescriptionObject = RestaurantDescription()
                    restaurantDescriptionObject.setObjectData(fromJson: json)
                    completion(restaurantDescriptionObject, true)
                }
            }
            else
            {
                completion(nil, false)
            }
        }
        task.resume()
     }

    //MARK: - City list
    
    func getCityList(_ completion:@escaping (_ cityListArray:NSArray, _ succes:Bool) -> Void)
    {
        let listArray = NSMutableArray()
        
        var requst = URLRequest(url:URL(string: RestConstants.cityList)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    let lastJson = json["items"]
                    //   adddddd loooop if neeeeeddddeeedd =================================
                    let city = CityListModel()
                    city.setObjectData(fromJson: lastJson)
                    listArray.add(city)
                    completion(listArray, true)
                }
            }
            else
            {
                 completion(NSArray(), false)
            }
        }
        task.resume()
    }

    //MARK: - Kitchen type for city
    
    func getKitchenType(_ cityId:NSNumber,completion:@escaping (_ districtNameArray:NSArray, _ kitchenNameArray:NSArray, _ succes:Bool) -> Void)
    {
        let kitchenMutableArray = NSMutableArray()
        let districtMutableArray = NSMutableArray()
        
        var requst = URLRequest(url:URL(string: RestConstants.kitchenType + "\(cityId)")!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    let districtJsonArray = json["districts"]
                    let kitchenJsonArray = json["cuisines"]
                    for (_, subJson):(String, JSON) in districtJsonArray
                    {
                        let districtModelObject = DistrictModel()
                        districtModelObject.setObjectData(fromJson: subJson)
                        districtMutableArray.add(districtModelObject)
                    }
                    for (_, subJson):(String, JSON) in kitchenJsonArray
                    {
                        let kitchenModelObject = CityKitchenModel()
                        kitchenModelObject.setObjectData(fromJson: subJson)
                        kitchenMutableArray.add(kitchenModelObject)
                    }
                    
                    completion(districtMutableArray, kitchenMutableArray, true)
                }
            }
            else
            {
                completion(NSArray(), NSArray(), false)
            }
        }
        task.resume()
    }

    //MARK: Kupons
    
    
    func getUserKuponsCount(_ completion:@escaping (_ totalKupons:NSNumber?, _ availableKupons:NSNumber?, _ daysToEnd:NSNumber?, _ succes:Bool) -> Void)
    {
        var requst = URLRequest(url:URL(string: RestConstants.userKuponsLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    let totalKup = json["total"].number
                    let availableKup = json["available"].number
                    let newUser = json["new_user"].string
                    let daysToEnd = json["days"].number
                    if newUser == "1"
                    {
                        AppManager.sharedInstance.isNewUser = true
                    }
                    else
                    {
                        AppManager.sharedInstance.isNewUser = false
                    }
                    
                    
                    completion(totalKup, availableKup, daysToEnd, true)
                }
            }
            else
            {
                completion(nil, nil, nil, false)
            }
        }
        task.resume()
    }

    
    //MARK: Device identifier
    
    func getDeviceInfiniteId() -> String
    {
        return  FCUUID.uuidForDevice()
    }
    
    func useKuponFor(_ restaurantId:Int, kuponcount:Int,  completion:@escaping (_ success:Bool) -> Void)
    {
        let requestLink = RestConstants.restaurantLink + "\(restaurantId)?use=\(kuponcount)"
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] != nil && json["status"]["code"] == "OK"
                {
                    completion(true)
                }
            }
            else
            {
                completion(false)
            }
        }
        task.resume()
    }
    
    func rateRestaurantBy(_ restaurantId:Int, kitchen:Int, service:Int, design:Int,  completion:@escaping (_ success:Bool) -> Void)
    {
        let requestLink = RestConstants.restaurantLink + "\(restaurantId)?scorekitchen=\(kitchen)&scoreservice=\(service)&scoredesign=\(design)"
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    completion(true)
                }
            }
            else
            {
                completion(false)
            }
        }
        task.resume()
    }

    
    func getKuponHistory(_ completion:@escaping (_ historyArray:NSArray, _ success:Bool) -> Void)
    {
        let historyArray = NSMutableArray()
        let requestLink = RestConstants.getUserKuponsHistoryLink
        
        
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    if (json["history"].array?.count)! > 0
                    {
                        for (_, subJson):(String, JSON) in json["history"]
                        {
                            let kuponHistoryObject = BoughtKuponModel()
                            kuponHistoryObject.setObjectData(fromJson: subJson)
                            historyArray.add(kuponHistoryObject)
                        }
                    }
                    completion(historyArray,true)
                }
            }
            else
            {
                completion(NSArray(),false)
            }
        }
        task.resume()
    }
    
    func getPackagesInfo(_ completion:@escaping (_ packagesArray:NSArray, _ success:Bool) -> Void)
    {
        let packArray = NSMutableArray()
        let requestLink = RestConstants.getPackagesBundlesInfoLink
        
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    if (json["items"].array?.count)! > 0
                    {
                        for (_, subJson):(String, JSON) in json["items"]
                        {
                            let package = PackagesForBuy()
                            package.setObjectData(fromJson: subJson)
                            packArray.add(package)
                        }
                        completion(packArray,true)
                    }
                    else
                    {
                        completion(NSArray(),false)
                    }
                }
            }
            else
            {
                completion(NSArray(),false)
            }
        }
        task.resume()
    }
    
    func getInfoHowToBuyCoupons(_ completion:@escaping (_ infoText:String?, _ shopUrl:String?, _ succes:Bool) -> Void)
    {
        let requestLink = RestConstants.getPackagesBundlesInfoLink
        var reqeust = URLRequest(url:URL(string: requestLink)!)
        reqeust.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        reqeust.setValue("application/json", forHTTPHeaderField: "Accept")
        reqeust.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: reqeust) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    let infoText = json["info_text"].string
                    let shopUrl = json["shop_url"].string
                    
                    completion(infoText, shopUrl, true)
                }
            }
            else
            {
                completion(nil, nil,false)
            }
        }
        task.resume()
    }
    
    func getAppInfo(_ completion:@escaping (_ text:String, _ success:Bool) -> Void)
    {
        let requestLink = RestConstants.getAboutAppInfoLink
        
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    completion(json["text"].string! ,true)
                }
            }
            else
            {
                completion("", false)
            }
        }
        task.resume()
    }
    
    func getAppRules(_ completion:@escaping (_ text:String, _ success:Bool) -> Void)
    {
        let requestLink = RestConstants.getAppRulesLink
        
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"

        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    completion(json["text"].string! ,true)
                }
            }
            else
            {
                completion("", false)
            }
        }
        task.resume()
    }


    func registerKuponCode(_ kuponCode:String, _ email:String, completion:@escaping (_ success:Bool, _ message:String) -> Void)
    {
        let requestLink = RestConstants.registerCodeLink + kuponCode + "&email=" + email
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"
        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    if json["status"]["message"].string != nil{
                        completion(true, json["status"]["message"].string!)
                    }
                    else{
                        completion(true, "")
                    }
                    
                }
                else if json["status"]["message"].string != nil
                {
                    completion(false, json["status"]["message"].string!)
                }
                else
                {
                    completion(false, "błąd sysytemu")
                }
            }
            else
            {
                
                completion(false, "")
            }
        }
        task.resume()
    }
    
    func validateInapp(_ kuponCode:String,  completion:@escaping (_ success:Bool, _ message:String) -> Void)
    {
        let requestLink = RestConstants.registerCodeLink + kuponCode
        var requst = URLRequest(url:URL(string: requestLink)!)
        
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if json["status"]["code"] == "OK"
                {
                    completion(true, "")
                }
                else
                {
                    completion(false, json["status"]["message"].string!)
                }
            }
            else
            {
                
                completion(false, "")
            }
        }
        task.resume()
    }
    
    func getUserMessages(completion:@escaping (_ packagesArray:NSArray, _ success:Bool) -> Void)
    {
        let messagesArray = NSMutableArray()
        let requestLink = RestConstants.getUserMessagesRequestLink
        var requst = URLRequest(url:URL(string: requestLink)!)
        
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                if let unread = json["unread"].number
                {
                    
                    if unread.intValue > 0
                    {
                        AppManager.sharedInstance.hasUnreadMessages = true
                    }
                    else
                    {
                        AppManager.sharedInstance.hasUnreadMessages = false
                    }
                    AppManager.sharedInstance.noOfUnreadMessages = unread as Int?
                    let application = UIApplication.shared
                    application.applicationIconBadgeNumber = AppManager.sharedInstance.noOfUnreadMessages!
                }
                
                if json["items"] != nil && (json["items"].array?.count)! > 0
                {
                    for (_, subJson):(String, JSON) in json["items"]
                    {
                        let messageListObj = MessageListModel()
                        messageListObj.setObjectData(fromJson: subJson)
                        messagesArray.add(messageListObj)
                    }
                    completion(messagesArray,true)
                }
                else
                {
                    completion(NSArray(),false)
                }
            }
            else
            {
                completion(NSArray(),false)
            }
        }
        task.resume()
    }
    
    
    
    func getDetailMessages( messageId:String, completion:@escaping (_ detailMessageObject:MessageDetailModel?, _ success:Bool) -> Void)
    {
        let requestLink = RestConstants.getDetailMessageRequestLink + messageId
        var requst = URLRequest(url:URL(string: requestLink)!)
        
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                let detMess = MessageDetailModel()
                detMess.setObjectData(fromJson: json)
                completion(detMess, true)
                
            }
            else
            {
                completion(nil, false)
            }
        }
        task.resume()
    }
    
    func confirmMessageIsRead( messageId:String, completion:@escaping (_ detailMessageObject:MessageDetailModel?, _ success:Bool) -> Void)
    {
        let requestLink = RestConstants.getDetailMessageRequestLink + messageId + "?read=1"
        var requst = URLRequest(url:URL(string: requestLink)!)
        requst.setValue(getDeviceInfiniteId(), forHTTPHeaderField: "X-Auth")
        requst.setValue("application/json", forHTTPHeaderField: "Accept")
        requst.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: requst) { (responceData, responce, error) in
            
            if responceData != nil
            {
                let json = JSON(data: responceData!)
                let detMess = MessageDetailModel()
                detMess.setObjectData(fromJson: json)
                completion(detMess, true)
                
            }
            else
            {
                completion(nil, false)
            }
        }
        task.resume()
    }
    
}

struct RestConstants
{
    static let userKuponsLink = "https://api.codelabs.euuser/coupons"
    static let restaurantLink = "https://api.codelabs.eurestaurant/"
    static let listUserLocationFirstPart = "https://api.codelabs.eulocation?lat="
    static let listUserLocationSecondPart = "&lng="
    static let cityList = "https://api.codelabs.eucity"
    static let kitchenType = "https://api.codelabs.eucity/"
    static let imagesBaseLink = "https://api.codelabs.eures/images/"
    static let getUserKuponsHistoryLink = "https://api.codelabs.euuser/history"
    static let getPackagesBundlesInfoLink = "https://api.codelabs.euinfo/bundles"
    static let getAboutAppInfoLink = "https://api.codelabs.euinfo/about"
    static let getAppRulesLink = "https://api.codelabs.euinfo/legal"
    static let registeringTokenLink = "https://api.codelabs.euuser?fb_token="
    static let registerCodeLink = "https://api.codelabs.eupurchase/redeem?code="
    static let validateInnappRequestLink = "https://api.codelabs.eupurchase/inapp"
    static let getUserMessagesRequestLink = "https://api.codelabs.euuser/message"
    static let getDetailMessageRequestLink = "https://api.codelabs.euuser/message/"
}
