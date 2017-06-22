//
//  RealmCity.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 09/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import RealmSwift

class RealmCity: Object
{
    dynamic var id:NSNumber = 0
    dynamic var name:String?
}

class CityConvertingClass: NSObject
{
    func getCityListArray() -> NSArray
    {
        let cityModelArray = NSMutableArray()
        var cityListRealmArray:Array<RealmCity>?
        let realm = try! Realm()
        let result = realm.objects(RealmCity.self)
        if result.count > 0
        {
            cityListRealmArray = Array(result)
        }
        if cityListRealmArray != nil
        {
            for realmObject in cityListRealmArray!
            {
                let cityListObject = CityListModel()
                cityListObject.id = realmObject.id
                cityListObject.name = realmObject.name
                cityModelArray.add(cityListObject)
            }
        }
        return cityModelArray
    }
    
    func addCityModelToRealm(_ cityModelArray:NSArray)
    {
        let realm = try! Realm()
        for citMod in cityModelArray
        {
            let cityModel = citMod as! CityListModel
            let city = RealmCity()
            city.id = cityModel.id!
            city.name = cityModel.name
            
            try! realm.write({
                realm.add(city)
            })
        }
    }
}
