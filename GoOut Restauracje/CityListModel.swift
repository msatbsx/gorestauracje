//
//  CityListModel.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 09/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class CityListModel: NSObject
{
    var name:String?
    var id:NSNumber?
    
    func setObjectData(fromJson json:JSON)
    {
        id = json["id"].number
        name = json["name"].string
    }
}
