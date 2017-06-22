//
//  MapController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 29/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

protocol MapControllerDelegate
{
    func mapController(_ mapController:MapController, tappedMarker marker:GMSMarker)
}

class MapController: NSObject, GMSMapViewDelegate
{
    
    var mapView:GMSMapView?
    var cameraPosition = GMSCameraPosition()
    var mapDelegate:MapControllerDelegate! = nil
    var canSelectMarker = false
    var bounds:GMSCoordinateBounds?
    
    func setupMap(_ mainView:UIView)
    {
        setMapToView(mainView)
    }
    
    fileprivate func setMapToView(_ mainView:UIView)
    {
        mapView = GMSMapView.map(withFrame: mainView.bounds, camera: cameraPosition)
        mapView!.isMyLocationEnabled = true
        mapView?.delegate = self
        mainView.addSubview(mapView!)
    }
    
    func setupCameraOnUserPosition(_ lng:Double, lat:Double, fromStandartPosition latCity:Double, lonCity:Double)
    {
        let customZoom:Float = 12.0
//        let destinationLocationCoordinate:CLLocation = CLLocation(latitude: latCity, longitude: lonCity)
//        let userLocationCoordinate:CLLocation = CLLocation(latitude: lat, longitude: lng)
//        let distance =  destinationLocationCoordinate.distance(from: userLocationCoordinate)
        
//        if distance / 1000 > 100
//        {
            cameraPosition = GMSCameraPosition.camera(withLatitude: latCity, longitude: lonCity, zoom: customZoom)
//        }
//        else
//        {
//            bounds = nil
//            cameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: customZoom)
//        }
        if mapView != nil
        {
            if bounds != nil
            {
                mapView?.animate(with: GMSCameraUpdate.fit(bounds!))
            }
            else
            {
               mapView?.camera = cameraPosition
            }
        }
    }
    
    func setResturantsToMap(fromArray resturantsArray:NSArray?)
    {
        if mapView != nil
        {
            mapView!.clear()
            if resturantsArray != nil
            {
                if resturantsArray!.count > 0
                {
                    let firstLocation = CLLocationCoordinate2DMake((resturantsArray?.firstObject as! RestaurantListModel).lat!, (resturantsArray?.firstObject as! RestaurantListModel).lng!)
                    bounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
                    
                    for restaurant in resturantsArray!
                    {
                        let rest  = restaurant as! RestaurantListModel
                        let marker = GMSMarker()
                        var resizedMarkerImage = UIImage(named: ConstantsStruct.Buttons.mapPin)
                        resizedMarkerImage = resizeImage(resizedMarkerImage!, newWidth: 30)
                        marker.icon = resizedMarkerImage
                        marker.position = CLLocationCoordinate2DMake(rest.lat!, rest.lng!)
                        marker.title = rest.name!
                        marker.userData = rest
                        bounds = bounds!.includingCoordinate(marker.position)
                        marker.map = mapView
                    }
                }
            }
        }
    }
    
    func setRestaurantTomap(_ restaurant:RestaurantDescription)
    {
        if mapView != nil
        {
            mapView!.clear()
            let marker = GMSMarker()
            var resizedMarkerImage = UIImage(named: ConstantsStruct.Buttons.mapPin)
            resizedMarkerImage = resizeImage(resizedMarkerImage!, newWidth: 30)
            marker.icon = resizedMarkerImage
            let latitude: Double = (restaurant.lat! as NSString).doubleValue
            let longitude: Double = (restaurant.lng! as NSString).doubleValue
            marker.position = CLLocationCoordinate2DMake(latitude, longitude)
            marker.title = restaurant.name!
            marker.userData = restaurant
            marker.map = mapView
        }
    }
    
    //MARK: Map delegate methods
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        if canSelectMarker
        {
            mapDelegate.mapController(self, tappedMarker: marker)
        }
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage
    {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func setCameraOnMarker(_ lng:Double, lat:Double)
    {
        let customZoom:Float = 12.0
        cameraPosition = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: customZoom)
        if mapView != nil
        {
            mapView?.camera = cameraPosition
        }
    }
}
