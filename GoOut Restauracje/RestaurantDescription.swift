//
//  RestaurantDescription.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 06/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestaurantDescription: NSObject
{
    var name:String?
    var address:String?
    var hours1:String?
    var hours2:String?
    var hours3:String?
    var phone1:String?
    var phone2:String?
    var about_pl:String?
    var link:String?
    var district:String?
    var lat:String?
    var lng:String?
    var id:String?
    
    var kitchenScore:NSNumber?
    var wystrojScore:NSNumber?
    var obslugaScore:NSNumber?
    
    var kuponTotal:NSNumber?
    var kuponAvailable:NSNumber?
    
    var cuisineArray:NSMutableArray = NSMutableArray()
    var photosArray:NSMutableArray = NSMutableArray()
    
    func setObjectData(fromJson json:JSON)
    {
        cuisineArray = NSMutableArray()
        photosArray = NSMutableArray()
        id = json["id"].string
        address = json["address"].string
        name = json["name"].string
        kitchenScore = json["score_kitchen"].number
        wystrojScore = json["score_design"].number
        obslugaScore = json["score_service"].number
        district = json["district"].string
        hours1 = json["hours1"].string
        hours2 = json["hours2"].string
        hours3 = json["hours3"].string
        phone1 = json["phone1"].string
        phone2 = json["phone2"].string
        about_pl = json["about_pl"].string
        link = json["www"].string
        lat = json["lat"].string
        lng = json["lng"].string
        
        kuponTotal = json["coupons"]["total"].number
        kuponAvailable = json["coupons"]["available"].number

            for (_, subJson):(String, JSON) in json["cuisines"]
            {
                let cuisines = CuisinesObject()
                cuisines.cuisineId = String(describing: subJson["id"])
                cuisines.cuisineName = subJson["name"].string!
                cuisineArray.add(cuisines)
            }
            for (index, _):(String, JSON) in json["photos"]
            {
                photosArray.add(json["photos"][Int(index)!].string!)
            }
    }
}

class CuisinesObject: NSObject
{
    var cuisineId:String?
    var cuisineName:String?
    
}
