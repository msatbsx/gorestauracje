//
//  RateViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD

class RateViewController: RootViewController, TableControllerDelegate {

    @IBOutlet weak var restaurantNamingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kichenView: UIView!
    @IBOutlet weak var wystrijView: UIView!
    @IBOutlet weak var obslugaView: UIView!
    
    @IBOutlet weak var firstKitchenButton: UIButton!
    @IBOutlet weak var secondKitchenButton: UIButton!
    @IBOutlet weak var thirdKitchenButton: UIButton!
    @IBOutlet weak var fourthKitchenButton: UIButton!
    @IBOutlet weak var fifthKitchenButton: UIButton!
    
    @IBOutlet weak var firstWystrojButton: UIButton!
    @IBOutlet weak var secondWystrojButton: UIButton!
    @IBOutlet weak var thirdWystrojButton: UIButton!
    @IBOutlet weak var fourthWystrojButton: UIButton!
    @IBOutlet weak var fifthWystrojButton: UIButton!
    
    @IBOutlet weak var firstObslugaButton: UIButton!
    @IBOutlet weak var secondObslugaButton: UIButton!
    @IBOutlet weak var thirdObslugaButton: UIButton!
    @IBOutlet weak var fourthObslugaButton: UIButton!
    @IBOutlet weak var fifthObslugaButton: UIButton!
    @IBOutlet weak var zamowTaxiButton: UIButton!
    @IBOutlet weak var zamknijButton: UIButton!
    
    @IBOutlet weak var shareYourOpinionHeight: NSLayoutConstraint!
    @IBOutlet weak var kitchenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var wystrojViewHeight: NSLayoutConstraint!
    @IBOutlet weak var obslugaViewHeight: NSLayoutConstraint!
    @IBOutlet weak var zamowTaxiButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var zamknijButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    var kitchenScore:Int = 0
    var serviceScore:Int = 0
    var designScore:Int = 0
    var restaurantName:String?
    var resturantID:Int?
    
    var kitchenButtonsArray:NSArray?
    var wystrojButtonsArray:NSArray?
    var obslugaButtonsArray:NSArray?
    
