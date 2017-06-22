//
//  StartViewTableController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

protocol TableControllerDelegate
{
    func tableController(_ tableController:StartViewTableController, didSelectedRowAtIndexPath indexPath:IndexPath)
    
}

class StartViewTableController: NSObject, UITableViewDelegate, UITableViewDataSource
{
    var parentTableView:UITableView?
    var tableDelegate:TableControllerDelegate! = nil
    var parentViewController:UIViewController?
    var hideKuponCountLabel = false
    var hideRateStars = false
    var showKuponTime = false
    var dataArray = NSArray()
    var shouldShowKuponHistory = false
    var kuponHistoryArray = NSArray()
    //MARK:TableView delegate dataSource
    
    func setupTableView()
    {
        parentTableView?.delegate = self;
        parentTableView?.dataSource = self;
        registerCells()
    }
    
    func registerCells()
    {
        parentTableView?.register(UINib(nibName: "RestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantTableViewCell")
        parentTableView?.register(UINib(nibName: "KuponHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "KuponHistoryTableViewCell")
    }
    
    func reloadTableView()
    {
        self.parentTableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if shouldShowKuponHistory
        {
            return kuponHistoryArray.count
        }
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if shouldShowKuponHistory
        {
            return createAndGetKuponHistoryCell(indexPath)
        }
        return createAndGetRestaurantCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableDelegate.tableController(self, didSelectedRowAtIndexPath: indexPath);
    }
    
    func createAndGetKuponHistoryCell(_ indexPath:IndexPath) -> KuponHistoryTableViewCell
    {
        let kuponHistoryCell = self.parentTableView?.dequeueReusableCell(withIdentifier: "KuponHistoryTableViewCell") as! KuponHistoryTableViewCell
        kuponHistoryCell.setCellData(from: kuponHistoryArray[(indexPath as NSIndexPath).row] as! BoughtKuponModel)
        return kuponHistoryCell
    }
    
    func createAndGetRestaurantCell(_ indexPath:IndexPath) -> RestaurantTableViewCell
    {
        let restaurantCell = self.parentTableView?.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as! RestaurantTableViewCell
        var shouldShowUnlock = false
        if (dataArray[(indexPath as NSIndexPath).row] as! RestaurantListModel).kuponAvailable!.intValue == 0
        {
            shouldShowUnlock = true
        }
        restaurantCell.setCellTittlesAndUnlockButton(dataArray[(indexPath as NSIndexPath).row] as AnyObject , showUnlockButton: shouldShowUnlock, indexPath: indexPath,hideKuponLabel: hideKuponCountLabel, showTime: showKuponTime)
        restaurantCell.unlockButton.addTarget(self, action: #selector(StartViewTableController.unlockKuponPressed(_:)), for: UIControlEvents.touchUpInside)
        restaurantCell.selectionStyle = .none
        restaurantCell.showKuponDetailButton.tag = (indexPath as NSIndexPath).row
        restaurantCell.showKuponDetailButton.addTarget(self, action: #selector(StartViewTableController.kuponLabelPressed(_:)), for: UIControlEvents.touchUpInside)
        if hideRateStars
        {
            restaurantCell.hideRateStars()
        }

        return restaurantCell;
    }
    
    func unlockKuponPressed(_ sender:UIButton)
    {
        let innAppPurchaseIdentifier = "InnAppPurchaseViewController"
        let storyboardIdentifier = "Main"
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let inAppPurchaseView = storyboard.instantiateViewController(withIdentifier: innAppPurchaseIdentifier)
        parentViewController?.navigationController?.show(inAppPurchaseView, sender: nil);
    }
    
    func kuponLabelPressed(_ sender:UIButton)
    {
        let kuponViewControllerIdentifier = "KuponViewController"
        let storyboardIdentifier = "Main"
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let kuponViewController = storyboard.instantiateViewController(withIdentifier: kuponViewControllerIdentifier) as! KuponViewController
        kuponViewController.restaurantData.restaurantName = (dataArray[sender.tag] as! RestaurantListModel).name!
        kuponViewController.restaurantData.restaurantId = (dataArray[sender.tag] as! RestaurantListModel).id!.intValue
        kuponViewController.restaurantData.availableKupons = (dataArray[sender.tag] as! RestaurantListModel).kuponAvailable!.intValue
        kuponViewController.restaurantData.totalKupons = (dataArray[sender.tag] as! RestaurantListModel).kuponTotal!.intValue
        kuponViewController.restaurantData.address = (dataArray[sender.tag] as! RestaurantListModel).address
        parentViewController?.navigationController?.show(kuponViewController, sender: nil);
    }
}
