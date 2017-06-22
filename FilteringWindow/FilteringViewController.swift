//
//  FilteringViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 19/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD
//import RealmSwift
import MapKit

class FilteringViewController: RootViewController, PickerControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var leftSearchView: UIView!
    @IBOutlet weak var rightSearchView: UIView!
    @IBOutlet weak var fiteringTextField: UITextField!
    @IBOutlet weak var kuponsCountLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var restaurantTypeView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var statusButton: UIBarButtonItem!
    @IBOutlet weak var messagesButton: UIBarButtonItem!
    @IBOutlet weak var firstTypeButton: UIButton!
    @IBOutlet weak var secondTypeButton: UIButton!
    @IBOutlet weak var thirdTypeButton: UIButton!
    
    @IBOutlet weak var kitchenSortingButton: UIButton!
    @IBOutlet weak var dzielnicaSortingButton: UIButton!
    @IBOutlet weak var citySortingButton: UIButton!
    @IBOutlet weak var sortingMethodButton: UIButton!
    @IBOutlet weak var searchingResultsButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerHeightConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var sortingMethodsArray:NSArray?
    var upperSortingButton:(kitchen:Bool, dzielnica:Bool, city:Bool, sorting:Bool) = (false, false, false, false)
    var colorSortingButton:(first:Bool, second:Bool, third:Bool) = (true, true, true)
    let pickerController = PickerController()
    var dzielnicaObjectsArray = NSMutableArray()
    var kitchenObjectsArray = NSMutableArray()
    var sortedByLocation = false
    var finalSortedArray:NSArray?
    var lookingString = ""
    
    var userLocationArray = NSArray()
    var userLocation:(lat:Double, lon:Double) = (0.0,0.0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupAllSortings()
        finalSortedArray = AppManager.sharedInstance.list
        setupButtonViewLabels()
        setPickerView()
        shouldAddMessageButton = true
        shouldAddBackButton = true
        getUserCurrentPosition()
        if finalSortedArray != nil
        {
            sortResultArray(AppManager.sharedInstance.list)
        }
        getUserCurrentPosition()
        getAllrequests()
        fiteringTextField.delegate = self
        fiteringTextField.addTarget(self, action: #selector(FilteringViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FilteringViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setupKuponsCount()
    }

    func setupKuponsCount()
    {
        kuponsCountLabel.text = "\(AppManager.sharedInstance.kupons.availableKupons!)/\(AppManager.sharedInstance.kupons.totalKupons!)"
    }
    
    func getAllrequests()
    {
        getCityList { (succes) in
            if succes
            {
                self.getDistrictList()
            }
        }
    }
    
    func textFieldDidChange(_ textField: UITextField)
    {
        lookingString = textField.text!
        AppManager.sharedInstance.sortingMethods.name = lookingString
        sortResultArray(AppManager.sharedInstance.list)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        fiteringTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        lookingString = textField.text!
        sortResultArray(AppManager.sharedInstance.list)
        return true
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func setupAllSortings()
    {
        if AppManager.sharedInstance.sortingMethods.city != ""
        {
            citySortingButton.setTitle(AppManager.sharedInstance.sortingMethods.city, for: UIControlState())
        }
        if AppManager.sharedInstance.sortingMethods.districtName != ""
        {
            dzielnicaSortingButton.setTitle(AppManager.sharedInstance.sortingMethods.districtName, for: UIControlState())
        }
        if AppManager.sharedInstance.sortingMethods.kitchenName != ""
        {
            kitchenSortingButton.setTitle(AppManager.sharedInstance.sortingMethods.kitchenName, for: UIControlState())
        }
        sortingMethodButton.setTitle(AppManager.sharedInstance.sortingMethods.locationSorting, for: UIControlState())
        if AppManager.sharedInstance.colorSortingMethods.bronze
        {
            thirdTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.bronzeButtonOn), for: UIControlState())
        }
        else
        {
            thirdTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.bronzeButtonOff), for: UIControlState())
        }
        if AppManager.sharedInstance.colorSortingMethods.silver
        {
            secondTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.silverButtonOn), for: UIControlState())
        }
        else
        {
            secondTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.silverButtonOff), for: UIControlState())
        }
        if AppManager.sharedInstance.colorSortingMethods.gold
        {
            firstTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.goldenButtonOn), for: UIControlState())
        }
        else
        {
            firstTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.goldenButtonOff), for: UIControlState())
        }
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: leftSearchView, setRoundedCorners: true, shouldHaveBorder: true);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: rightSearchView, setRoundedCorners: true, shouldHaveBorder: true);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: firstTypeButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: secondTypeButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: thirdTypeButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kitchenSortingButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: dzielnicaSortingButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: citySortingButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: sortingMethodButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: searchingResultsButton, setRoundedCorners: true, shouldHaveBorder: true);
    }
    
    @IBAction func firstTypeButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        if colorSortingButton.first == true
        {
            colorSortingButton.first = false
            firstTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.goldenButtonOff), for: UIControlState())
            AppManager.sharedInstance.colorSortingMethods.gold = false
        }
        else
        {
            colorSortingButton.first = true
            firstTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.goldenButtonOn), for: UIControlState())
            AppManager.sharedInstance.colorSortingMethods.gold = true
        }
        if finalSortedArray != nil
        {
            sortResultArray(AppManager.sharedInstance.list)
        }
    }

    @IBAction func secondTypeButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        if colorSortingButton.second == true
        {
            colorSortingButton.second = false
            secondTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.silverButtonOff), for: UIControlState())
            AppManager.sharedInstance.colorSortingMethods.silver = false
        }
        else
        {
            colorSortingButton.second = true
            secondTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.silverButtonOn), for: UIControlState())
            AppManager.sharedInstance.colorSortingMethods.silver = true
        }
        if finalSortedArray != nil
        {
            sortResultArray(AppManager.sharedInstance.list)
        }
    }
    
    @IBAction func thirdtTypeButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        if colorSortingButton.third == true
        {
            colorSortingButton.third = false
            thirdTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.bronzeButtonOff), for: UIControlState())
            AppManager.sharedInstance.colorSortingMethods.bronze = false
        }
        else
        {
            colorSortingButton.third = true
            thirdTypeButton.setImage(UIImage(named: ConstantsStruct.Buttons.bronzeButtonOn), for: UIControlState())
            AppManager.sharedInstance.colorSortingMethods.bronze = true
        }
        if finalSortedArray != nil
        {
            sortResultArray(AppManager.sharedInstance.list)
        }
    }

    //MARK: - Sorting IBActions
    
    @IBAction func citySortingButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        self.upperSortingButton = (false, false, true, false)
        self.pickerController.upperSortingButton = self.upperSortingButton
        pickerController.reloadPickerView(withArray: AppManager.sharedInstance.cityList)
    }
    
    @IBAction func dzielnicaButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        self.upperSortingButton = (false, true, false, false)
        self.pickerController.upperSortingButton = self.upperSortingButton
        pickerController.reloadPickerView(withArray: AppManager.sharedInstance.districtList)
    }
    
    @IBAction func kitchenButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        self.upperSortingButton = (true, false, false, false)
        self.pickerController.upperSortingButton = self.upperSortingButton
        pickerController.reloadPickerView(withArray: AppManager.sharedInstance.kitchenList)
    }
    
    @IBAction func sortingMethodButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        upperSortingButton = (false, false, false, true)
        sortingMethodsArray = ["Alfabetycznie", "Według lokalizacji"]
        self.pickerController.upperSortingButton = self.upperSortingButton
        pickerController.reloadPickerView(withArray: sortingMethodsArray!)
    }
    
    @IBAction func searcingResultsButtonClicked(_ sender: AnyObject)
    {
        view.endEditing(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startView = storyboard.instantiateViewController(withIdentifier: "StartViewController") as!  StartViewController
        startView.filteringResults = finalSortedArray
        self.navigationController?.show(startView, sender: nil)
    }
    
    func getCityList(_ completion:@escaping ( _ succes:Bool) -> Void)
    {
        if AppManager.sharedInstance.cityList.count == 0
        {
            HUD.show(.progress)
            RestClient.sharedInstance.getCityList { (cityListArray, succes) in
                DispatchQueue.main.async {
                    if succes
                    {
                        AppManager.sharedInstance.cityId = (cityListArray.firstObject as! CityListModel).id!
                        HUD.hide()
                        self.sortingMethodsArray = cityListArray
                        AppManager.sharedInstance.cityList = cityListArray
                        
                        self.citySortingButton.setTitle((AppManager.sharedInstance.cityList.firstObject as! CityListModel).name, for: UIControlState())
                        completion(true)
                    }
                    else
                    {
                        HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                        HUD.hide(afterDelay: 2.0)
                        completion(false)
                    }

                }
            }
        }
        else
        {
            AppManager.sharedInstance.cityId = (AppManager.sharedInstance.cityList.firstObject as! CityListModel).id!

            sortingMethodsArray = AppManager.sharedInstance.cityList
            citySortingButton.setTitle((AppManager.sharedInstance.cityList.firstObject as! CityListModel).name, for: UIControlState())
            completion(true)
        }
        
    }
    
    func getDistrictList()
    {
        if dzielnicaObjectsArray.count == 0
        {
            HUD.show(.progress)
            RestClient.sharedInstance.getKitchenType(AppManager.sharedInstance.cityId, completion: { (districtNameArray, kitchenNameArray, succes) in
                DispatchQueue.main.async {
                    if succes
                    {
                        self.dzielnicaObjectsArray.add("Wszystkie")
                        self.kitchenObjectsArray.add("Wszystkie")
                        self.dzielnicaObjectsArray.addObjects(from: districtNameArray as [AnyObject])
                        self.kitchenObjectsArray.addObjects(from: kitchenNameArray as [AnyObject])
                        AppManager.sharedInstance.districtList  = self.dzielnicaObjectsArray
                        AppManager.sharedInstance.kitchenList = self.kitchenObjectsArray
                        HUD.hide()
                        
                        self.sortingMethodsArray = self.dzielnicaObjectsArray
                    }
                    else
                    {
                        HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                        HUD.hide(afterDelay: 2.0)
                    }
                }
            })
        }
        else
        {
            self.upperSortingButton = (false, true, false, false)
            self.sortingMethodsArray = self.dzielnicaObjectsArray
        }
    }

    //MARK: - setting picker view
    
    func setPickerView()
    {
        pickerController.parentPickerView = pickerView
        pickerController.parentViewController = self
        pickerController.pickerDelegate = self
        pickerController.pickerHeight = pickerHeightConstraint.constant
        pickerController.setupPickerView()
    }
    
    func pickerController(_ pickerController: PickerController, didSelectRowAtIndex index: Int)
    {
        if upperSortingButton.city
        {
            AppManager.sharedInstance.cityId = (AppManager.sharedInstance.cityList[index] as! CityListModel).id!
            citySortingButton.setTitle((AppManager.sharedInstance.cityList[index] as! CityListModel).name, for: UIControlState())
            AppManager.sharedInstance.sortingMethods.district = ""
            AppManager.sharedInstance.sortingMethods.kitchen = ""
            AppManager.sharedInstance.sortingMethods.kitchenName = ""
            AppManager.sharedInstance.sortingMethods.districtName = ""
            AppManager.sharedInstance.sortingMethods.nearest = false
        }
        
        if upperSortingButton.dzielnica
        {
            if index == 0
            {
                AppManager.sharedInstance.sortingMethods.district = ""
                AppManager.sharedInstance.sortingMethods.districtName = ""
                dzielnicaSortingButton.setTitle("Dzielnica", for: UIControlState())
                if finalSortedArray != nil
                {
                    sortResultArray(AppManager.sharedInstance.list)
                }
                return
            }
            dzielnicaSortingButton.setTitle((AppManager.sharedInstance.districtList[index] as! DistrictModel).name, for: UIControlState())
            AppManager.sharedInstance.sortingMethods.district = (AppManager.sharedInstance.districtList[index] as! DistrictModel).id!
            AppManager.sharedInstance.sortingMethods.districtName = (AppManager.sharedInstance.districtList[index] as! DistrictModel).name!
        }
        
        if upperSortingButton.kitchen
        {
            if index == 0
            {
                AppManager.sharedInstance.sortingMethods.kitchen = ""
                AppManager.sharedInstance.sortingMethods.kitchenName = ""
                kitchenSortingButton.setTitle("Kuchnia", for: UIControlState())
                if finalSortedArray != nil
                {
                    sortResultArray(AppManager.sharedInstance.list)
                }
                return
            }
            kitchenSortingButton.setTitle((AppManager.sharedInstance.kitchenList[index] as! CityKitchenModel).name, for: UIControlState())
            AppManager.sharedInstance.sortingMethods.kitchen = (AppManager.sharedInstance.kitchenList[index] as! CityKitchenModel).id!
            AppManager.sharedInstance.sortingMethods.kitchenName = (AppManager.sharedInstance.kitchenList[index] as! CityKitchenModel).name!
            AppManager.sharedInstance.sortingMethods.district = ""
            AppManager.sharedInstance.sortingMethods.districtName = ""
        }
        
        if upperSortingButton.sorting
        {
            sortingMethodButton.setTitle(sortingMethodsArray![index] as? String, for: UIControlState())
            if sortingMethodsArray![index] as? String == "Według lokalizacji"
            {
                AppManager.sharedInstance.sortingMethods.nearest = true
                AppManager.sharedInstance.sortingMethods.locationSorting = "Według lokalizacji"
            }
            else
            {
                AppManager.sharedInstance.sortingMethods.locationSorting = "Alfabetycznie"
                AppManager.sharedInstance.sortingMethods.nearest = false
            }
        }
        
        if finalSortedArray != nil
        {
            sortResultArray(AppManager.sharedInstance.list)
        }
    }
    
    func getUserCurrentPosition()
    {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: Location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        userLocation.lat = (manager.location?.coordinate.latitude)!
        userLocation.lon = (manager.location?.coordinate.longitude)!
    }

    func sortResultArray(_ resultArray:NSArray)
    {
        var firstResultArray = resultArray
        firstResultArray = getArrayFromLastSorting(firstResultArray, lookingString: lookingString)
        finalSortedArray = firstResultArray
        self.searchingResultsButton.setTitle("Wyszukano \(self.finalSortedArray!.count) - pokaż", for: UIControlState())
    }
    
    func getLocationFilteredArray() -> NSArray
    {
        var locationResultArray = NSArray()
        if userLocationArray.count == 0
        {
            HUD.show(.progress)
            if userLocation.lat != 0.0 && userLocation.lon != 0.0
            {
                RestClient.sharedInstance.getRestaurantsListNearUser(userLocation.lat, longitude: userLocation.lon) { (restaurantList, succes) in
                    
                    DispatchQueue.main.async {
                        if succes
                        {
                            if self.userLocation.lat == 0.0 && self.userLocation.lon == 0.0
                            {
                                AppManager.sharedInstance.hideDistance = true
                            }
                            else
                            {
                                AppManager.sharedInstance.hideDistance = false
                            }
                            
                            locationResultArray = restaurantList
                            self.userLocationArray = restaurantList
                            HUD.hide()
                            self.finalSortedArray = self.getArrayFromLastSorting(locationResultArray, lookingString: self.lookingString)
                            self.searchingResultsButton.setTitle("Wyszukano \(self.finalSortedArray!.count) - pokaż", for: UIControlState())
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
                HUD.show(.labeledError(title: "Błąd", subtitle: "Proszę udostępnić usługi lokalizacji dla aplikacji GoOut Restauracje"))
                HUD.hide(afterDelay: 2.0)
            }
        }
        else
        {
            locationResultArray = userLocationArray
            self.finalSortedArray = self.getArrayFromLastSorting(locationResultArray, lookingString: lookingString)
            self.searchingResultsButton.setTitle("Wyszukano \(self.finalSortedArray!.count) - pokaż", for: UIControlState())

        }
        return locationResultArray
    }
    
    func getArrayFromLastSorting(_ array:NSArray, lookingString:String) -> NSArray
    {
        let sortingController = FilteringController.sharedInstance
        if lookingString != "Szukaj frazy..."
        {
            sortingController.nameForSorting = lookingString
            AppManager.sharedInstance.sortingMethods.name = lookingString
        }
        else
        {
            sortingController.nameForSorting = ""
            AppManager.sharedInstance.sortingMethods.name = ""
        }
        return sortingController.sortArrayBySelectedFilters(array)
   }
}
