//
//  ViewConfigurator.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 18/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit

class ViewConfigurator: NSObject
{
    class func createRoundedCornersAndBorderWidth(viewObject:AnyObject, setRoundedCorners:Bool, shouldHaveBorder:Bool)
    {
        let cornerRadius:CGFloat = 9.0
        var borderWidth:CGFloat = 1.0
        if !shouldHaveBorder
        {
            borderWidth = 0.0
        }
        
        if viewObject is UIButton
        {
            (viewObject as! UIButton).clipsToBounds = true;
            (viewObject as! UIButton).layer.borderWidth = borderWidth;
            (viewObject as! UIButton).layer.borderColor = UIColor.gray.cgColor;
            if (setRoundedCorners)
            {
                (viewObject as! UIButton).layer.cornerRadius = cornerRadius;
            }
        }
        if viewObject is UILabel
        {
            (viewObject as! UILabel).clipsToBounds = true;
            (viewObject as! UILabel).layer.borderWidth = borderWidth;
            (viewObject as! UILabel).layer.borderColor = UIColor.gray.cgColor;
            if (setRoundedCorners)
            {
                (viewObject as! UILabel).layer.cornerRadius = cornerRadius;
            }
        }
        if viewObject is UIView
        {
            (viewObject as! UIView).clipsToBounds = true;
            (viewObject as! UIView).layer.borderWidth = borderWidth;
            (viewObject as! UIView).layer.borderColor = UIColor.gray.cgColor;
            if (setRoundedCorners)
            {
                (viewObject as! UIView).layer.cornerRadius = cornerRadius;
            }
        }
        if viewObject is UITextField
        {
            (viewObject as! UITextField).clipsToBounds = true;
            (viewObject as! UITextField).layer.borderWidth = borderWidth;
            (viewObject as! UITextField).layer.borderColor = UIColor.gray.cgColor;
            if (setRoundedCorners)
            {
                (viewObject as! UITextField).layer.cornerRadius = cornerRadius;
            }
        }

    }
    
    class func setTextFont(forLabel label:UILabel, textForSet:String)
    {
        if textForSet.characters.count > 15
        {
            label.font = label.font.withSize(22)
        }
        if textForSet.characters.count > 20
        {
            label.font = label.font.withSize(16)
        }
        label.text = textForSet
    }
    
    class func addBottomShadow(viewObject:AnyObject)
    {
        let shadowHeight:CGFloat = 20
        let imageView = UIImageView()
        imageView.image = UIImage(named: ConstantsStruct.kBlenda2Ciemny);
        var viewObjectFrame:CGRect;
      
        
        
        if viewObject is UIView
        {
            let view = viewObject as! UIView
            viewObjectFrame = CGRect(x:view.frame.origin.x, y: view.frame.height - 20,width: view.frame.width, height: shadowHeight)
            imageView.frame = viewObjectFrame;
            view.addSubview(imageView)
            
        }
        if viewObject is UIButton
        {
            let button = viewObject as! UIButton
            viewObjectFrame = CGRect(x: button.frame.origin.x, y: button.frame.height - 20, width:button.frame.width, height: shadowHeight)
            imageView.frame = viewObjectFrame;
            button.addSubview(imageView)
        }
    }
    
}