    let tableController = StartViewTableController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupRestaurantName()
        setupButtonViewLabels()
        updateLayoutFor4S()
        setTableData()
        shouldAddBackButton = true
        fillArrays()
    }
    
    func setupRestaurantName()
    {
        if let restname = restaurantName
        {
            ViewConfigurator.setTextFont(forLabel: restaurantNameLabel, textForSet: restname)
        }
    }
    
    func fillArrays()
    {
        kitchenButtonsArray = [firstKitchenButton, secondKitchenButton, thirdKitchenButton, fourthKitchenButton, fifthKitchenButton];
        obslugaButtonsArray = [firstObslugaButton, secondObslugaButton, thirdObslugaButton, fourthObslugaButton, fifthObslugaButton];
        wystrojButtonsArray = [firstWystrojButton, secondWystrojButton, thirdWystrojButton, fourthWystrojButton, fifthWystrojButton];
    }
    
    @IBAction func zamowTaxiClicked(_ sender: AnyObject)
    {
        
    }

    override func backButtonClicked()
    {
        HUD.show(.progress)
        RestClient.sharedInstance.rateRestaurantBy(resturantID!, kitchen: kitchenScore, service: serviceScore, design: designScore) { (success) in
            DispatchQueue.main.async {
                if success
                {
                    HUD.hide()
                }
                else
                {
                    HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                    HUD.hide(afterDelay: 2.0)

                }
                
                
                    for viewC in (self.navigationController?.viewControllers)!
                    {
                        if viewC.isKind(of: StartViewController.classForCoder())
                        {
                            _ = self.navigationController?.popToViewController(viewC, animated: true)
                            (viewC as! StartViewController).getRestaurantListBecomeActive()
                        }
                    }
                    HUD.hide(afterDelay: 2.0)
                }
        }
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: restaurantNamingView, setRoundedCorners: false, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: zamknijButton, setRoundedCorners: true, shouldHaveBorder: false);
    }
    
    func setTableData()
    {
        tableController.parentTableView = self.tableView
        tableController.parentViewController = self
        tableController.tableDelegate = self
        tableController.setupTableView()
        tableController.reloadTableView()
    }

    
    func tableController(_ tableController: StartViewTableController, didSelectedRowAtIndexPath indexPath: IndexPath)
    {
        
    }

    //MARK: Kitchen
    
    @IBAction func firstKitchenClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: kitchenButtonsArray!)
        kitchenScore = 1
    }

    @IBAction func secondKitchenClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: kitchenButtonsArray!)
        kitchenScore = 2
    }

    @IBAction func thirdKitchenClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: kitchenButtonsArray!)
        kitchenScore = 3
    }

    @IBAction func fourthKitchenClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: kitchenButtonsArray!)
        kitchenScore = 4
    }

    @IBAction func fifthKitchenClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: kitchenButtonsArray!)
        kitchenScore = 5
    }
    
    //MARK: Wystroj
    
    
    @IBAction func firthWystrojClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: wystrojButtonsArray!)
        designScore = 1
    }
    
    @IBAction func secondWystrojClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: wystrojButtonsArray!)
        designScore = 2
    }
    @IBAction func thirdWystrojClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: wystrojButtonsArray!)
        designScore = 3
    }
    @IBAction func fourthWystrojClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: wystrojButtonsArray!)
        designScore = 4
    }
    @IBAction func fifthWystrojClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: wystrojButtonsArray!)
        designScore = 5
    }
    
    //MARK: Obsluga
    
    @IBAction func firthObslugaClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: obslugaButtonsArray!)
        serviceScore = 1
    }
    
    @IBAction func secondObslugaClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: obslugaButtonsArray!)
        serviceScore = 2
    }
    @IBAction func thirdObslugaClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: obslugaButtonsArray!)
        serviceScore = 3
    }
    @IBAction func fourthObslugaClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: obslugaButtonsArray!)
        serviceScore = 4
    }
    @IBAction func fifthObslugaClicked(_ sender: AnyObject)
    {
        setButtonImages(sender as! UIButton, buttonsArray: obslugaButtonsArray!)
        serviceScore = 5
    }
    
    @IBAction func zamknijButtonClicked(_ sender: AnyObject)
    {
        HUD.show(.progress)
        RestClient.sharedInstance.rateRestaurantBy(resturantID!, kitchen: kitchenScore, service: serviceScore, design: designScore) { (success) in
            DispatchQueue.main.async {
                if success
                {
                    HUD.hide()
                }
                else
                {
                    HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                    HUD.hide(afterDelay: 2.0)

                }
                
                    for viewC in (self.navigationController?.viewControllers)!
                    {
                        if viewC.isKind(of: StartViewController.classForCoder())
                        {
                            _ = self.navigationController?.popToViewController(viewC, animated: true)
                            (viewC as! StartViewController).getRestaurantListBecomeActive()
                        }
                    }
            }
        }
    }
    
    func setButtonImages(_ button:UIButton, buttonsArray:NSArray)
    {
        for but in buttonsArray
        {
            if (but as! UIButton).tag <= button.tag
            {
                (but as AnyObject).setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
            }
            else
            {
                (but as AnyObject).setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            }
        }
    }

    func updateLayoutFor4S()
    {
        if self.view.frame.size.height < 568
        {
            shareYourOpinionHeight.constant = shareYourOpinionHeight.constant - 20
            kitchenViewHeight.constant = kitchenViewHeight.constant - 10
            wystrojViewHeight.constant = wystrojViewHeight.constant - 10
            obslugaViewHeight.constant = obslugaViewHeight.constant - 10
            zamknijButtonHeight.constant = zamknijButtonHeight.constant - 10
        }
    }
}
