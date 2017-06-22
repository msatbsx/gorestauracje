//
//  RootViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 26/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var shouldAddBackButton = false
    var shouldAddMessageButton = false
    var shouldAddStatusButton = false
    var backButton:UIButton?
    var messageButtonName:String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        customizeNavBar()
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "background")!)
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        addCustomBackButton()
        addCustomStatusButton()
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.checkMessages), name: NSNotification.Name(rawValue: ConstantsStruct.Notifications.kNotificationMessagesChecked), object: nil)
        if AppManager.sharedInstance.noOfUnreadMessages != nil
        {
            checkMessages()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
    }
    

    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func customizeNavBar()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "background"),for: .default)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 40, width: 40, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "goOutLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func checkMessages()
    {
        if shouldAddMessageButton
        {
            DispatchQueue.main.async
                {
                    let envelopeButton =  UIButton(type: .custom)
                    envelopeButton.setImage(UIImage(named: ConstantsStruct.Buttons.messagesRead), for: .normal)
                    envelopeButton.addTarget(self, action: #selector(RootViewController.messageButtonClicked), for: .touchUpInside)
                    envelopeButton.frame = CGRect(x:0, y:0, width:30, height:30)
                    let enevelopeBadge = UILabel(frame: CGRect(x:17, y:0, width:17, height:17))
                    enevelopeBadge.layer.masksToBounds = true;
                    enevelopeBadge.layer.cornerRadius = 8
                    enevelopeBadge.backgroundColor = UIColor.red
                    enevelopeBadge.textColor = UIColor.white
                    enevelopeBadge.font = enevelopeBadge.font.withSize(12)
                    enevelopeBadge.text = String(AppManager.sharedInstance.noOfUnreadMessages!)
                    enevelopeBadge.textAlignment = .center
                    envelopeButton.addSubview(enevelopeBadge)
                    let barButton = UIBarButtonItem(customView: envelopeButton)
                    self.navigationItem.rightBarButtonItem = barButton
                    if AppManager.sharedInstance.noOfUnreadMessages! == 0
                    {
                        enevelopeBadge.isHidden = true
                    }
            }
        }
        
        
    }
    @objc func applicationDidBecomeActive() {
        if AppManager.sharedInstance.forceOpenMessagesView == true
        {
            AppManager.sharedInstance.forceOpenMessagesView = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mViewc = storyboard.instantiateViewController(withIdentifier: "MessagesViewController")
            navigationController?.pushViewController(mViewc, animated: true)
        }
    }
    func addCustomBackButton()
    {
        if shouldAddBackButton
        {
            let buttonImage = UIImage(named: ConstantsStruct.Buttons.backButton)
            backButton = UIButton(type: .custom)
            backButton!.setImage(buttonImage, for: UIControlState())
            backButton!.frame = CGRect(x: 0, y: 0, width: (buttonImage?.size.width)! - 25, height: (buttonImage?.size.height)! - 15)
            backButton!.addTarget(self, action: #selector(RootViewController.backButtonClicked), for: .touchUpInside)
            let customBarButtonItem = UIBarButtonItem(customView: backButton!)
            self.navigationItem.leftBarButtonItem = customBarButtonItem
        }
    }
 

    
    func addCustomStatusButton()
    {
        if shouldAddStatusButton
        {
            let buttonImage = UIImage(named: ConstantsStruct.Buttons.statusButton)
            let backButton = UIButton(type: .custom)
            backButton.setImage(buttonImage, for: UIControlState())
            backButton.frame = CGRect(x: 0, y: 0, width: (buttonImage?.size.width)! - 7  , height: (buttonImage?.size.height)! - 10)
            backButton.addTarget(self, action: #selector(RootViewController.statusButtonClicked), for: .touchUpInside)
            let customBarButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItem = customBarButtonItem
        }
    }
    
    func statusButtonClicked()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageViewController = storyboard.instantiateViewController(withIdentifier: "StatusViewController") as!  StatusViewController
        self.navigationController?.show(messageViewController, sender: nil)
    }
    
    func backButtonClicked()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func messageButtonClicked()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as!  MessagesViewController
        self.navigationController?.show(messageViewController, sender: nil)
    }
}
