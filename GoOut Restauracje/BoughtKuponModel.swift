//
//  BoughtKuponModel.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 16/10/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class BoughtKuponModel: NSObject
{
    var code:String?
    var qty:NSNumber?
    var stamp:String?
    
    var restaurantAddress:String?
    var restaurantId:NSNumber?
    var restaurantName:String?
    
    func setObjectData(fromJson json:JSON)
    {
        code = json["code"].string
        qty = json["qty"].number
        stamp = json["stamp"].string
        let resturantData = json["restaurant"]
        restaurantAddress = resturantData["address"].string
        restaurantId = resturantData["id"].number
        restaurantName = resturantData["name"].string
    }
}

class PackagesForBuy: NSObject
{
    var packdescription:String?
    var id:NSNumber?
    var name:String?
    var price:NSNumber?
    var active:Bool?
    
    func setObjectData(fromJson json:JSON)
    {
        packdescription = json["description"].string
        id = json["id"].number
        name = json["name"].string
        price = json["price"].number
        active = json["is_active"].bool
    }

    
}
