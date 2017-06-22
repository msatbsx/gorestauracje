//
//  MessageDetailModel.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 29/10/2016.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageDetailModel: NSObject
{
    var title:String?
    var is_html:String?
    var is_read:String?
    var created_at:String?
    var content:String?
    var urlFromMessage:URL?
    var cuisineArray:NSMutableArray = NSMutableArray()
    
    func setObjectData(fromJson json:JSON)
    {
        title = json["title"].string
        is_html = json["is_html"].string
        is_read = json["is_read"].string
        created_at = json["created_at"].string
        urlFromMessage = json["url"].URL as URL?
        content = json["content"].string
    }
}

