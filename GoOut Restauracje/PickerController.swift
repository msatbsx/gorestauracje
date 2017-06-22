//
//  PickerController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 03/09/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

protocol PickerControllerDelegate
{
    func pickerController(_ pickerController:PickerController, didSelectRowAtIndex index:Int)
}

class PickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource
{
    var parentPickerView:UIPickerView?
    var pickerDelegate:PickerControllerDelegate! = nil
    var parentViewController:UIViewController?
    var pickerArray = NSArray()
    var pickerHeight:CGFloat = 0.0
    var toolBar = UIToolbar()
    var rowIndex = 0
    
    
    var upperSortingButton:(kitchen:Bool, dzielnica:Bool, city:Bool, sorting:Bool) = (false, false, false, false)
    
    func setupPickerView()
    {
        parentPickerView?.delegate = self
        parentPickerView?.dataSource = self
    }
    
    func reloadPickerView(withArray array:NSArray)
    {
        if parentPickerView?.isHidden == true
        {
            parentPickerView?.isHidden = false
            addToolbarToPicker()
        }
        pickerArray = array
        parentPickerView?.reloadAllComponents()
    }
    
    func addToolbarToPicker()
    {
        let pickerPosition = (parentViewController?.view.frame.size.height)! - pickerHeight// - pickerHeight
        toolBar = UIToolbar(frame: CGRect(x: 0, y: pickerPosition, width: self.parentPickerView!.frame.size.width, height: 49));
        toolBar.barTintColor = ConstantsStruct.Colors.backgroundColor
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        let doneButton = UIBarButtonItem(title: "DALEJ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PickerController.pickerSelected));
        doneButton.tintColor = ConstantsStruct.Colors.whiteColor
        toolBar.setItems([flexSpace,doneButton], animated: false);
        parentViewController?.view.addSubview(toolBar);
    }
    
    func remoweToolbar()
    {
        toolBar.isHidden = true
    }
    
    func pickerSelected()
    {
        pickerDelegate.pickerController(self, didSelectRowAtIndex: rowIndex)
        hidePickerView()
        remoweToolbar()
    }
    
    func hidePickerView()
    {
        parentPickerView?.isHidden = true
    }
    
    //MARK:TableView delegate dataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerArray.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        var tittleString = ""
        if upperSortingButton.kitchen
        {
            if row == 0
            {
                tittleString = pickerArray[row] as! String
            }
            else
            {
                tittleString = (pickerArray[row] as! CityKitchenModel).name!
            }
        }
        if upperSortingButton.dzielnica
        {
            if row == 0
            {
                tittleString = pickerArray[row] as! String
            }
            else
            {
                tittleString = (pickerArray[row] as! DistrictModel).name!
            }
        }
        if upperSortingButton.city
        {
            tittleString = (pickerArray[row] as! CityListModel).name!
        }
        if upperSortingButton.sorting
        {
            tittleString = pickerArray[row] as! String
        }

        
        if pickerArray.count > 0
        {
            return NSAttributedString(string: tittleString, attributes: [NSForegroundColorAttributeName:ConstantsStruct.Colors.whiteColor])
        }
            return NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName:ConstantsStruct.Colors.whiteColor])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        rowIndex = row
//        pickerDelegate.pickerController(self, didSelectRowAtIndex: row)
//        hidePickerView()
    }
}
