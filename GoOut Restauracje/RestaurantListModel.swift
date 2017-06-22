//
//  RestaurantListModel.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 06/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestaurantListModel: NSObject
{
    var address:String?
    var city:String?
    var phone:String?
    var id:NSNumber?
    var color:String?
    var score:NSNumber?
    var zip:String?
    var lat:Double?
    var lng:Double?
    var name:String?
    var district:String?
    var distance:String?
    var kuponTotal:NSNumber?
    var kuponAvailable:NSNumber?
    
    var cuisineArray:NSMutableArray = NSMutableArray()

    func setObjectData(fromJson json:JSON)
    {
        distance = String(describing: json["dist"])
        address = json["address"].string
        city = json["city"].string
        phone = json["phone"].string
        id = json["id"].number
        score = json["score"].number
        zip = json["zip"].string
        lat = json["lat"].double
        lng = json["lng"].double
        name = json["name"].string
        color = json["color"].string
        district = String(describing: json["district_id"])
        for (_, subJson):(String, JSON) in json["cuisines"]
        {
            cuisineArray.add(String(describing: subJson["id"]))
        }
        kuponTotal = json["coupons"]["total"].number
        kuponAvailable = json["coupons"]["available"].number
    }
}
