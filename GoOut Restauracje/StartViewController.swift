//
//  ViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD
import RealmSwift
import MapKit
import Firebase

class StartViewController: RootViewController, TableControllerDelegate, CLLocationManagerDelegate, MapControllerDelegate
{
    @IBOutlet weak var upperSearchView: UIView!
    @IBOutlet weak var whatIsGoingOutView: UIView!
    @IBOutlet weak var whatIsGoOutButton: UIButton!
    @IBOutlet weak var youCanUseView: UIView!
    @IBOutlet weak var youCityButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var kuponyView: UIView!
    @IBOutlet weak var whatIsGoingOutViewHeight: NSLayoutConstraint!
    @IBOutlet weak var resetFiltersView: UIView!
    @IBOutlet weak var rightResetFilterView: UIView!
    @IBOutlet weak var restaurantCountLabel: UILabel!
    @IBOutlet weak var kuponCountLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var showMapButton: UIButton!
    
    var filteringResults:NSArray?
    let tableController = StartViewTableController()
    var restaurantsListArray:NSArray?
    var userLocation:(lat:Double, lon:Double) = (0.0,0.0)
    let locationManager = CLLocationManager()
    var shouldUpdateArray = false
    let sortingController = FilteringController.sharedInstance
    var refreshControl: UIRefreshControl!
    var timer:Timer?
    let controllerMap = MapController()
    let animationDuration = 0.5
    let timerInterval = 20
    var previousUserLocation:CLLocation?
    var currentUserLocation:CLLocation?
    var locationcheck = 0
    let image1View = UIImageView()
    let image1button = UIButton()
    let image2View = UIImageView()
    let image2button = UIButton()
    let image3View = UIImageView()
    let image3button = UIButton()
    let image4View = UIImageView()
    let image4button = UIButton()
    let image5button =  UIButton()
    var hudShowAppear = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addRefreshControllerToTableView()
        setupButtonViewLabels()
        self.setTableData()
        whatIsGoingOutHide(shouldHideWhatIsGOINGOUT())
        setAppLaunchedByTheFirts()
        shouldAddStatusButton = true
        shouldAddMessageButton = true
        controllerMap.mapDelegate = self
        if filteringResults != nil
        {
            if AppManager.sharedInstance.sortingMethodsChanged()
            {
                rightResetFilterView.isHidden = false
            }
            else
            {
                rightResetFilterView.isHidden = true
            }
            if (filteringResults?.count)! > 0
            {
                restaurantsListArray = filteringResults
                self.reloadTableView(withDataArray: filteringResults!)
                self.restaurantCountLabel.text = "\(filteringResults!.count)"
            }
        }
        else
        {
            shouldUpdateArray = true
        }
        getUserCurrentPosition()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if controllerMap.mapView == nil
        {
            controllerMap.setupMap(mapView)
            controllerMap.canSelectMarker = true
        }
        self.getUserKupons()

