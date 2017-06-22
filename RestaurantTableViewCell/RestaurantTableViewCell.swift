//
//  RestaurantTableViewCell.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import Foundation

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var restaurantTittleLable: UILabel!
    @IBOutlet weak var restaurantAddresLabel: UILabel!
    @IBOutlet weak var kuponCountLabel: UILabel!
    @IBOutlet weak var showKuponDetailButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!

    @IBOutlet weak var firstStarBtn: UIButton!
    @IBOutlet weak var secondStarBtn: UIButton!
    @IBOutlet weak var thirdStarBtn: UIButton!
    @IBOutlet weak var fourtsStarBtn: UIButton!
    @IBOutlet weak var fifthStarBtn: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var kuponLabel: UILabel!
    @IBOutlet weak var totalKuponsLabel: UILabel!
    
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var kuponLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var kuponCountLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockImageView: UIImageView!
    
    func setCellTittlesAndUnlockButton(_ object:AnyObject, showUnlockButton:Bool, indexPath:IndexPath, hideKuponLabel:Bool, showTime:Bool)
    {
        addBackGround()
        unlockButton.tag = (indexPath as NSIndexPath).row
        var scoreNumber:NSNumber?
        if object is RestaurantListModel
        {
            restaurantTittleLable.text = (object as! RestaurantListModel).name
            restaurantAddresLabel.text = (object as! RestaurantListModel).address
            scoreNumber = (object as! RestaurantListModel).score
            if let restaurantColor = (object as! RestaurantListModel).color
            {
                if (restaurantColor as NSString).intValue == 1
                {
                    rightView.backgroundColor = ConstantsStruct.Colors.bronzeBackgroundColor
                    addShadowAtBottom(4)
                }
                if (restaurantColor as NSString).intValue == 2
                {
                    rightView.backgroundColor = ConstantsStruct.Colors.silverBackgroudColor
                    addShadowAtBottom(3)
                }
                if (restaurantColor as NSString).intValue == 3
                {
                    rightView.backgroundColor = ConstantsStruct.Colors.goldenBackgroundColor
                    addShadowAtBottom(2)
                }
            }
            if (object as! RestaurantListModel).kuponTotal != nil
            {
                totalKuponsLabel.text = "/\((object as! RestaurantListModel).kuponTotal!.intValue)"
            }
            if (object as! RestaurantListModel).kuponAvailable != nil
            {
                kuponCountLabel.text = "\((object as! RestaurantListModel).kuponAvailable!.intValue)"
            }
            let distanceString:NSString = (object as! RestaurantListModel).distance! as NSString
            let decNumber:NSDecimalNumber = NSDecimalNumber(string: distanceString as String)
            if decNumber == NSDecimalNumber.notANumber || (distanceString as String).characters.count == 0
            {
                distanceLabel.text = "-km"
            }
            else
            {
                if AppManager.sharedInstance.hideDistance == false
                {
                    let distanceString = "\(Double(round(10 * decNumber.doubleValue)/10)) km"
                    distanceLabel.text =  distanceString.replacingOccurrences(of: ".", with: ",")
                }
                else
                {
                    distanceLabel.text = "-km"
                }
            }
        }
        else
        {
            restaurantTittleLable.text = (object as! RealmRestaurantListObject).name
            restaurantAddresLabel.text = (object as! RealmRestaurantListObject).address
            scoreNumber = (object as! RealmRestaurantListObject).score
        }

        
        if let score = scoreNumber
        {
            
            firstStarBtn.isHidden = false
            secondStarBtn.isHidden = false
            thirdStarBtn.isHidden = false
            fourtsStarBtn.isHidden = false
            fifthStarBtn.isHidden = false

            
            if score.doubleValue > 0.0 && score.doubleValue < 1.0
            {
                firstStarBtn.setImage(UIImage(named:ConstantsStruct.Buttons.starNOTSelectedButton ), for: UIControlState())
                secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            }
            
            if score.doubleValue <= 1.0 && score.doubleValue > 0.0
            {
                firstStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            }
            if score.doubleValue > 1.0 && score.doubleValue <= 2.0
            {
                firstStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            }
            if score.doubleValue > 2.0 && score.doubleValue <= 3.0
            {
                firstStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
                fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            }
            if score.doubleValue > 3.0 && score.doubleValue <= 4.0
            {
                firstStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            }
            if score.doubleValue > 4.0 && score.doubleValue <= 5.0
            {
                firstStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
                fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starSelectedButton), for: UIControlState())
            }
            
            if score.doubleValue == 0.0
            {
                firstStarBtn.isHidden = true
                secondStarBtn.isHidden = true
                thirdStarBtn.isHidden = true
                fourtsStarBtn.isHidden = true
                fifthStarBtn.isHidden = true
            }


        }
        else
        {
            firstStarBtn.setImage(UIImage(named:ConstantsStruct.Buttons.starNOTSelectedButton ), for: UIControlState())
            secondStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            thirdStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            fourtsStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())
            fifthStarBtn.setImage(UIImage(named: ConstantsStruct.Buttons.starNOTSelectedButton), for: UIControlState())

        }
        //======    !UNCOMMENT! =  = = = = =
        
        if showUnlockButton
        {
            lockImageView.isHidden = false
            unlockButton.isHidden = false
            kuponCountLabel.isHidden = true
            showKuponDetailButton.isEnabled = false
            totalKuponsLabel.isHidden = true
            kuponLabel.font = UIFont(name: (kuponLabel?.font.fontName)!, size: 13)
            kuponLabel.text = "naciśnij by..."
            

        }
        else
        {
            lockImageView.isHidden = true
            totalKuponsLabel.isHidden = false
            unlockButton.isHidden = true
            kuponCountLabel.isHidden = false
            showKuponDetailButton.isEnabled = true
            kuponLabel.font = UIFont(name: (kuponLabel?.font.fontName)!, size: 20)
            kuponLabel.text = "kupony"
        }
        
        if showTime
        {
            kuponLabel.text = "12.34 30.09.2016"
            kuponLabel.font = UIFont(name: (kuponLabel?.font.fontName)!, size: 15)
            kuponCountLabel.text = "1"
            kuponCountLabel.font = UIFont(name: (kuponCountLabel?.font.fontName)!, size: 20)
            kuponCountLabelHeightConstraint.constant = 30
            kuponLabelHeightConstraint.constant = 40
            

            
            //comment or change for normal code
            lockImageView.isHidden = false
            unlockButton.isHidden = true
            kuponCountLabel.isHidden = false
            showKuponDetailButton.isEnabled = false

        }
    }
    
    func addShadowAtBottom(_ shadowType:Int)
    {
        if shadowType == 1
        {
            shadowImageView.image = UIImage(named: ConstantsStruct.kBlenda2Ciemny);
        }
        else if shadowType == 2
        {
            shadowImageView.image = UIImage(named: ConstantsStruct.kBlendaZloto2);
        }
        else if shadowType == 3
        {
            shadowImageView.image = UIImage(named: ConstantsStruct.kBlendaSrebro2);
        }
        else if shadowType == 4
        {
            shadowImageView.image = UIImage(named: ConstantsStruct.kblendaBraz2);
        }
    }
    
    func addBackGround()
    {
        let background = UIImageView(frame: self.frame);
        background.backgroundColor = UIColor.clear
        background.isOpaque = false
        background.image = UIImage(named: ConstantsStruct.kBackgroundName);
        self.backgroundView = background;
    }
    
    func hideRateStars()
    {
        firstStarBtn.isHidden = true
        secondStarBtn.isHidden = true
        thirdStarBtn.isHidden = true
        fourtsStarBtn.isHidden = true
        fifthStarBtn.isHidden = true
    }
}
