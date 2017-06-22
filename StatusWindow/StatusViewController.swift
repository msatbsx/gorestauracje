//
//  StatusViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD

class StatusViewController: RootViewController, TableControllerDelegate {

    @IBOutlet weak var twojeView: UIView!
    @IBOutlet weak var kuponyLeftView: UIView!
    @IBOutlet weak var kuponyView: UIView!
    @IBOutlet weak var kuponyLabel: UILabel!
    @IBOutlet weak var allKuponsView: UIView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var alKuponsCountLabel: UILabel!
    @IBOutlet weak var usedKuponsView: UIView!
    @IBOutlet weak var usedKuponsLabel: UILabel!
    @IBOutlet weak var usedKuponsCountLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kupButton: UIButton!
    @IBOutlet weak var adviceForFriend: UIButton!
    @IBOutlet weak var regulaminButton: UIButton!
    @IBOutlet weak var whatIsgoOutButton: UIButton!
    @IBOutlet weak var kuponHistory: UIButton!
    @IBOutlet weak var DaysCounter: UILabel!
    @IBOutlet weak var emptyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var kuponHistoryButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whatIsGoingOutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var regulaminButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adviceForFriendHeightConstraint: NSLayoutConstraint!
    
    let tableController = StartViewTableController()
    var kuponArray:NSArray?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.alKuponsCountLabel.text = "0"
        self.usedKuponsCountLabel.text = "0"
        setupButtonViewLabels()
        updateLayoutFor4S()
        addingShadow()
        setTableData()
        shouldAddBackButton = true
        getUserKuponsCount()
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: twojeView, setRoundedCorners: false, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kuponyLeftView, setRoundedCorners: false, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kuponyView, setRoundedCorners: false, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: allKuponsView, setRoundedCorners: false, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: usedKuponsView, setRoundedCorners: false, shouldHaveBorder: false);
        
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kupButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: adviceForFriend, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: regulaminButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: whatIsgoOutButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kuponHistory, setRoundedCorners: true, shouldHaveBorder: false);
    }
   
    func addingShadow()
    {
        ViewConfigurator.addBottomShadow(viewObject: kuponyLeftView)
        ViewConfigurator.addBottomShadow(viewObject: kuponyView)
        ViewConfigurator.addBottomShadow(viewObject: self.view)
    }
    
    func setTableData()
    {
        tableController.parentTableView = self.tableView
        tableController.parentViewController = self
        tableController.tableDelegate = self
        tableController.setupTableView()
        tableController.shouldShowKuponHistory = true
        tableController.hideRateStars = true;
    }
    
    func tableController(_ tableController: StartViewTableController, didSelectedRowAtIndexPath indexPath: IndexPath)
    {
        
    }

    //MARK: -  IBActions
    
    @IBAction func buyKuponButtonPressed(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func adviceForFriendPressed(_ sender: AnyObject)
    {
            let toShare = "Zobacz koniecznie: http://www.go-out.com.pl/"
            let objectsToShare = [toShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func regulaminPressed(_ sender: AnyObject)
    {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoView = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as!  HelpViewController
        infoView.buttonClicked = "regulamin"
        self.navigationController?.show(infoView, sender: nil)
    }
    
    @IBAction func whatIsGoingOutPressed(_ sender: AnyObject)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoView = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as!  HelpViewController
        infoView.buttonClicked = "whatIsGoingOut"
        self.navigationController?.show(infoView, sender: nil)
    }
    
    @IBAction func kuponHistoryPressed(_ sender: AnyObject)
    {
        
        HUD.show(.progress)
        RestClient.sharedInstance.getKuponHistory { (historyArray, success) in
            DispatchQueue.main.async {
                if success
                {
                    self.tableController.kuponHistoryArray = historyArray
                    self.tableController.reloadTableView()
                    HUD.hide()
                }
                else
                {
                    HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                    HUD.hide(afterDelay: 2.0)
                }
            }
        }
        
        self.tableView.isHidden = false
        hideAllButtons()
    }
    
    override func backButtonClicked()
    {
        if kuponHistory.isHidden == true {
            adviceForFriend.isHidden = false
            regulaminButton.isHidden = false
            whatIsgoOutButton.isHidden = false
            kuponHistory.isHidden = false
            self.tableView.isHidden = true
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func hideAllButtons()
    {
        adviceForFriend.isHidden = true
        regulaminButton.isHidden = true
        whatIsgoOutButton.isHidden = true
        kuponHistory.isHidden = true
        kupButton.isHidden = true
    }
    
    func showAllButtons()
    {
        adviceForFriend.isHidden = false
        regulaminButton.isHidden = false
        whatIsgoOutButton.isHidden = false
        kuponHistory.isHidden = false
        kupButton.isHidden = false
        self.tableView.isHidden = true
    }
    
    func updateLayoutFor4S()
    {
        if self.view.frame.size.height < 568
        {
            emptyViewHeightConstraint.constant = emptyViewHeightConstraint.constant - 10
//            buyKuponButtonBottomSpaceConstraint.constant = buyKuponButtonBottomSpaceConstraint.constant - 30
            kuponHistoryButtonHeightConstraint.constant = kuponHistoryButtonHeightConstraint.constant - 10
            whatIsGoingOutHeightConstraint.constant = whatIsGoingOutHeightConstraint.constant - 10
            regulaminButtonHeightConstraint.constant = regulaminButtonHeightConstraint.constant - 10
            adviceForFriendHeightConstraint.constant = adviceForFriendHeightConstraint.constant - 10
//            buyKuponHeightConstraint.constant = buyKuponHeightConstraint.constant - 10
        }
    }
    @IBAction func kupButtonClicked(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let purchaseView = storyboard.instantiateViewController(withIdentifier: "InnAppPurchaseViewController") as!  InnAppPurchaseViewController
        self.navigationController?.show(purchaseView, sender: nil)

    }
    
    func getUserKuponsCount()
    {
        HUD.show(.progress)
        RestClient.sharedInstance.getUserKuponsCount { (totalKupons, availableKupons, daysToEnd, succes) in
            DispatchQueue.main.async {
                if succes
                {
                    if totalKupons != nil
                    {
                        self.alKuponsCountLabel.text = "\(totalKupons!.intValue)"
                    }
                    if availableKupons != nil
                    {
                        self.usedKuponsCountLabel.text = "\(availableKupons!.intValue)"
                    }
                    HUD.hide()
                    if availableKupons?.intValue == 0
                    {
                        self.kupButton.isHidden = false
                    }
                    if daysToEnd != nil
                    {
                        self.DaysCounter.text = "pozostaną ważne jeszcze: \(daysToEnd!.intValue) dni."
                    }
                }
                else
                {
                    HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                    HUD.hide(afterDelay: 2.0)
                }
            }
        }
    }
}
