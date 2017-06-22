//
//  RealmRestaurantListObject.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 08/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import RealmSwift

class RealmRestaurantListObject: Object
{

    dynamic var address:String? = ""
    dynamic var city:String? = ""
    dynamic var phone:String? = ""
    dynamic var id:NSNumber? = 0
    dynamic var score:NSNumber? = 0
    dynamic var zip:String? = ""
    dynamic var lat:Double = 0.0
    dynamic var lng:Double = 0.0
    dynamic var name:String? = ""
    dynamic var color:String? = ""
}

class BridgeConvertingClass: NSObject
{
    func convertRealmToListModel(_ realmObject:RealmRestaurantListObject) -> RestaurantListModel
    {
        let restaurantListObject = RestaurantListModel()
        restaurantListObject.address = realmObject.address
        restaurantListObject.city = realmObject.city
        restaurantListObject.phone = realmObject.phone
        restaurantListObject.id = realmObject.id
        restaurantListObject.score = realmObject.score
        restaurantListObject.zip = realmObject.zip
        restaurantListObject.lat = realmObject.lat
        restaurantListObject.lng = realmObject.lng
        restaurantListObject.name = realmObject.name
        restaurantListObject.color = realmObject.color
        
        return restaurantListObject
    }
    
    func addListModelToRealm(_ listModelArray:NSArray)
    {
        let realm = try! Realm()
        for listMod in listModelArray
        {
            let listModel = listMod as! RestaurantListModel
            let restaurant = RealmRestaurantListObject()
            restaurant.address = listModel.address
            restaurant.city = listModel.city
            restaurant.phone = listModel.phone
            restaurant.id = listModel.id
            restaurant.score = listModel.score
            restaurant.zip = listModel.zip
            if listModel.lat != nil
            {
                restaurant.lat = listModel.lat!
            }
            if listModel.lng != nil
            {
                restaurant.lng = listModel.lng!
            }
            restaurant.name = listModel.name
            restaurant.color = listModel.color
           
            try! realm.write({
                realm.add(restaurant)
            })
        }
    }
}
