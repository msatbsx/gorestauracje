//
//  FilteringController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 11/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

private var sharedInstance_:FilteringController?;

class FilteringController: NSObject
{
    var nameForSorting = ""
    
    class var sharedInstance:FilteringController
    {
        if(sharedInstance_ == nil)
        {
            sharedInstance_ = FilteringController();
        }
        
        return sharedInstance_!;
    }
    
    func sortArrayBySelectedFilters(_ array:NSArray) -> NSArray
    {
        let resultsArray = NSMutableArray()
        resultsArray.addObjects(from: array as [AnyObject])

        if AppManager.sharedInstance.colorSortingMethods.gold == false
        {
            deleteColor(resultsArray, color: "3")
        }
        if AppManager.sharedInstance.colorSortingMethods.silver == false
        {
            deleteColor(resultsArray, color: "2")
        }
        if AppManager.sharedInstance.colorSortingMethods.bronze == false
        {
            deleteColor(resultsArray, color: "1")
        }
        var arrayForSorting:NSArray = resultsArray
        if AppManager.sharedInstance.sortingMethods.city.characters.count > 0
        {
            arrayForSorting = sortArray(arrayForSorting, byCityName: AppManager.sharedInstance.sortingMethods.city)
        }
        if AppManager.sharedInstance.sortingMethods.district.characters.count > 0
        {
            arrayForSorting = sortArray(arrayForSorting, byDistrict: AppManager.sharedInstance.sortingMethods.district)
        }
        if AppManager.sharedInstance.sortingMethods.kitchen.characters.count > 0
        {
            arrayForSorting = sortArray(arrayForSorting, byKitchen: AppManager.sharedInstance.sortingMethods.kitchen)
        }
        if AppManager.sharedInstance.sortingMethods.nearest == false
        {
            arrayForSorting = sortArrayAplphabetically(arrayForSorting)
        }
        if AppManager.sharedInstance.sortingMethods.nearest == true
        {
            arrayForSorting = sortArrayByDistance(arrayForSorting)
        }
        if nameForSorting.characters.count > 0
        {
            arrayForSorting = sortArrayByName(arrayForSorting, nameString: nameForSorting)
        }
        return arrayForSorting
    }
    
    func sortArrayByName(_ array:NSArray, nameString:String) -> NSArray
    {
        let sortResultArray = NSMutableArray()
        if array.count > 1
        {
            for object in array
            {
                let restListObject = (object as! RestaurantListModel).name!
                if restListObject.lowercased().contains(nameString.lowercased())
                {
                    sortResultArray.add(object)
                }
            }
        }
        return sortResultArray
    }
    
    func deleteColor(_ array:NSMutableArray, color:String)
    {
        let indexArray = NSMutableArray()
        for object in array
        {
            if (object as! RestaurantListModel).color == color
            {
                indexArray.add(object as! RestaurantListModel)
            }
        }
        
        array.removeObjects(in: indexArray as [AnyObject])
    }
    
    func sortArray(_ array:NSArray, byCityName cityName:String) -> NSArray
    {
        if array.count > 0
        {
            let predicate = NSPredicate(format: "city = %@", cityName)
            let resultArray = array.filtered(using: predicate)
            
            return resultArray as NSArray
        }
        return array
    }

    func sortArray(_ array:NSArray, byDistrict districtName:String) -> NSArray
    {
        if array.count > 0
        {
            let predicate = NSPredicate(format: "district = %@", districtName)
            let resultArray = array.filtered(using: predicate)
            
            return resultArray as NSArray
        }
        
        return array
    }
    
    func sortArray(_ array:NSArray, byKitchen kitchenName:String) -> NSArray
    {
        let returnArray = NSMutableArray()
        if array.count > 0
        {
            for object in array
            {
                if (object as! RestaurantListModel).cuisineArray.contains(kitchenName)
                {
                    returnArray.add(object)
                }
            }
            return returnArray
        }
        return array
    }
    
    func sortArrayAplphabetically(_ array:NSArray) -> NSArray
    {
        if array.count > 0
        {
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let sortedResults: NSArray = array.sortedArray(using: [descriptor]) as NSArray
            
            return sortedResults
        }
        return array
    }
    
    func sortArrayByDistance(_ array:NSArray) -> NSArray
    {
        if array.count > 1
        {

            let sortedArray = array.sortedArray (comparator: {
                (obj1, obj2) -> ComparisonResult in
                
                let p1 = obj1 as! RestaurantListModel
                let p2 = obj2 as! RestaurantListModel
                
                let decimalNumberFirst = NSDecimalNumber(string: p1.distance)
                let decimalNumberSecond = NSDecimalNumber(string: p2.distance)
                
                let firstDistance = NSNumber(value: decimalNumberFirst.doubleValue as Double)
                let secondDistance = NSNumber(value: decimalNumberSecond.doubleValue as Double)
                let result = firstDistance.compare(secondDistance)
                return result
            })
            return sortedArray as NSArray
        }
        return array
    }
}
