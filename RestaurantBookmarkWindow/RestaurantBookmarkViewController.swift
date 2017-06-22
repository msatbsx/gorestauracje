//
//  RestaurantBookmarkViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD
import MapKit

class RestaurantBookmarkViewController: RootViewController, CollectionViewControllerDelegate {

    @IBOutlet weak var RestaurantNameLabel: UILabel!
    @IBOutlet weak var apiKontentView: UIView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var kitchenLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var kitchenLeftView: UIView!
    @IBOutlet weak var kitchenLeftViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var star1K: UIImageView!
    @IBOutlet weak var star2K: UIImageView!
    @IBOutlet weak var star3K: UIImageView!
    @IBOutlet weak var star4K: UIImageView!
    @IBOutlet weak var star5K: UIImageView!
    
    @IBOutlet weak var wystrojMiddleView: UIView!
    @IBOutlet weak var wystrojMiddleViewHeightC: NSLayoutConstraint!
    @IBOutlet weak var star1W: UIImageView!
    @IBOutlet weak var star2W: UIImageView!
    @IBOutlet weak var star3W: UIImageView!
    @IBOutlet weak var star4W: UIImageView!
    @IBOutlet weak var star5W: UIImageView!
    
    @IBOutlet weak var mapsImageView: UIImageView!
    @IBOutlet weak var obslugaRightView: UIView!
    @IBOutlet weak var obslugaViewHeightC: NSLayoutConstraint!
    @IBOutlet weak var star1O: UIImageView!
    @IBOutlet weak var star2O: UIImageView!
    @IBOutlet weak var star3O: UIImageView!
    @IBOutlet weak var star4O: UIImageView!
    @IBOutlet weak var star5O: UIImageView!
    
    @IBOutlet weak var imageNumberDot1: UIImageView!
    @IBOutlet weak var imageNumberDot2: UIImageView!
    @IBOutlet weak var imageNumberDot3: UIImageView!
    @IBOutlet weak var imageNumberDot4: UIImageView!
    @IBOutlet weak var imageNumberDot5: UIImageView!
    
    @IBOutlet weak var imgDotWidth1: NSLayoutConstraint!
    @IBOutlet weak var imgDotWidth2: NSLayoutConstraint!
    @IBOutlet weak var imgDotWidth3: NSLayoutConstraint!
    @IBOutlet weak var imgDotWidth4: NSLayoutConstraint!
    @IBOutlet weak var imgDotWidth5: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: UIView!
    
    let animationDuration = 0.5
    var kitchenStarsArray = NSArray()
    var wystroStarsArray = NSArray()
    var obslugaStarsArray = NSArray()
    var selectedRestaurantId:NSNumber?
    var restaurantData:RestaurantDescription = RestaurantDescription()
    
    var kuponCount = 0
    let controllerCollection = CollectionViewController()
    var collectionImagesCountArray:NSArray = NSArray()
    var collectionImagesCountWidthArray:NSArray = NSArray()
    let controllerMap = MapController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addressLabel.numberOfLines = 1
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.minimumScaleFactor = 0.1
//        RestaurantNameLabel.numberOfLines = 1
//        RestaurantNameLabel.adjustsFontSizeToFitWidth = true
//        RestaurantNameLabel.minimumScaleFactor = 0.1
        setGenerateButtonTittle()
        setupButtonViewLabels()
        shouldAddBackButton = true
        controllerCollection.collectionDelegate = self
        
        fillStarsArray()
        
