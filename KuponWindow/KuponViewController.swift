//
//  KuponViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD

class KuponViewController: RootViewController {

    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var kuponContentView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var kuponCountLabel: UILabel!
    @IBOutlet weak var kuponCountView: UIView!
    @IBOutlet weak var rateLeftViewWidthC: NSLayoutConstraint!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var availableKuponsLabel: UILabel!
    @IBOutlet weak var kuponWarningLabel: UILabel!
    @IBOutlet weak var KuponImage: UIImageView!
    @IBOutlet weak var boughtKuponView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var showOcenaButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var buyedInfoLabel: UILabel!

    @IBOutlet weak var kuponCountViewHeightConstraint: NSLayoutConstraint!
    
    let kuponsController = KuponController()
    var restaurantData:(restaurantName:String, restaurantId:Int?, availableKupons:Int?, totalKupons:Int?, address:String?) = ("", nil, nil, nil, "")
    var kuponsForUse = 0;
    let animationDuration = 0.5
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupButtonViewLabels()
        setupKuponData()
        showOcenaButton.isUserInteractionEnabled = false
        shouldAddBackButton = true
        rateLeftViewWidthC.constant = self.view.frame.size.width
        rateLabel.text = ConstantsStruct.Text.kuponWarning
        if kuponsForUse == 0
        {
            useButton.isUserInteractionEnabled = false
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AppManager.sharedInstance.timer?.invalidate()
        AppManager.sharedInstance.timerCount = 0
        AppManager.sharedInstance.forceReloadRestaurantList = true
    }
    
