//
//  StartViewTableController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

protocol MessageTableControllerDelegate
{
    func tableController(_ tableController:MessagesViewTableController, didSelectedRowAtIndexPath indexPath:IndexPath)
    
}

class MessagesViewTableController: NSObject, UITableViewDelegate, UITableViewDataSource
{
    var parentTableView:UITableView?
    var tableDelegate:MessageTableControllerDelegate! = nil
    var parentViewController:UIViewController?
    var dataArray = NSArray()
    //MARK:TableView delegate dataSource
    
    func setupTableView()
    {
        parentTableView?.delegate = self;
        parentTableView?.dataSource = self;
        registerCells()
        parentTableView?.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        parentTableView?.estimatedRowHeight = 1044.0 // set this
    }
    
    func registerCells()
    {
        parentTableView?.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
    }
    
    func reloadTableView()
    {
        self.parentTableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return createAndGetMessageCell(indexPath)
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        let cell = (data.getCellForIndexPath(indexPath));
//        (cell as UITableViewCell).layoutIfNeeded();
//        (cell as UITableViewCell).updateConstraintsIfNeeded();
//        
//        return (cell as UITableViewCell).contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height;
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        let cell = (data.getCellForIndexPath(indexPath));
//        (cell as UITableViewCell).layoutIfNeeded();
//        (cell as UITableViewCell).updateConstraintsIfNeeded();
//        
//        return (cell as UITableViewCell).contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height;
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 75.0;
//        
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 75.0
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tableDelegate.tableController(self, didSelectedRowAtIndexPath: indexPath);
    }
    
    func createAndGetMessageCell(_ indexPath:IndexPath) -> MessageTableViewCell
    {
        let messageCell = self.parentTableView?.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        messageCell.setCellData(messageObject: dataArray[(indexPath as NSIndexPath).row] as! MessageListModel)
        return messageCell
    }
    
}