        if timer == nil
        {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(StartViewController.getRestaurantListBecomeActive), userInfo: nil, repeats: true)
        }
        else if timer?.isValid == false
        {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: #selector(StartViewController.getRestaurantListBecomeActive), userInfo: nil, repeats: true)

        }
        if AppManager.sharedInstance.forceReloadRestaurantList == true
        {
            AppManager.sharedInstance.forceReloadRestaurantList = false
            cleanRestaurantListDataBase()
            getRestaurationList()
        }
        if AppManager.sharedInstance.forceOpenMessagesView == true
        {
            AppManager.sharedInstance.forceOpenMessagesView = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mViewc = storyboard.instantiateViewController(withIdentifier: "MessagesViewController")
            navigationController?.pushViewController(mViewc, animated: true)
        }
        hudShowAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        hudShowAppear = false
        //timer?.invalidate()
        //deregisterNotifications()
    }
    
    func shouldUpdateLocation(previousLocation:CLLocation?, currentLocation:CLLocation?) -> Bool
    {
        locationcheck += 1
        print(locationcheck)
        if previousLocation == nil || currentLocation == nil
        {
            return true
        }
        if previousLocation != nil && currentLocation != nil
        {
            if previousLocation?.coordinate.latitude != 0.0
            {
                if currentLocation?.coordinate.latitude != 0.0
                {
                    if currentLocation!.distance(from: previousLocation!) > 100
                    {
                        
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func addRefreshControllerToTableView()
    {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(StartViewController.pullDownToRefreshUpdate), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func pullDownToRefreshUpdate()
    {
        cleanRestaurantListDataBase()
        getRestaurationList()

    }
    
    func getRestaurantListBecomeActive()
    {
        print("location check")
        if shouldUpdateLocation(previousLocation: previousUserLocation, currentLocation: currentUserLocation)
        {
            cleanRestaurantListDataBase()
            getRestaurationList()
        }
    }

    func shouldHideWhatIsGOINGOUT() -> Bool
    {
        if UserDefaults.standard.value(forKey: "appAlreadyLaunched") != nil
        {
            if UserDefaults.standard.value(forKey: "appAlreadyLaunched") as! String == "true"
            {
                return true
            }
        }
        return false
    }
    
    func setAppLaunchedByTheFirts()
    {
        UserDefaults.standard.setValue("true", forKey: "appAlreadyLaunched")
    }
    
    func getRestaurationList()
    {
        //HUD.show(.progress)
        let restaurantsList = getAllRestaurantDataFromRealm()
        if restaurantsList.count > 0
        {
            restaurantsListArray = restaurantsList as NSArray?
            print("tu jest wywyrotka:")
            let results = sortingController.sortArrayBySelectedFilters(restaurantsList as NSArray)
            DispatchQueue.main.async {
                self.reloadTableView(withDataArray:results)
                self.restaurantCountLabel.text = "\(results.count)"
                self.refreshControl.endRefreshing()
            }
        }
        else
        {
            if hudShowAppear == true && self.restaurantCountLabel.text != nil && self.restaurantCountLabel.text == "0"{
                HUD.show(.progress)
            }
            if AppManager.sharedInstance.requestFinished == true
            {
                RestClient.sharedInstance.getRestaurantsListNearUser(userLocation.lat, longitude: userLocation.lon) { (restaurantList, succes) in
                DispatchQueue.main.async {
                    
                    print("REquest ======")
                    print("----------- %@     %@", self.userLocation.lat, self.userLocation.lon)
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
                        
                        let restaurantRealmBridge = BridgeConvertingClass()
                        restaurantRealmBridge.addListModelToRealm(restaurantList)
                        AppManager.sharedInstance.list = restaurantList
                        let results = self.sortingController.sortArrayBySelectedFilters(restaurantList)
                        self.restaurantsListArray = results
                        self.reloadTableView(withDataArray:results)
                        self.restaurantCountLabel.text = "\(results.count)"
                        self.refreshControl.endRefreshing()

                        
                        if self.controllerMap.mapView == nil
                        {
                             self.controllerMap.setResturantsToMap(fromArray: results)
                        }
                        self.previousUserLocation = self.currentUserLocation
                        HUD.hide()
                        
                    }
                    else
                    {
                        let results = self.sortingController.sortArrayBySelectedFilters(restaurantList)
                        self.restaurantsListArray = results
                        self.reloadTableView(withDataArray:results)
                        self.restaurantCountLabel.text = "\(results.count)"
                        self.refreshControl.endRefreshing()
                        HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                        HUD.hide(afterDelay: 2.0)
                        
                    }
                }
            }
        }
    }
        AppManager.sharedInstance.forceReloadRestaurantList = false
    }
    
    func getUserKupons()
    {
        AppManager.sharedInstance.kupons.totalKupons = 0
        AppManager.sharedInstance.kupons.availableKupons = 0
        RestClient.sharedInstance.getUserKuponsCount { (totalKupons, availableKupons, daysToEnd, succes) in
            DispatchQueue.main.async
            {
                if succes
                {
                    AppManager.sharedInstance.kupons.totalKupons = totalKupons
                    AppManager.sharedInstance.kupons.availableKupons = availableKupons
                    if (totalKupons?.intValue)! > 0
                    {
                        FIRMessaging.messaging().subscribe(toTopic: "/topics/globalUser")
                    }
                }
                    self.kuponCountLabel.text = "\(AppManager.sharedInstance.kupons.availableKupons!)/\(AppManager.sharedInstance.kupons.totalKupons!)"
            }
        }
    }
    
    func getAllRestaurantDataFromRealm() -> Array<RealmRestaurantListObject>
    {
        let realm = try! Realm()
        let result = realm.objects(RealmRestaurantListObject.self)
        if result.count > 0
        {
            return Array(result)
        }
        return Array()
    }
    
    func cleanRestaurantListDataBase()
    {
        let realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    func whatIsGoingOutHide(_ hide:Bool)
    {
        if hide
        {
            whatIsGoingOutView.isHidden = true
            whatIsGoingOutViewHeight.constant = 10;
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            image5button.frame = (frame: CGRect(x:0,y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)) as! CGRect
            image5button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
            image5button.addTarget(self, action: #selector(image5buttonAction), for: .touchUpInside)
            appDelegate.window!.addSubview(image5button)
            
            image4View.image = UIImage(named: ConstantsStruct.whatIsGoout4)
            image4View.frame = CGRect(x:15,y:55, width:UIScreen.main.bounds.width-30, height:(UIScreen.main.bounds.width-30)*1.1226)
            appDelegate.window!.addSubview(image4View)
            image3View.image = UIImage(named: ConstantsStruct.whatIsGoout3)
            image3View.frame = CGRect(x:15,y:55, width:UIScreen.main.bounds.width-30, height:(UIScreen.main.bounds.width-30)*1.1226)
            appDelegate.window!.addSubview(image3View)
            image2View.image = UIImage(named: ConstantsStruct.whatIsGoout2)
            image2View.frame = CGRect(x:15,y:55, width:UIScreen.main.bounds.width-30, height:(UIScreen.main.bounds.width-30)*1.1226)
            appDelegate.window!.addSubview(image2View)
            image1View.image = UIImage(named: ConstantsStruct.whatIsGoout1)
            image1View.frame = CGRect(x:15,y:55, width:UIScreen.main.bounds.width-30, height:(UIScreen.main.bounds.width-30)*1.1226)
            appDelegate.window!.addSubview(image1View)
            
            image4button.frame = (frame: CGRect(x:0,y:60, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.width)) as! CGRect
            image4button.addTarget(self, action: #selector(image4buttonAction), for: .touchUpInside)
            appDelegate.window!.addSubview(image4button)
            image3button.frame = (frame: CGRect(x:0,y:60, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.width)) as! CGRect
            image3button.addTarget(self, action: #selector(image3buttonAction), for: .touchUpInside)
            appDelegate.window!.addSubview(image3button)
            image2button.frame = (frame: CGRect(x:0,y:60, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.width)) as! CGRect
            image2button.addTarget(self, action: #selector(image2buttonAction), for: .touchUpInside)
            appDelegate.window!.addSubview(image2button)
            image1button.frame = (frame: CGRect(x:0,y:60, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.width)) as! CGRect
            image1button.addTarget(self, action: #selector(image1buttonAction), for: .touchUpInside)
            appDelegate.window!.addSubview(image1button)
            
        }
    }
    
    func image1buttonAction(sender: UIButton!) {
        image1View.isHidden = true
        image1button.isHidden = true
    }
    func image2buttonAction(sender: UIButton!) {
        image2View.isHidden = true
        image2button.isHidden = true
    }
    func image3buttonAction(sender: UIButton!) {
        image3View.isHidden = true
        image3button.isHidden = true
    }
    func image4buttonAction(sender: UIButton!) {
        image4View.isHidden = true
        image4button.isHidden = true
        image5button.isHidden = true
    }
    
    func image5buttonAction(sender: UIButton!){
        
    }
    
    @IBAction func whatIsGooutButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let infoView = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as!  HelpViewController
        infoView.buttonClicked = "whatIsGoingOut"
        self.navigationController?.show(infoView, sender: nil)
    }
    
    func reloadTableView(withDataArray array:NSArray)
    {
        tableController.dataArray = array
        tableController.reloadTableView()
        controllerMap.setResturantsToMap(fromArray: restaurantsListArray!)
    }
    
    @IBAction func resetFiltersButtonClicked(_ sender: AnyObject)
    {
        restaurantsListArray = AppManager.sharedInstance.list
        AppManager.sharedInstance.resetFilters()
        let results = sortingController.sortArrayBySelectedFilters(restaurantsListArray!)
        self.reloadTableView(withDataArray: results)
        self.restaurantCountLabel.text = "\(results.count)"
        rightResetFilterView.isHidden = true
    }

    @IBAction func openSearchConfiguration(_ sender: AnyObject)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterringView = storyboard.instantiateViewController(withIdentifier: "FilteringViewController") as!  FilteringViewController
        self.navigationController?.show(filterringView, sender: nil)
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kuponyView, setRoundedCorners: true, shouldHaveBorder: true);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: resetFiltersView, setRoundedCorners: true, shouldHaveBorder: true);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: whatIsGoOutButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: youCityButton, setRoundedCorners: true, shouldHaveBorder: false);
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
        let restaurantBookmarkViewController = "RestaurantBookmarkViewController"
        let storyboardIdentifier = "Main"
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let restaurantBookmarkView:RestaurantBookmarkViewController = storyboard.instantiateViewController(withIdentifier: restaurantBookmarkViewController) as! RestaurantBookmarkViewController
        if (restaurantsListArray![(indexPath as NSIndexPath).row] as AnyObject) is RestaurantListModel
        {
            restaurantBookmarkView.selectedRestaurantId = (restaurantsListArray![(indexPath as NSIndexPath).row] as! RestaurantListModel).id
        }
        else if (restaurantsListArray![(indexPath as NSIndexPath).row] as AnyObject) is RealmRestaurantListObject
        {
            restaurantBookmarkView.selectedRestaurantId = (restaurantsListArray![(indexPath as NSIndexPath).row] as! RealmRestaurantListObject).id
        }
        
        self.navigationController!.show(restaurantBookmarkView, sender: nil);
    }
    
    @IBAction func mapsButtonClicked(_ sender: AnyObject)
    {
        if tableView.isHidden == false
        {
            showMapButton.setImage(UIImage(named:ConstantsStruct.Buttons.showTableButton), for: UIControlState())
            controllerMap.setResturantsToMap(fromArray: restaurantsListArray)
            controllerMap.setupCameraOnUserPosition(userLocation.lon, lat: userLocation.lat, fromStandartPosition: 52.229676, lonCity: 21.012229)
            UITableView.transition(with: tableView, duration: animationDuration, options: .transitionFlipFromRight, animations: {
                self.tableView.isHidden = true
                }, completion: { (Bool) in
                    UITableView.transition(with: self.mapView, duration: self.animationDuration, options: .transitionFlipFromRight, animations: {
                        self.mapView.isHidden = false
                        }, completion: { (Bool) in
                    })
            })
        }
        else
        {
            UIView.transition(with: mapView, duration: animationDuration, options: .transitionFlipFromLeft, animations: {
                self.mapView.isHidden = true
                }, completion: { (Bool) in
                    
                    UITableView.transition(with: self.tableView, duration: self.animationDuration, options: .transitionFlipFromLeft, animations: {
                        self.tableView.isHidden = false
                        }, completion: { (Bool) in
                    })
            })
            showMapButton.setImage(UIImage(named:ConstantsStruct.Buttons.showMapButton), for: UIControlState())
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
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
            print("denied")
            if shouldUpdateArray
            {
                shouldUpdateArray = false
                getRestaurationList()
            }
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access grnated, restaurants list get by locationManager")
            }
        }
    }
    
    //MARK: Location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentUserLocation = locations.last
        userLocation.lat = (manager.location?.coordinate.latitude)!
        userLocation.lon = (manager.location?.coordinate.longitude)!
        if shouldUpdateArray
        {
            shouldUpdateArray = false
            getRestaurationList()
        }
    }
    
    //MARK: Map controller delegate methods
    
    func mapController(_ mapController: MapController, tappedMarker marker: GMSMarker)
    {
        let restaurantBookmarkViewController = "RestaurantBookmarkViewController"
        let storyboardIdentifier = "Main"
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let restaurantBookmarkView:RestaurantBookmarkViewController = storyboard.instantiateViewController(withIdentifier: restaurantBookmarkViewController) as! RestaurantBookmarkViewController
        restaurantBookmarkView.selectedRestaurantId = (marker.userData as! RestaurantListModel).id
        self.navigationController!.show(restaurantBookmarkView, sender: nil);
    }
}

