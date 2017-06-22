//
//  CityKitchenModel.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 09/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class CityKitchenModel: NSObject
{
    var name:String?
    var id:String?
    
    func setObjectData(fromJson json:JSON)
    {
        id = String(describing: json["id"])
        name = json["name"].string
    }
}

class DistrictModel: NSObject
{
    var name:String?
    var id:String?
    
    func setObjectData(fromJson json:JSON)
    {
        id = String(describing: json["id"])
        name = json["name"].string
    }

}
