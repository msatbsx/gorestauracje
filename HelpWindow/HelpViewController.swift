//
//  HelpViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD
import WebKit

class HelpViewController: RootViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var kupButton: UIButton!
    @IBOutlet weak var regulaminButton: UIButton!
    @IBOutlet weak var kupButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whatIsGooutButton: UIButton!
    var webView: WKWebView!
    var buttonClicked : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        shouldAddBackButton = true
        setupButtonViewLabels()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        addShadow()
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
        if buttonClicked == "whatIsGoingOut"
        {
            getInfo()
        }
        else
        {
            getRegulamin()
        }
        
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: kupButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: regulaminButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: whatIsGooutButton, setRoundedCorners: true, shouldHaveBorder: false);
        DispatchQueue.main.async {
            if AppManager.sharedInstance.isNewUser == true
            {
                self.kupButtonHeightConstraint.constant = 50
                self.kupButton.isHidden = false
            }
        }
    }
    
    func addShadow()
    {
        ViewConfigurator.addBottomShadow(viewObject: self.view)
        let shadowHeight:CGFloat = 20
        let imageView = UIImageView()
        imageView.image = UIImage(named: ConstantsStruct.kBlenda2Ciemny);
        var viewObjectFrame:CGRect;
        viewObjectFrame = CGRect(x: descriptionTextView.frame.origin.x,y: descriptionTextView.frame.height - 20 + descriptionTextView.frame.origin.y, width: descriptionTextView.frame.width, height: shadowHeight)
            imageView.frame = viewObjectFrame;
            view.addSubview(imageView)
    }
    
    @IBAction func navBackButtonClicked(_ sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func regulaminButtonClicked(_ sender: AnyObject)
    {
        getRegulamin()
    }
    
    @IBAction func whatIsGooutButtonClicked(_ sender: AnyObject)
    {
        getInfo()
    }
    
    func getInfo()
    {
        self.webView = WKWebView(frame: CGRect(x:0,y:0, width:UIScreen.main.bounds.width, height:self.descriptionTextView.frame.height))
        self.webView.backgroundColor = ConstantsStruct.Colors.backgroundColor
        self.descriptionTextView.addSubview(self.webView)
        self.webView.load(URLRequest(url: URL(string: "http://api.go-out.com.pl/info/about")!))
        self.whatIsGooutButton.isHidden = true

    }

    
    func getRegulamin()
    {
        if webView != nil
        {
            webView.removeFromSuperview()
        }
        RestClient.sharedInstance.getAppRules { (text, success) in
            DispatchQueue.main.async {
                if success
                {
                    self.descriptionTextView.text = text
                    HUD.hide()
                    self.whatIsGooutButton.isHidden = false
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
