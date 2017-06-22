//
//  MessageDetailViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 29/10/2016.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD
import WebKit

class MessageDetailViewController: RootViewController {

    var messageId:String?
    var buy_buttonText:String?
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var buyButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        shouldAddBackButton = true
        setupButtonViewLabels()
               // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        HUD.show(.progress)
        RestClient.sharedInstance.getDetailMessages(messageId: messageId!) { (messageObject, success) in
            DispatchQueue.main.async {
                if success
                {
                    self.messageTextView.text = messageObject?.title
                    if messageObject?.is_html == "1"
                    {
                        var webView: WKWebView!
                        webView = WKWebView(frame: CGRect(x:0,y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
                        webView.backgroundColor = ConstantsStruct.Colors.backgroundColor
                        self.messageTextView.addSubview(webView)
                        let requestObj = NSURLRequest(url: (messageObject?.urlFromMessage)! as URL);
                        webView.load(requestObj as URLRequest)
                        self.markAsRead()
                    }
                    else
                    {
                        let mesageContent = UITextView(frame: CGRect(x:0,y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
                        mesageContent.font = UIFont(name:"PTSans-Bold", size: 15.0)
                        mesageContent.backgroundColor = ConstantsStruct.Colors.backgroundColor
                        mesageContent.textColor = UIColor.white
                        self.messageTextView.addSubview(mesageContent)
                        mesageContent.text = messageObject?.content
                        self.markAsRead()
                    }
                    if self.buy_buttonText != nil
                    {
                        self.addBuyBatton()
                    }
                    HUD.hide()
                }
                else
                {
                    HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połączenia z siecią"))
                    HUD.hide(afterDelay: 2.0)
                }
            }
        }
    }
    
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: buyButton, setRoundedCorners: true, shouldHaveBorder: false);

        DispatchQueue.main.async {
            if AppManager.sharedInstance.isNewUser == true
            {
                self.buyButton.isHidden = false
            }
        }
    }
    
    func markAsRead()
    {
        RestClient.sharedInstance.confirmMessageIsRead(messageId: messageId!){ (messageObject, success) in
            DispatchQueue.main.async
            {
                    if success
                    {
                        print("Oznaczona jako przeczytana")
                    }
            }
        }
    }

    func addBuyBatton(){
        DispatchQueue.main.async
        {
            self.buyButton.setTitle( self.buy_buttonText! , for: UIControlState.normal)
            self.buyButton.isHidden = false
        }
    }
    
    @IBAction func buyButtonClicked(_ sender: Any)
    {
        let innAppPurchaseIdentifier = "InnAppPurchaseViewController"
        let storyboardIdentifier = "Main"
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let inAppPurchaseView = storyboard.instantiateViewController(withIdentifier: innAppPurchaseIdentifier)
        navigationController?.show(inAppPurchaseView, sender: nil);
    }
}
