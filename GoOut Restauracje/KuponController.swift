//
//  KuponController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 25/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

class KuponController: NSObject
{
    func getCurrentDateString() -> String!
    {
        var dateString = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateString = formatter.string(from: Date())
        return dateString
    }
    
    func getCurrentTimeString() -> String!
    {
        var timeString = ""
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
        let hour = components.hour
        let minutes = components.minute
        var hourString = ""
        var minutesString = ""
        if hour! < 10
        {
            hourString = "0\(hour!)"
        }
        else
        {
            hourString = "\(hour!)"
        }
       
        
        if minutes! < 10
        {
            minutesString = "0\(minutes!)"
        }
        else
        {
            minutesString = "\(minutes!)"
        }
        
        timeString = "\(hourString) : \(minutesString)"
        
        return timeString
    }
}
