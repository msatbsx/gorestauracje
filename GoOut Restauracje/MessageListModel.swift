//
//  MessageListModel.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 29/10/2016.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageListModel: NSObject
{
    var title:String?
    var id:String?
    var is_html:String?
    var is_read:String?
    var created_at:String?
    var buy_buttonText:String?
    var cuisineArray:NSMutableArray = NSMutableArray()
    
    func setObjectData(fromJson json:JSON)
    {
        title = json["title"].string
        id = json["id"].string
        is_html = json["is_html"].string
        is_read = json["is_read"].string
        created_at = json["created_at"].string
        buy_buttonText = json["buy_button"].string
    }
}