    func setupKuponData()
    {
        if restaurantData.restaurantName != ""
        {
            ViewConfigurator.setTextFont(forLabel: restaurantNameLabel, textForSet: restaurantData.restaurantName)
        }
        if restaurantData.availableKupons != nil
        {
            availableKuponsLabel.text = "\(restaurantData.availableKupons!)"
        }
        else
        {
            restaurantData.availableKupons = 0
            availableKuponsLabel.text = "\(restaurantData.availableKupons!)"
        }
        if restaurantData.totalKupons != nil && restaurantData.totalKupons != 0
        {
            kuponsForUse = 1
            kuponCountLabel.text = "\(kuponsForUse)"
        }
        else
        {
            kuponsForUse = 0
            kuponCountLabel.text = "\(kuponsForUse)"
        }
        if restaurantData.address != nil
        {
            addressLabel.text = restaurantData.address
        }
        else
        {
            addressLabel.text = ""
        }
        
        setupKuponWarningText()
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: useButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: showOcenaButton, setRoundedCorners: true, shouldHaveBorder: false);
    }

    override func viewDidAppear(_ animated: Bool)
    {
        setKornersForBuyedKupons()
    }
    
    func setKornersForBuyedKupons()
    {
        boughtKuponView.clipsToBounds = true;
        boughtKuponView.layer.borderWidth = 0.0;
        boughtKuponView.layer.borderColor = UIColor.gray.cgColor;
        boughtKuponView.layer.cornerRadius = 20;
    }
    
    @IBAction func useButtonClicked(_ sender: AnyObject)
    {
        var kuponText = ""
        if kuponsForUse == 1
        {
            kuponText = ConstantsStruct.Text.realyBuy1
        }
        if kuponsForUse == 2
        {
            kuponText = ConstantsStruct.Text.realyBuy2
        }
        if kuponsForUse == 3
        {
            kuponText = ConstantsStruct.Text.realyBuy3
        }
        if kuponsForUse == 4
        {
            kuponText = ConstantsStruct.Text.realyBuy4
        }
        if kuponsForUse == 5
        {
            kuponText = ConstantsStruct.Text.realyBuy5
        }
        let callAllertController = UIAlertController(title:"" , message: kuponText, preferredStyle: .alert)
        let cancellAction = UIAlertAction(title: "Nie", style: .cancel, handler: nil)
        let callAction = UIAlertAction(title: "Tak", style: .default, handler: { (action) in
            self.buyKupons()
        })
        callAllertController.addAction(callAction)
        callAllertController.addAction(cancellAction)
        present(callAllertController, animated: true, completion: nil)

    }
    
    func buyKupons()
    {
        HUD.show(.progress)
        RestClient.sharedInstance.useKuponFor(restaurantData.restaurantId!, kuponcount: self.kuponsForUse, completion: { (success) in
          DispatchQueue.main.async {
            if success
            {
                AppManager.sharedInstance.resetFilters()

                    UIView.transition(with: self.kuponWarningLabel, duration: self.animationDuration, options: .transitionFlipFromLeft, animations: {
                        self.kuponCountViewHeightConstraint.constant = 0
                        self.kuponWarningLabel.isHidden = true
                        }, completion: { (Bool) in
                            
                            UITableView.transition(with: self.boughtKuponView, duration: self.animationDuration, options: .transitionFlipFromLeft, animations: {
                                self.boughtKuponView.isHidden = false
                                }, completion: { (Bool) in
                            })
                    })
                
                    self.setupViewsAfterKuponsBought()
                    self.kuponCountView.isHidden = true
                    self.showOcenaButton.isUserInteractionEnabled = true
                    self.timeView.isHidden = false
                    self.kuponWarningLabel.isHidden = true
                    self.showOcenaButton.isHidden = false
                    self.rateLabel.isHidden = true

                
               
                HUD.hide()
            }
            else
            {
                HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                HUD.hide(afterDelay: 2.0)
            }
        }
        })
    }
    
    func setupViewsAfterKuponsBought()
    {
        if kuponsForUse == 1
        {
           KuponImage.image = UIImage(named:"kupon1")
        }
        else if kuponsForUse == 2
        {
            KuponImage.image = UIImage(named:"kupon2")
        }
        else if kuponsForUse == 3
        {
            KuponImage.image = UIImage(named:"kupon3")
        }
        self.backButton?.isHidden = true
        if UIDevice.current.modelName == "iPhone 4s"
        {
           
        }
        
        
        startTimer()
    }
    
    func startTimer()
    {
        AppManager.sharedInstance.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(KuponViewController.tickTackTimer), userInfo: nil, repeats: true)
    }
    
    func tickTackTimer()
    {
        AppManager.sharedInstance.timerCount += 1
            self.buyedInfoLabel.text = "Transakcja zrealizowana dnia \(self.kuponsController.getCurrentDateString()!)\n o godzinie \(self.kuponsController.getCurrentTimeString()!)\n \(AppManager.sharedInstance.timerCount) sek. temu."
    }
    
    @IBAction func plusButtonClicked(_ sender: AnyObject)
    {
        if restaurantData.availableKupons != nil
        {
            if kuponsForUse < restaurantData.availableKupons!
            {
                kuponsForUse += 1
                kuponCountLabel.text = "\(kuponsForUse)"
            }
        }
        setupKuponWarningText()
    }
    
    @IBAction func minusButtonClicked(_ sender: AnyObject)
    {
        if kuponsForUse > 1
        {
            kuponsForUse -= 1
            kuponCountLabel.text = "\(kuponsForUse)"
        }
        setupKuponWarningText()
    }
    
    func setupKuponWarningText()
    {
        if kuponsForUse == 0
        {
            kuponWarningLabel.text = ""
        }
        else if kuponsForUse == 1
        {
            kuponWarningLabel.text = ConstantsStruct.Text.kuponBuyed1
        }
        else if kuponsForUse == 2
        {
            kuponWarningLabel.text = ConstantsStruct.Text.kuponBuyed2
        }
        else if kuponsForUse == 3
        {
            kuponWarningLabel.text = ConstantsStruct.Text.kuponBuyed3
        }
        else if kuponsForUse == 4
        {
            kuponWarningLabel.text = ConstantsStruct.Text.kuponBuyed4
        }
        else if kuponsForUse == 5
        {
            kuponWarningLabel.text = ConstantsStruct.Text.kuponBuyed5
        }
        if kuponsForUse != 0
        {
            useButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func showOcenaView(_ sender: AnyObject)
    {
        let ocenaViewController = self.storyboard?.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        ocenaViewController.resturantID = restaurantData.restaurantId
        ocenaViewController.restaurantName = restaurantData.restaurantName
        self.navigationController?.pushViewController(ocenaViewController, animated: true)
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

}