        HUD.show(.progress)
        if selectedRestaurantId != nil
        {
            RestClient.sharedInstance.getRestaurantsDescription(selectedRestaurantId!) { (restaurantDesc, succes) in
                DispatchQueue.main.async {
                    if succes
                    {
                        HUD.hide()
                        self.restaurantData = restaurantDesc!
                        self.setupCollectionView()
                        self.setViewData()
                        if self.controllerMap.mapView == nil
                        {
                            
                                self.controllerMap.setupMap(self.mapView)
                                self.controllerMap.setRestaurantTomap(restaurantDesc!)
                            
                            
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
        else
        {
            HUD.show(.labeledError(title: "Błąd", subtitle: "Błąd aplikacji"))
            HUD.hide(afterDelay: 2.0)
        }
    }
    
    func fillStarsArray()
    {
        kitchenStarsArray = [star1K, star2K, star3K, star4K, star5K]
        obslugaStarsArray = [star1O, star2O, star3O, star4O, star5O]
        wystroStarsArray = [star1W, star2W, star3W, star4W, star5W]
    }
    
    func setupCollectionView()
    {
        controllerCollection.parentViewController = self
        controllerCollection.parentCollectionView = collectionView
        controllerCollection.dataArray = restaurantData.photosArray
        controllerCollection.setupCollectionView()
        setupCollectionImagesCountArray()
        
        DispatchQueue.main.async {
            self.setupImagesCountForSelection()
            self.controllerCollection.reloadCollectionView()
        }
        
    }
    
    func setViewData()
    {
        DispatchQueue.main.async
            {
            ViewConfigurator.setTextFont(forLabel: self.RestaurantNameLabel, textForSet: self.restaurantData.name!)
            //self.RestaurantNameLabel.text = self.restaurantData.name
            self.addressLabel.text = self.restaurantData.address
            self.districtLabel.text = self.restaurantData.district
            self.kitchenLabel.text = self.getAllKitchenString()
            self.phoneLabel.text = self.restaurantData.phone1
            self.mailLabel.text = self.restaurantData.link
            self.textView.text = self.restaurantData.about_pl
            self.setupStars()
            self.view.layoutIfNeeded()
            self.setupKuponCountButton()
        }
   }
    
    func setupImagesCountForSelection()
    {
        if restaurantData.photosArray.count > 0
        {
            (collectionImagesCountArray[0] as! UIImageView).image = UIImage(named: ConstantsStruct.Buttons.dotFiled)
        }
        for (index, imageView) in collectionImagesCountArray.enumerated()
        {
            if index < restaurantData.photosArray.count
            {
                (imageView as! UIImageView).isHidden = false
                (collectionImagesCountWidthArray[index] as! NSLayoutConstraint).constant = 20
            }
            else
            {
                (imageView as! UIImageView).isHidden = true
                (collectionImagesCountWidthArray[index] as! NSLayoutConstraint).constant = 0
            }
        }
    }
    
    func setupCollectionImagesCountArray()
    {
        collectionImagesCountArray = [imageNumberDot1, imageNumberDot2, imageNumberDot3, imageNumberDot4, imageNumberDot5]
        collectionImagesCountWidthArray = [imgDotWidth1, imgDotWidth2, imgDotWidth3, imgDotWidth4, imgDotWidth5]
    }
    
    func setupStars()
    {
        if restaurantData.kitchenScore != nil
        {
            if restaurantData.kitchenScore != 0
            {
                for object in kitchenStarsArray
                {
                    let imageView = (object as! UIImageView)
                    if imageView.tag <= (restaurantData.kitchenScore?.intValue)!
                    {
                        imageView.image = UIImage(named:ConstantsStruct.Buttons.smallStarSelected)
                    }
                    else
                    {
                        imageView.image = UIImage(named:ConstantsStruct.Buttons.smallStarNOTSelected)
                    }
                }
            }
            else
            {
                kitchenLeftView.isHidden = true
            }
        }
        else
        {
            kitchenLeftView.isHidden = true
        }

        if restaurantData.wystrojScore != nil
        {
            if restaurantData.wystrojScore != 0
            {
                for object in wystroStarsArray
                {
                    let imageView = (object as! UIImageView)
                    if imageView.tag <= (restaurantData.wystrojScore?.intValue)!
                    {
                        imageView.image = UIImage(named:ConstantsStruct.Buttons.smallStarSelected)
                    }
                    else
                    {
                        imageView.image = UIImage(named:ConstantsStruct.Buttons.smallStarNOTSelected)
                    }
                }
            }
            else
            {
                wystrojMiddleView.isHidden = true
            }
        }
        else
        {
            wystrojMiddleView.isHidden = true
        }

        if restaurantData.obslugaScore != nil
        {
            if restaurantData.obslugaScore != 0
            {
                for object in obslugaStarsArray
                {
                    let imageView = (object as! UIImageView)
                    if imageView.tag <= (restaurantData.obslugaScore?.intValue)!
                    {
                        imageView.image = UIImage(named:ConstantsStruct.Buttons.smallStarSelected)
                    }
                    else
                    {
                        imageView.image = UIImage(named:ConstantsStruct.Buttons.smallStarNOTSelected)
                    }
                }
            }
            else
            {
                obslugaRightView.isHidden = true
            }
        }
        else
        {
            obslugaRightView.isHidden = true
        }

        if kitchenLeftView.isHidden == true && wystrojMiddleView.isHidden == true && obslugaRightView.isHidden == true
        {
            kitchenLeftViewHeightConstr.constant = 0
            wystrojMiddleViewHeightC.constant = 0
            obslugaViewHeightC.constant = 0
        }
        
    }
    
    func getAllKitchenString() -> String
    {
        var kitchenString = ""
        if restaurantData.cuisineArray.count > 1
        {
            kitchenString = "Kuchnia: \(((restaurantData.cuisineArray.firstObject as! CuisinesObject).cuisineName?.capitalized)!)"
            
            for i in 1..<restaurantData.cuisineArray.count
            {
                kitchenString = kitchenString + ", \((restaurantData.cuisineArray[i] as! CuisinesObject).cuisineName!)"
            }
        }
        else if restaurantData.cuisineArray.count == 1
        {
            kitchenString = "Kuchnia: "+((restaurantData.cuisineArray.firstObject as! CuisinesObject).cuisineName!)
        }
        
        return kitchenString
    }
    
    func setGenerateButtonTittle()
    {
        if kuponCount == 0
        {
            generateButton.setTitle("Kup dostęp", for: UIControlState())
        }
        else
        {//Masz 3 kupony użyj
            if kuponCount % 10 == 1
            {
                generateButton.setTitle("Masz \(kuponCount) kupony, użyj", for: UIControlState())
                return
            }
            if kuponCount % 10 == 5 || kuponCount % 10 == 6 || kuponCount % 10 == 7 || kuponCount % 10 == 8 || kuponCount % 10 == 9
            {
                generateButton.setTitle("Masz \(kuponCount) kuponów, użyj", for: UIControlState())
                return
            }
        }
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: generateButton, setRoundedCorners: true, shouldHaveBorder: true);
    }
    
    func setupKuponCountButton()
    {
        if restaurantData.kuponAvailable != nil
        {
            kuponCount = restaurantData.kuponAvailable!.intValue
            if kuponCount == 0
            {
                generateButton.setTitle("Nie masz? Kup!", for: UIControlState())
                return
            }
            if kuponCount == 1 || kuponCount % 10 == 1
            {
                generateButton.setTitle("Masz 1 kupon użyj", for: UIControlState())
                return
            }
            if kuponCount == 2 || kuponCount == 3 || kuponCount == 4 || kuponCount % 10 == 2 || kuponCount % 10 == 3 || kuponCount % 10 == 4
            {
                generateButton.setTitle("Masz \(kuponCount) kupony użyj", for: UIControlState())
                return
            }
            else
            {
                generateButton.setTitle("Masz \(kuponCount) kuponów użyj", for: UIControlState())
            }
        }
    }
    
    @IBAction func buyKuponButtonClicked(_ sender: AnyObject)
    {
        if kuponCount == 0
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let inAppViewController = storyboard.instantiateViewController(withIdentifier: "InnAppPurchaseViewController") as!  InnAppPurchaseViewController
            self.navigationController?.show(inAppViewController, sender: nil)
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let kuponViewController = storyboard.instantiateViewController(withIdentifier: "KuponViewController") as!  KuponViewController
            kuponViewController.restaurantData.restaurantName = restaurantData.name!
            kuponViewController.restaurantData.restaurantId = (restaurantData.id! as NSString).integerValue
            kuponViewController.restaurantData.availableKupons = restaurantData.kuponAvailable?.intValue
            kuponViewController.restaurantData.totalKupons = restaurantData.kuponTotal?.intValue
            kuponViewController.restaurantData.address = restaurantData.address
            self.navigationController?.show(kuponViewController, sender: nil)
        }
    }

    @IBAction func openRestaurantLink(_ sender: AnyObject)
    {
        if (mailLabel.text?.characters.count)! > 0
        {
            
            let linkText = mailLabel.text! as String
            let callAllertController = UIAlertController(title:"" , message: "Otworzyć w przeglądarce?", preferredStyle: .alert)
            let cancellAction = UIAlertAction(title: "Nie", style: .cancel, handler: nil)
            let callAction = UIAlertAction(title: "Tak", style: .default, handler: { (self) in
                UIApplication.shared.openURL(URL(string: linkText)!)
            })
            callAllertController.addAction(callAction)
            callAllertController.addAction(cancellAction)
            DispatchQueue.main.async {
                self.present(callAllertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func callToRestaurant(_ sender: AnyObject)
    {
        if (phoneLabel.text?.characters.count)! > 0
        {
            var finalPhoneString = phoneLabel.text?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
            if phoneLabel.text!.hasPrefix("+48")
            {
                let index1 = finalPhoneString?.characters.index((finalPhoneString?.startIndex)!, offsetBy: 3)
                finalPhoneString = finalPhoneString?.substring(from: index1!)
            }
            let callAllertController = UIAlertController(title:"" , message: "Czy chcesz zadzwonić do restauracji?", preferredStyle: .alert)
            let cancellAction = UIAlertAction(title: "Nie", style: .cancel, handler: nil)
            let callAction = UIAlertAction(title: "Tak", style: .default, handler: { (self) in
                UIApplication.shared.openURL(URL(string: "tel://\(finalPhoneString!)")!)
            })
            callAllertController.addAction(callAction)
            callAllertController.addAction(cancellAction)
            DispatchQueue.main.async {
                self.present(callAllertController, animated: true, completion: nil)
            }

//            present(callAllertController, animated: true, completion: nil)
        }
    }
    @IBAction func showOnMap(_ sender: AnyObject)
    {
        let lat1 : NSString = restaurantData.lat! as NSString
        let lng1 : NSString = restaurantData.lng! as NSString
        
        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(restaurantData.name!)"
        let callAllertController = UIAlertController(title:"" , message: "Pokazać na mapie?", preferredStyle: .alert)
        let cancellAction = UIAlertAction(title: "Nie", style: .cancel, handler: nil)
        let callAction = UIAlertAction(title: "Tak", style: .default, handler: { (self) in
            mapItem.openInMaps(launchOptions: options)
        })
        callAllertController.addAction(callAction)
        callAllertController.addAction(cancellAction)
        DispatchQueue.main.async {
            self.present(callAllertController, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Collection controller delegate methods
    
    func collectionController(_ collectionController:CollectionViewController, scrolledToCellAtIndexPath indexPath:IndexPath)
    {
        setupSelectedImagesCount(at: (indexPath as NSIndexPath).row)
    }

    
    func setupSelectedImagesCount(at indexImage:Int)
    {
        for (index, image) in collectionImagesCountArray.enumerated()
        {
            
            if index == indexImage
            {
                (image as! UIImageView).image = UIImage(named: ConstantsStruct.Buttons.dotFiled)
            }
            else
            {
                (image as! UIImageView).image = UIImage(named: ConstantsStruct.Buttons.dotEmpty)
            }
        }
    }
    
    @IBAction func showHideMapView(_ sender: AnyObject)
    {
         controllerMap.setCameraOnMarker((restaurantData.lng! as NSString).doubleValue, lat: (restaurantData.lat! as NSString).doubleValue)
        DispatchQueue.main.async {
            if self.mapView.isHidden == true
            {
                self.mapsImageView.image = UIImage(named: ConstantsStruct.Buttons.showCollectionView)
                UITableView.transition(with: self.collectionView, duration: self.animationDuration, options: .transitionFlipFromRight, animations: {
                    self.collectionView.isHidden = true
                    }, completion: { (Bool) in
                        UITableView.transition(with: self.mapView, duration: self.animationDuration, options: .transitionFlipFromRight, animations: {
                            self.mapView.isHidden = false
                            }, completion: { (Bool) in
                        })
                })
            }
            else
            {
                self.mapsImageView.image = UIImage(named: ConstantsStruct.Buttons.showMapButton)
                UIView.transition(with: self.mapView, duration: self.animationDuration, options: .transitionFlipFromLeft, animations:
                    {
                        self.mapView.isHidden = true
                        
                    },completion: { (Bool) in
                        
                        UITableView.transition(with: self.collectionView, duration: self.animationDuration, options: .transitionFlipFromLeft, animations:
                            {
                                self.collectionView.isHidden = false
                                
                            }, completion: { (Bool) in
                        })
                })
            }

        }
    }
}
