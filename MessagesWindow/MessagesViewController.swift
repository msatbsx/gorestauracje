//
//  MessagesViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD

class MessagesViewController: RootViewController, MessageTableControllerDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var messArray:NSArray?
    
    let tableController = MessagesViewTableController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        shouldAddBackButton = true
        //self.mainView.backgroundColor = ConstantsStruct.Colors.creamyBackgroundColor
        ViewConfigurator.addBottomShadow(viewObject: self.mainView)
        setTableData()
//        var badgeCount: Int
//        let application = UIApplication.shared
//        application.registerForRemoteNotifications()
//        badgeCount = application.applicationIconBadgeNumber
//        badgeCount -= 1
        //application.applicationIconBadgeNumber = AppManager.sharedInstance.noOfUnreadMessages!
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getAllMessages()
//        for name in UIFont.familyNames {
//            print(name)
//            if let nameString = name as String?
//            {
//                print(UIFont.fontNames(forFamilyName: nameString))
//            }
//        }

    }
    
    func setTableData()
    {
        tableController.parentTableView = self.tableView
        tableController.parentViewController = self
        tableController.tableDelegate = self
        tableController.setupTableView()
        tableController.reloadTableView()
    }
    
    func getAllMessages()
    {
        HUD.show(.progress)
        RestClient.sharedInstance.getUserMessages { (messagesArray, success) in
            DispatchQueue.main.async {
                if success
                {
                    self.tableController.dataArray = messagesArray
                    self.tableController.reloadTableView()
                    self.messArray = messagesArray
                    
                    HUD.hide()
                }
                else
                {
                    HUD.show(.labeledError(title: "", subtitle: "Nie masz wiadomości"))
                    HUD.hide(afterDelay: 2.0)
                }
            }
        }
        print("odczytane")
    }

    
    func tableController(_ tableController: MessagesViewTableController, didSelectedRowAtIndexPath indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messagesDetailViewController = storyboard.instantiateViewController(withIdentifier: "MessagesDetailViewController") as!  MessageDetailViewController
        messagesDetailViewController.messageId = (messArray?[indexPath.row] as! MessageListModel).id
        messagesDetailViewController.buy_buttonText = (messArray?[indexPath.row] as! MessageListModel).buy_buttonText
        
        self.navigationController?.show(messagesDetailViewController, sender: nil)

        
        

    }
}
