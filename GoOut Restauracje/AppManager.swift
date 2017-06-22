//
//  AppManager.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 10/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
private var sharedInstance_:AppManager?;

class AppManager: NSObject
{
    var list:NSArray = NSArray()
    var cityList:NSArray = NSArray()
    var kitchenList:NSArray = NSArray()
    var districtList:NSArray = NSArray()
    var cityId:NSNumber = 0
    var restaurantIdBuyed:Int?
    var timer:Timer?
    var timerCount = 0;
    var isNewUser = false
    var hasUnreadMessages = false
    var requestFinished = true
    var noOfUnreadMessages:Int?
    var forceReloadRestaurantList = false
    var forceOpenMessagesView = false
    
    class var sharedInstance:AppManager
    {
        if(sharedInstance_ == nil)
        {
            sharedInstance_ = AppManager();
        }
        
        return sharedInstance_!;
    }
    var sortingMethods:(city:String, district:String, kitchen:String, nearest:Bool, kitchenName:String, districtName:String, locationSorting:String, name:String) = ("", "", "", true, "", "", "Według lokalizacji", "")
    var colorSortingMethods:(bronze:Bool, silver:Bool, gold:Bool) = (true, true, true)
    var kupons:(totalKupons:NSNumber?, availableKupons:NSNumber?) = (nil, nil)
    
    var hideDistance = false
    
    func  sortingMethodsChanged() -> Bool
    {
        if sortingMethods.city != ""
        {
            return true
        }
        if sortingMethods.district != ""
        {
            return true
        }
        if sortingMethods.kitchen != ""
        {
            return true
        }
        if sortingMethods.nearest == false
        {
            return true
        }
        if colorSortingMethods.bronze == false
        {
            return true
        }
        if colorSortingMethods.gold == false
        {
            return true
        }
        if colorSortingMethods.silver == false
        {
            return true
        }
        if sortingMethods.name != ""
        {
            return true
        }
        return false
    }
    
    func resetFilters()
    {
        sortingMethods.kitchen = ""
        sortingMethods.district = ""
        sortingMethods.nearest = true
        sortingMethods.kitchenName = ""
        sortingMethods.districtName = ""
        sortingMethods.locationSorting = "Według lokalizacji"
        sortingMethods.name = ""
        FilteringController.sharedInstance.nameForSorting = ""
        colorSortingMethods = (true, true, true)
    }
}
