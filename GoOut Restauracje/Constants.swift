//
//  Constants.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 27/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

class Constants: NSObject
{
}

struct ConstantsStruct
{
//    static let kShadowName = "shadowNew"
    static let kBlenda2Ciemny = "blenda2ciemny"
    static let kBlendaZloto2 = "blendaZloto2"
    static let kBlendaSrebro2 = "blendaSrebro2"
    static let kblendaBraz2 = "blendaBraz2"
    static let whatIsGoout1 = "whatIs1"
    static let whatIsGoout2 = "whatIs2"
    static let whatIsGoout3 = "whatIs3"
    static let whatIsGoout4 = "whatIs4"
    
    
    
    static let kBackgroundName = "background"
    
    
    struct Buttons
    {
        static let backButton = "arrow"
        static let messageButton = "message"
        static let starNOTSelectedButton = "starNotSelected"
        static let starSelectedButton = "starSelected"
        static let statusButton = "status"
    
        static let checkBoxOn = "checkboxOn"
        static let checkBoxOff = "checkboxOff"
        
        static let goldenButtonOn = "zloty_on"
        static let goldenButtonOff = "zloty_off"
        
        static let silverButtonOn = "srebrny_on"
        static let silverButtonOff = "srebrny_off"
        
        static let bronzeButtonOn = "braz_on"
        static let bronzeButtonOff = "braz_off"
        
        static let smallStarSelected = "starSMALLSelected"
        static let smallStarNOTSelected = "starSMALLNotSelected"
        
        static let dotEmpty = "DotEmpty"
        static let dotFiled = "DotFiled"
        
        static let showMapButton = "maps"
        static let showTableButton = "list"
        
        static let mapPin = "pin"
        static let showCollectionView = "picture"
        
        static let messagesUnred = "envelopeMSG"
        static let messagesRead = "envelope"
    }
    
    struct Colors
    {
        static let creamyBackgroundColor = UIColor(red: 204.0/255.0, green: 176/255.0, blue: 106/255.0, alpha: 1)
        static let blackColor = UIColor(red: 30.0/255.0, green: 38/255.0, blue: 45/255.0, alpha: 1)
        static let whiteColor = UIColor(red: 228.0/255.0, green: 239/255.0, blue: 241/255.0, alpha: 1)
        static let backgroundColor = UIColor(patternImage:UIImage(named: "background")!)
        
        static let goldenBackgroundColor = UIColor(red: 212.0/255.0, green: 185/255.0, blue: 124/255.0, alpha: 1)
        static let bronzeBackgroundColor = UIColor(red: 116.0/255.0, green: 83/255.0, blue: 44/255.0, alpha: 1)
        static let silverBackgroudColor = UIColor(red: 139.0/255.0, green: 141/255.0, blue: 146/255.0, alpha: 1)
    }
    
    struct Notifications
    {
//        static let kNotifApplicationBecomeActive = "appLicationBecomeActive"
        static let kNotificationMessagesChecked = "messagesChecked"
        
    }
    
    struct Text
    {
        static let kuponBuyed1 = "Używając 1 kupon \nzapłacisz 1 zł. \nza 1 danie z 2 zamówionych."
        static let kuponBuyed2 = "Używając 2 kupony \nzapłacisz po 1 zł. \nza 2 dania z 4 zamówionych."
        static let kuponBuyed3 = "Używając 3 kupony \nzapłacisz po 1 zł. \nza 3 dania z 6 zamówionych."
        static let kuponBuyed4 = "Używając 4 kupony \nzapłacisz po 1 zł. \nza 4 dania z 8 zamówionych."
        static let kuponBuyed5 = "Używając 5 kuponów \nzapłacisz po 1 zł. \nza 5 dań z 10 zamówionych."
        
        static let realyBuy1 = "Czy na pewno chcesz użyć 1 kupon ?"
        static let realyBuy2 = "Czy na pewno chcesz użyć 2 kupony ?"
        static let realyBuy3 = "Czy na pewno chcesz użyć 3 kupony ?"
        static let realyBuy4 = "Czy na pewno chcesz użyć 4 kupony ?"
        static let realyBuy5 = "Czy na pewno chcesz użyć 5 kuponów ?"
        
        static let kuponWarning = "Aby użyć kupon, wybierz ich liczbę i zatwierdź przyciskiem w obecności kelnera. Zrób to zanim zamówisz rachunek."
    }
}
